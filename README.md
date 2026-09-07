<div align="center">

# Claude CLI, free. 🐱

### Point Claude Code at ANY Anthropic-compatible gateway with one command.

![hero](assets/hero.png)

[![macOS](https://img.shields.io/badge/macOS-13%2B-000000?logo=apple)](https://github.com/isina-nej/claude-gateway-switcher)
[![Linux](https://img.shields.io/badge/Linux-Ubuntu%20%7C%20Debian%20%7C%20Alpine-FCC624?logo=linux&logoColor=black)](https://github.com/isina-nej/claude-gateway-switcher)
[![Windows](https://img.shields.io/badge/Windows-10%2B%20native-0078D6?logo=windows&logoColor=white)](https://github.com/isina-nej/claude-gateway-switcher)
[![WSL](https://img.shields.io/badge/WSL-2-4D4D4D?logo=linux&logoColor=white)](https://github.com/isina-nej/claude-gateway-switcher)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

**🇮🇷 [نسخه فارسی](README.fa.md)**

`cgw` is a tiny profile-based launcher for [Claude Code](https://code.claude.com/docs/en/setup).
It swaps gateways, models and keys per run — **without ever touching your `~/.claude/settings.json`.**

![demo](assets/demo.gif)

</div>

---

## ⚡ Install (30 seconds)

Pick your OS. That's the whole install section — everything else below is usage.

### 🍎 macOS / 🐧 Linux / 🐧 WSL

```bash
git clone https://github.com/isina-nej/claude-gateway-switcher.git claude-gateway-switcher
cd claude-gateway-switcher
./install.sh
# → symlinks bin/cgw to ~/.local/bin/cgw (git pull keeps it fresh)
# → offers to create your `default` profile on the spot
```

Requirements: `bash`, `claude` (Claude Code) in `PATH`. `curl` only needed for `cgw models`.

### 🪟 Windows (native PowerShell or CMD — no WSL, no Git Bash)

```powershell
git clone https://github.com/isina-nej/claude-gateway-switcher.git claude-gateway-switcher
cd claude-gateway-switcher
powershell -ExecutionPolicy Bypass -File install.ps1
# → copies cgw.ps1 + cgw.cmd to ~/.local/bin, adds it to your user PATH
# → offers to create your `default` profile on the spot
```

Requirements: PowerShell 5.1+ (ships with Windows 10/11), `claude` in `PATH`. Works in both PowerShell and CMD afterwards.

---

## 🎯 What does it actually do?

![how it works](assets/how-it-works.png)

When you type `cgw`, exactly three things happen — nothing more:

1. **Loads the active profile** → base URL + model + (optional) key.
2. **Exports env vars for that run only** → `ANTHROPIC_BASE_URL`, `ANTHROPIC_MODEL`, and (only if a key is set) `ANTHROPIC_AUTH_TOKEN` or `ANTHROPIC_API_KEY`. Optional discovery adds `CLAUDE_CODE_USE_GATEWAY=1` + `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`.
3. **Launches Claude Code** → `claude --model "<MODEL_ID>"` with any extra args you passed through.

Your `~/.claude/settings.json` is never read, never written, never merged. Uninstalling `cgw` leaves Claude Code exactly as it was.

### Why profiles instead of editing settings?

| Pain | `cgw` fix |
|---|---|
| Office gateway, home gateway, free local gateway — constant copy-paste of URLs and keys | `cgw setup work` / `setup home` / `setup local`, then `cgw use local` |
| Keyless local gateway chokes on empty auth headers | No key → no auth vars, no auth headers. Period. |
| Accidentally committing a key into a dotfiles repo | Profiles live outside git in `600`-permission files |
| `settings.json` model-pinning bugs across Claude versions | Model passed explicitly as `claude --model …` every run |

---

## 🚀 60-second tour

```bash
# 1. Create a keyless local profile (default URL is already filled in)
cgw setup local
#   Gateway base URL (e.g. http://localhost:20128/v1) [http://localhost:20128/v1]:
#   API key [optional, Enter to skip]:
#   Model ID: glm-4.6

# 2. Create a second one for the office gateway that needs a key
cgw setup work
#   Gateway base URL (e.g. http://localhost:20128/v1): https://gw.office.example
#   API key [optional, Enter to skip]: ********
#   Auth type: 1) Bearer token  2) x-api-key [1]: 1
#   Model ID: claude-opus-4-6

# 3. Switch and go
cgw use local
cgw                          # interactive Claude on the local gateway
cgw -p "explain this repo"   # non-interactive, args pass straight through
cgw run work -- -p "fix the tests"   # one-off run on another profile
```

![profiles](assets/profiles.png)

---

## 📖 All commands

```bash
cgw setup [name]    # interactive profile wizard (default name: default)
cgw edit [name]     # re-run the wizard; Enter keeps a value, - clears the key
cgw use <name>      # set the active profile
cgw list            # list profiles (* = active)
cgw show [name]     # print a profile, key masked
cgw models [name]   # GET <BASE_URL>/v1/models — connectivity + auth check
cgw doctor [name]   # claude binary, URL shape, key presence, perms, settings.json conflicts
cgw run [name] -- [args]  # run a profile with extra claude args
cgw delete <name>   # delete a profile
cgw [args...]       # unknown args are claude args on the active profile
```

Defaults that save typing: setup prefills `http://localhost:20128/v1` as the URL; pasting a URL with a trailing `/v1` is stripped automatically; empty key means `auth: none` and the auth-type question is skipped entirely.

---

## 🔑 Keyless gateways, first-class

Many local gateways need no key at all. `cgw` treats that as normal, not an error:

- `cgw show` prints `API key: (not set)`, `cgw doctor` prints `[..] No API key set (connecting without auth)`.
- At runtime **no** `ANTHROPIC_AUTH_TOKEN` / `ANTHROPIC_API_KEY` is exported, and `cgw models` sends **no** auth header.
- `cgw edit` + `-` clears a previously saved key.

---

## 💾 Where profiles live

```text
~/.config/claude-gateway-switcher/profiles/*.conf      # macOS / Linux / WSL
%APPDATA%\claude-gateway-switcher\profiles\*.conf      # Windows
```

- Unix: files `600`, dirs `700`. The key never enters this repo (`.gitignore` blocks `*.conf`).
- Windows honors `$env:XDG_CONFIG_HOME` first, then `%APPDATA%`, then `$HOME\.config`.
- Same `.conf` format on both sides: PowerShell writes LF/no-BOM single-quote style that bash sources as-is; bash tolerates CRLF if you hand-edit a file on Windows; bash `%q` spellings (bare, `'...'`, `$'...'`, `"..."`) all parse in PowerShell. Copy profiles between OSes freely.

---

## 🌐 Gateway requirements

Any gateway speaking the Anthropic Messages API that Claude Code uses. The optional discovery check hits:

```text
GET <BASE_URL>/v1/models
```

Test it any time with `cgw models`. Auth headers are attached only when a key is stored.

---

## 🔒 Security notes

- Never commit API keys — profiles live outside the repo by design.
- Prefer `https://` for remote gateways; `http://localhost:*` is fine for local ones.
- `cgw models` contacts your gateway **only** when you run it explicitly.
- Treat the gateway operator as trusted: prompts and code you send may be visible to that service.

---

## 🧹 Uninstall

```bash
./uninstall.sh                                            # macOS / Linux / WSL
powershell -ExecutionPolicy Bypass -File uninstall.ps1    # Windows
```

Removes the command, keeps profiles on purpose. Delete `~/.config/claude-gateway-switcher/` (or `%APPDATA%\claude-gateway-switcher\`) to wipe credentials too.

---

<div align="center">

**If `cgw` saved you from settings.json hell, ⭐ star the repo.**

`cgw setup local` → `cgw` → free Claude CLI. That's the whole pitch.

</div>
