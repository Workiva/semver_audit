#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
ROOT=$(git rev-parse --show-toplevel)

(cd "$ROOT/indexers/dart" && dart pub get)

pushd "$SCRIPT_DIR/base" || exit
dart pub get
dart "$ROOT/indexers/dart/bin/semver_audit.dart" generate ./ > report.json
popd || exit

pushd "$SCRIPT_DIR/target" || exit
dart pub get
dart "$ROOT/indexers/dart/bin/semver_audit.dart" generate ./ > report.json
popd || exit

bun run dev -b "$SCRIPT_DIR/base/report.json" -t "$SCRIPT_DIR/target/report.json" --format=markdown > "$SCRIPT_DIR/gold.md"