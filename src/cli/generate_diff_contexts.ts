import { globby } from 'globby';
import { DiffContext, SemverAuditReport } from '../core/models';
import fs from 'fs';
import { JSONParser } from '@streamparser/json-node';

/**
 * Given a list of paths for base and target semver-audit reports, returns a list of DiffContext
 * objects.
 *
 * Throws an exception if:
 * - a root entry is missing from the audit file (a root entry is determined by a null parent_key field)
 * - base contains a `package` that isn't found within target
 */
export async function buildDiffContexts(
  base: string[],
  target: string[],
): Promise<DiffContext[]> {
  const contexts: { [key: string]: DiffContext } = {};

  let [basePaths, targetPaths] = await Promise.all([
    globby(base),
    globby(target),
  ]);

  // escape hatch for golang support which declares multiple root keys
  // See FEDX-2033 for more information and proposed solution
  if (basePaths.length == 1 && targetPaths.length == 1) {
    let base = await readSemverAuditFile(basePaths[0]!);
    let target = await readSemverAuditFile(targetPaths[0]!);

    return [
      {
        language: base.language,
        base: base.exports,
        target: target.exports,
      },
    ];
  }

  const _buildContextKey = (report: SemverAuditReport) =>
    `${report.language}:${report.root_key}`;

  for (const basePath of await globby(base)) {
    let base = await readSemverAuditFile(basePath);
    contexts[_buildContextKey(base)] = {
      language: base.language,
      base: base.exports,
      target: {},
    };
  }

  for (const targetPath of await globby(target)) {
    let target = await readSemverAuditFile(targetPath);

    const key = _buildContextKey(target);
    contexts[key] ??= { language: target.language, base: {}, target: {} };
    contexts[key]!.target = target.exports;
  }

  return Object.values(contexts);
}

async function readSemverAuditFile(path: string): Promise<SemverAuditReport> {
  return new Promise((acc, rej) => {
    const stream = fs.createReadStream(path);

    const parser = new JSONParser({
      paths: ['$.indexer_version', '$.language', '$.root_key', '$.exports.*'],
    });
    stream.pipe(parser);

    const agg: SemverAuditReport = {
      indexer_version: '',
      language: '',
      root_key: '',
      exports: {},
    };
    parser.on('data', ({ key, value, parent, stack }) => {
      if (stack.length == 1) {
        switch (key) {
          case 'indexer_version':
            agg.indexer_version = value;
            break;
          case 'language':
            agg.language = value;
            break;
          case 'root_key':
            agg.root_key = value;
            break;
        }
      } else {
        agg.exports[key] = value;
      }
    });

    parser.on('error', rej);
    parser.on('close', () => acc(agg));
  });
}
