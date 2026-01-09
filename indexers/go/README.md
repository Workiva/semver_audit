# Semver Audit Indexer: Go

A semver-audit indexer for go. This tool can generate semantic versioning information compatible with the semver-audit diff cli

## Installation

```console
go install github.com/Workiva/semver-audit/indexers/go/semver_audit_go
```

## Usage

```console
semver_audit_go generate ./path/to/dir ./path/to/another/dir
```

## Development

Note, the golang indexer is nested under `semver_audit_go` because golang makes the parent folder the name of the executable when running `go install`, and the parent directory of `go` is a reserved word