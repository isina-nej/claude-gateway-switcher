# Claude Gateway Switcher (`cgw`)

A tiny profile-based launcher for Claude Code + Anthropic-compatible gateways.

It lets a user clone the repo, run one installer, enter:

- Gateway base URL
- API key
- Auth type (`Bearer` or `x-api-key`)
- Model ID
- Optional gateway model discovery

Then the user can simply run:

```bash
cgw
```

Works on macOS / Linux / WSL (`bin/cgw`, bash) and native Windows
(`bin/cgw.ps1` + `bin/cgw.cmd`, PowerShell 5.1+, no Git Bash/WSL needed).
Both sides share the same CLI and the same `.conf` profile format, so
profiles can be copied between OSes.

## Install

### macOS / Linux / WSL

```bash
git clone <YOUR_REPO_URL> claude-gateway-switcher
cd claude-gateway-switcher
./install.sh
```

The installer symlinks `bin/cgw` to `~/.local/bin/cgw`, so `git pull` updates the installed command too.

### Windows (native PowerShell or CMD)

```powershell
git clone <YOUR_REPO_URL> claude-gateway-switcher
cd claude-gateway-switcher
powershell -ExecutionPolicy Bypass -File install.ps1
```

This copies `bin/cgw.ps1` + `bin/cgw.cmd` to `~/.local/bin`, adds it to
your user PATH, then offers to create the `default` profile. Afterwards
`cgw` works in both PowerShell and CMD.

## Commands

Same on every OS:

```bash
cgw setup default
cgw edit default
cgw use default
cgw list
cgw show
cgw models
cgw doctor
cgw
```

Pass normal Claude Code arguments through:

```bash
cgw -p "explain this repository"
cgw run default -- -p "fix the tests"
```

## Multiple gateways / models

Create profiles:

```bash
cgw setup work
cgw setup local
cgw setup fast
```

Switch active profile:

```bash
cgw use work
```

Then:

```bash
cgw
```

## Where credentials are stored

Profiles live outside the Git repository:

```text
~/.config/claude-gateway-switcher/profiles/*.conf      # macOS / Linux / WSL
%APPDATA%\claude-gateway-switcher\profiles\*.conf      # Windows
```

On Windows `$env:XDG_CONFIG_HOME` wins if set, then `$HOME\.config\`.
Each profile is created with permission `600` on Unix; the config directories use `700` where supported.

The API key is never written to this repository.

The PowerShell side writes LF, no-BOM, single-quote style files that bash
sources as-is; the bash side tolerates CRLF if a profile was hand-edited
on Windows. Bash `%q` values (bare words, `'...'`, `$'...'`, `"..."`)
all load in PowerShell.

## What gets exported when Claude starts

Depending on the selected auth type, `cgw` exports:

```text
ANTHROPIC_BASE_URL
ANTHROPIC_MODEL
ANTHROPIC_AUTH_TOKEN   # Bearer mode
```

or:

```text
ANTHROPIC_BASE_URL
ANTHROPIC_MODEL
ANTHROPIC_API_KEY      # x-api-key mode
```

If gateway model discovery is enabled, it also exports:

```text
CLAUDE_CODE_USE_GATEWAY=1
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
```

Finally it launches Claude Code with the explicit model:

```bash
claude --model "$MODEL_ID"
```

## Why a wrapper instead of overwriting `~/.claude/settings.json`?

- It doesn't destroy or merge users' existing Claude Code configuration.
- It makes multiple gateway/model profiles easy.
- Secrets stay in one dedicated per-user location.
- Updating a profile is just `cgw edit`.
- Removing this tool doesn't require restoring Claude settings.

## Gateway expectations

The gateway should be compatible with the Anthropic Messages API used by Claude Code. Optional model listing uses:

```text
GET <BASE_URL>/v1/models
```

`cgw models` can be used to test that endpoint.

## Security notes

- Do not commit API keys.
- Use HTTPS for remote gateways.
- `cgw show` masks the stored key.
- `cgw models` sends the configured credential to the configured gateway only when the user explicitly runs the command.
- Treat the gateway operator as trusted: prompts and code sent through the gateway may be visible to that service.

## Uninstall

```bash
./uninstall.sh                                            # macOS / Linux / WSL
powershell -ExecutionPolicy Bypass -File uninstall.ps1    # Windows
```

This removes the command but intentionally keeps profiles. Delete the
config directory manually if you also want to delete stored credentials
(`~/.config/claude-gateway-switcher/` or `%APPDATA%\claude-gateway-switcher\`).
