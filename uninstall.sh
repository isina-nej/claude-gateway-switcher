#!/usr/bin/env bash
set -euo pipefail
rm -f "$HOME/.local/bin/cgw"
printf 'Removed ~/.local/bin/cgw\n'
printf 'Profiles were kept in ~/.config/claude-gateway-switcher/\n'
printf 'To remove them too, delete that directory manually.\n'
