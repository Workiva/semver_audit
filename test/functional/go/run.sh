#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
ROOT=$(git rev-parse --show-toplevel)

(cd "$ROOT/indexers/go/semver_audit_go" && go build)

"$ROOT/indexers/go/semver_audit_go/semver_audit_go" generate "$SCRIPT_DIR/base" > "$SCRIPT_DIR/base/report.json"
"$ROOT/indexers/go/semver_audit_go/semver_audit_go" generate "$SCRIPT_DIR/target" > "$SCRIPT_DIR/target/report.json"

bun run dev -b "$SCRIPT_DIR/base/report.json" -t "$SCRIPT_DIR/target/report.json" --format=markdown > "$SCRIPT_DIR/gold.md"
