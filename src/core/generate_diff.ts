import { DiffContext, DiffResult, Semver } from './models';
import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  Grammar,
  RemovedApiNode,
  SemverAuditPlugin,
} from './plugin_interface';

export function generateDiff(
  plugins: SemverAuditPlugin[],
  { base, target }: DiffContext,
): DiffResult {
  let semver: DiffResult = {};

  // Keep a cache of all generated nodes so we can de-duplicate
  // parent nodes
  let nodeCache: { [key: string]: ApiNode<Grammar> } = {};
  function buildApiNode(key: string): ApiNode<Grammar> {
    if (nodeCache[key]) return nodeCache[key]!;

    let parentKey = target[key]?.parent_key ?? base[key]?.parent_key;

    // some indexers use `parent_key: ""`, treat this as undefined
    if (parentKey == '') parentKey = undefined;

    nodeCache[key] = new ApiNode({
      type: target[key]?.type ?? base[key]?.type!,
      base: base[key]?.grammar,
      target: target[key]?.grammar,
      ancestor: parentKey != null ? buildApiNode(parentKey) : undefined,
    });

    return nodeCache[key]!;
  }

  function _addToResults(
    key: string,
    event: (plugin: SemverAuditPlugin) => Semver[],
  ) {
    let results = plugins.map((plugin) => event(plugin)).flat();
    if (results.length <= 0) return;
    semver[key] = results;
  }

  let allKeys = new Set([...Object.keys(base), ...Object.keys(target)]);
  for (let key of allKeys) {
    let node = buildApiNode(key);

    if (base[key] == null && target[key] != null) {
      // the node was added
      _addToResults(key, (plugin) =>
        plugin.onAdd(node as AddedApiNode<Grammar>),
      );
    } else if (base[key] != null && target[key] == null) {
      // the node was removed
      _addToResults(key, (plugin) =>
        plugin.onRemove(node as RemovedApiNode<Grammar>),
      );
    } else if (base[key]!.type != target[key]!.type) {
      // the node's type was changed, this is always a major
      semver[key] = [
        Semver.major(
          `${key} type was changed from ${base[key]!.type} to ${target[key]!.type}`,
        ),
      ];
    } else {
      // the node exists in both base and target
      _addToResults(key, (plugin) =>
        plugin.onChange(node as ChangedApiNode<Grammar>),
      );
    }
  }

  return semver;
}
