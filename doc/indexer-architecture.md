## Indexer Architecture

> [!NOTE]
> The following is specific documentation about semver-audit indexers. For an overview of semver-audit as a whole, please see [README.md](/README.md#development)


The job of an indexer is to output the public api of a package. This is often implemented as a cli in the language it is indexing so it can leverage the ast/analysis tools that often already exist. semver-audit-dart for example, makes heavy usage of the [analyzer](https://pub.dev/packages/analyzer) package

Execution and arguments for these indexers is up to authors, but generally its best to follow a consistent api of a `generate` subcommand which accepts a path or paths to directories that should be indexed 

```console
$ semver-audit-examplelang generate ./path/to/root > report.json
```

The generated report _must_ adhere to the following output format:

```js
{
    // The schema version, currently always '1'
    "version": 1,

    // the language that this report was indexed for
    "language": string,

    // A unique key, per index file. Structure is language-specific
    "root_key": string,

    // The version of the indexer that was used to generate this report
    "indexer_version": string,

    "exports": {
        "key": {
            // Unique key. Structure is language-specific.
            "key": string,

            // Key of the parent element, if one exists.
            "parent_key": string | null,

            // Type of API member. Comparison tool can use this
            // in tandem with language rules to perform more
            // intelligent analysis of changes.
            "type": string,

            // Representation of the API member.
            "grammar": {
                // String representation of the API member.
                // Used primarily when displaying diffs.
                "signature": string

                // The rest of this object is dependent on the type
                // of API member (field, method, class, etc).
            },

            // Meta information that is irrelevant to the
            // public API diffing, but useful for context.
            //
            // Note: this could be used to dedupe across
            // entry points.
            "meta": {
                "line": number,
                "uri": string
            }
        },
        // ...
    }
}
```