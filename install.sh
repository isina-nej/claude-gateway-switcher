#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/cgw"

mkdir -p "$BIN_DIR"
ln -sfn "$ROOT_DIR/bin/cgw" "$TARGET"
chmod +x "$ROOT_DIR/bin/cgw"

printf 'Installed cgw -> %s\n' "$TARGET"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    printf '\nNOTE: %s is not currently in PATH.\n' "$BIN_DIR"
    printf 'Add this to your shell profile, then reopen the terminal:\n'
    printf '  export PATH="$HOME/.local/bin:$PATH"\n\n'
    ;;
esac

if ! command -v claude >/dev/null 2>&1; then
  printf 'Warning: Claude Code was not found in PATH. You can configure cgw now and install Claude Code separately.\n'
fi

read -r -p 'Create the default gateway profile now? [Y/n]: ' ans
case "${ans:-Y}" in
  y|Y|yes|YES)
    "$TARGET" setup default
    read -r -p 'Start Claude with this profile now? [y/N]: ' start
    case "${start:-N}" in y|Y|yes|YES) exec "$TARGET" ;; esac
    ;;
esac
