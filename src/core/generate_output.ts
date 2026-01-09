import chalk from 'chalk';
import { diffLines } from 'diff';
import { DiffContext, DiffResult, Semver, SemverAuditEntries } from './models';

export function generateOutput(
  diff: DiffResult,
  diffCtx: DiffContext,
  format: string,
): string | { [key: string]: any } {
  switch (format) {
    case 'text':
      return outputAsText(diff, diffCtx);
    case 'markdown':
      return outputAsMarkdown(diff, diffCtx);
    case 'json':
      return outputAsJson(diff, diffCtx);
    default:
      throw Error(`Unsupported format: ${format}`);
  }
}

export function outputAsText(
  diff: DiffResult,
  { base, target }: DiffContext,
  colorize: boolean = true,
): string {
  let tree = buildOutputTree(diff, base, target);

  let output = '\n';

  function appendToOutput(str: string, color?: (str: string) => string) {
    if (color != null && colorize) {
      output += color(str.trimEnd()) + '\n';
    } else {
      output += str.trimEnd() + '\n';
    }
  }

  const aux = (
    tree: OutputTreeNode,
    parentKey: string | undefined,
    depth: number,
  ) => {
    for (let [key, value] of tree.entries()) {
      let entry = target[key] ?? base[key]!;

      if (entry.grammar.signature == null) {
        aux(value, key, depth);
        continue;
      }

      // a null parent signature, implies that the parent of this entry
      // is a "file" or "package". Emit the header for this element in that situation
      let parent = target[parentKey ?? ''] ?? base[parentKey ?? ''];
      if (parent != null && parent.grammar.signature == null) {
        appendToOutput(
          `@@ ${parent.key} <-- ${entry.meta.uri}#L${entry.meta.line} @@`,
          chalk.magenta,
        );
      }

      if (diff[key] == null) {
        appendToOutput(setIndent(entry.grammar.signature, 3), chalk.dim);
        aux(value, key, depth + 1);
        continue;
      }

      let indent = depth * 2;
      let signatureDiff = diffLines(
        base[key]?.grammar.signature ?? '',
        target[key]?.grammar.signature ?? '',
      );
      for (let lineDiff of signatureDiff) {
        if (lineDiff.added) {
          appendToOutput(setIndent(lineDiff.value, indent, '+  '), chalk.green);
        } else if (lineDiff.removed) {
          appendToOutput(setIndent(lineDiff.value, indent, '-  '), chalk.red);
        } else {
          appendToOutput(setIndent(lineDiff.value, indent));
        }
      }

      diff[key]?.forEach((sem) =>
        appendToOutput(setIndent(sem.reason!, indent, '// '), chalk.cyan),
      );
      appendToOutput('');
    }
  };

  aux(tree, undefined, 0);

  return output;
}

export function outputAsMarkdown(diff: DiffResult, diffCtx: DiffContext) {
  let text = outputAsText(diff, diffCtx, false);

  let chunks = text
    .split(/^@@/gm)
    .filter((chunk) => chunk.trim().length != 0)
    .map((chunk) => `@@${chunk}`.trim());

  let markdown = [
    ...chunks.splice(0, 5).map((chunk) => `\`\`\`diff\n${chunk}\n\`\`\``),
  ];

  if (chunks.length > 0) {
    markdown = [
      ...markdown,
      '<details>',
      '  <summary>Expand</summary>',
      '', // empty line needed for markdown to correctly render this collapsed region
      ...chunks.map((chunk) => `\`\`\`diff\n${chunk}\n\`\`\``),
      '</details>',
      '', // empty line needed for markdown to correctly render this collapsed region
    ];
  }

  return markdown.join('\n');
}

export function outputAsJson(
  diff: DiffResult,
  { base, target }: DiffContext,
): { [key: string]: any }[] {
  let output: {
    key: string;
    line?: number;
    uri?: string;
    level: string;
    reason: string[];
  }[] = [];

  for (let [key, semver] of Object.entries(diff)) {
    let level = calculateSemverLevel(semver);

    // do not display patch only changes
    if (level == 'patch') continue;

    let entry = target[key] ?? base[key]!;

    let reason =
      diff[key]?.map(({ reason }) => reason).filter((r) => r != null) ?? [];
    if (reason != null) {
      output.push({
        key,
        line: entry.meta.line,
        uri: entry.meta.uri,
        level,
        reason: reason as string[],
      });
    }
  }

  return output;
}

type OutputTreeNode = Map<string, OutputTreeNode>;

/*
 * Returns a tree representation of the diff. Ignores any patch changes and is in the
 * format of: {"key": {"child_key": {}}}
 *
 * This object can be used to easily determine parent/child relationships and whether
 * child node output should be merged with a single parent
 **/
function buildOutputTree(
  diff: DiffResult,
  base: SemverAuditEntries,
  target: SemverAuditEntries,
): OutputTreeNode {
  let keys = Object.keys(diff).filter(
    (key) => calculateSemverLevel(diff[key]!) != 'patch',
  );

  keys.sort();

  let tree = new Map<string, OutputTreeNode>();
  for (let key of keys) {
    let entry = target[key] ?? base[key];
    if (entry == null) {
      throw Error(`Key "${key}" not found in either base or target`);
    }

    let full_key = [entry.key];
    let iter = entry;
    while (iter.parent_key != null && iter.parent_key != '') {
      iter = target[iter.parent_key] ?? base[iter.parent_key]!;
      full_key.unshift(iter.key);
    }

    let treeIter = tree;
    for (let k of full_key) {
      if (!treeIter.has(k)) {
        treeIter.set(k, new Map());
      }
      treeIter = treeIter.get(k)!;
    }
  }
  return tree;
}

export function generateRecommendation(diffs: DiffResult[], format: string) {
  let allSemver = diffs.flatMap<Semver>(Object.values).flat();
  let level = calculateSemverLevel(allSemver);

  // if the format is "markdown", use shields.io to create a badge style
  // display for the semver rec
  if (format == 'markdown') {
    let color = 'green';
    if (level == 'major') {
      color = 'red';
    } else if (level == 'minor') {
      color = 'yellow';
    }
    return `![${level}](https://img.shields.io/badge/${level}-${color})`;
  }

  return level;
}

// ---------------------------------- Utils ----------------------------------

function calculateSemverLevel(vers: Semver[]) {
  let levels = new Set(vers.map(({ level }) => level));

  if (levels.has('major')) {
    return 'major';
  } else if (levels.has('minor')) {
    return 'minor';
  } else {
    return 'patch';
  }
}

export function setIndent(str: string, indent: number, prefix: string = '') {
  return stripIndent(str)
    .split('\n')
    .map((line) => `${prefix}${' '.repeat(indent)}${line}`)
    .join('\n');
}

function stripIndent(string: string) {
  const match = string.match(/^[ \t]*(?=\S)/gm);
  let indent = match!.reduce((r, a) => Math.min(r, a.length), Infinity);
  if (indent === 0) {
    return string;
  }

  const regex = new RegExp(`^[ \\t]{${indent}}`, 'gm');
  return string.replace(regex, '');
}
