# Semver Audit Indexer: Dart

A semver-audit indexer for dart. This executable will generate a representation of any Dart package's public api that can be analyzed by the semver-audit diff cli

## Installation

```console
pub global activate semver_audit
```

## Usage

```console
dart pub run semver_audit generate ./ > report.json
```