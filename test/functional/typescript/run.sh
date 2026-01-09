#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
ROOT=$(git rev-parse --show-toplevel)

pushd "$SCRIPT_DIR/base" || exit
pnpm install
bun "$ROOT/indexers/typescript/src/cli.ts" ./ --entrypoint ./src/index.ts > report.json
popd || exit

pushd "$SCRIPT_DIR/target" || exit
pnpm install
bun "$ROOT/indexers/typescript/src/cli.ts" ./ --entrypoint ./src/index.ts > report.json
popd || exit

bun run dev -b "$SCRIPT_DIR/base/report.json" -t "$SCRIPT_DIR/target/report.json" --format=markdown > "$SCRIPT_DIR/gold.md"