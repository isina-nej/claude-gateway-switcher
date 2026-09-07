<div align="center">

# Claude CLI, Free. 🐱⚡

### Turn Claude Code into a *free*, *gateway-agnostic* superpower — one command.

**Point Claude Code at ANY Anthropic-compatible gateway. Local LLMs, GLM, DeepSeek, Qwen — same CLI, zero vendor lock.**

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=21&pause=1200&color=FF6B35&center=true&vCenter=true&width=720&lines=cgw+setup+local+%E2%80%94+http%3A%2F%2Flocalhost%3A20128%2Fv1;cgw+%E2%80%94+Claude+Code+on+ANY+model%2C+FREE;cgw+use+work+%E2%86%94+cgw+use+local+%E2%80%94+instant+switch)](https://git.io/typing-svg)

![hero](assets/hero.png)

<p>
  <a href="#-install-30-seconds"><img src="https://img.shields.io/badge/Install-30s-FF6B35?style=for-the-badge" /></a>
  <a href="README.fa.md"><img src="https://img.shields.io/badge/🇮🇷_فارسی-README-00B398?style=for-the-badge" /></a>
  <a href="https://github.com/isina-nej/claude-gateway-switcher/stargazers"><img src="https://img.shields.io/github/stars/isina-nej/claude-gateway-switcher?style=for-the-badge&logo=github&label=Star" /></a>
</p>

<p>
  <img src="https://img.shields.io/badge/macOS-13%2B-000000?logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/Linux-Ubuntu%20%7C%20Debian%20%7C%20Alpine-FCC624?logo=linux&logoColor=black" />
  <img src="https://img.shields.io/badge/Windows-10%2B%20native-0078D6?logo=windows&logoColor=white" />
  <img src="https://img.shields.io/badge/WSL-2-4D4D4D?logo=linux&logoColor=white" />
  <img src="https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?logo=powershell&logoColor=white" />
  <img src="https://img.shields.io/badge/license-MIT-00C853" />
  <img src="https://img.shields.io/github/last-commit/isina-nej/claude-gateway-switcher?logo=github" />
</p>

**`cgw` = tiny profile launcher for [Claude Code](https://code.claude.com/docs/en/setup). Swap gateways, models & keys per-run — *without ever touching `~/.claude/settings.json`.***

<img src="assets/demo.gif" width="820" alt="cgw demo — setup, switch, run" />

*☝️ 30 seconds from clone to free Claude. No config file surgery.*

</div>

---

## 🤔 Wait — Claude CLI *free*? How?

Claude Code normally talks to Anthropic's API (paid). **`cgw` sits in front and redirects it** to any gateway that speaks the same Anthropic Messages API:

| Gateway | Cost | Example models |
|---|---|---|
| 🏠 **Local** (LiteLLM, Ollama proxy, LM Studio) | **FREE** | `glm-4.6`, `qwen2.5-coder`, `deepseek-v3` on your machine |
| 🇨🇳 **Z.AI / ModelScope / OpenRouter** | Free tier / cheap | `glm-4.6`, `deepseek-v3`, `qwen3` via `http://localhost:20128/v1` |
| 🏢 **Office / Team gateway** | Your infra | `claude-opus-4-6` via `https://gw.office.example` |

> **cgw doesn't host models — it unlocks the CLI so you can use *any* model *anywhere*. If your gateway is free, your Claude CLI is free.** 🎉

---

## ⚡ Install — 30 seconds

> **Pick your OS. That's the whole install section — everything else is usage.**

### 🍎 macOS / 🐧 Linux / 🐧 WSL

```bash
git clone https://github.com/isina-nej/claude-gateway-switcher.git claude-gateway-switcher
cd claude-gateway-switcher
./install.sh
# → symlinks bin/cgw → ~/.local/bin/cgw  (git pull keeps it fresh)
# → offers to create your `default` profile right away
```

> Requirements: `bash` + `claude` (Claude Code) in `PATH`. `curl` only for `cgw models`.

### 🪟 Windows — native PowerShell / CMD (no WSL, no Git Bash)

```powershell
git clone https://github.com/isina-nej/claude-gateway-switcher.git claude-gateway-switcher
cd claude-gateway-switcher
powershell -ExecutionPolicy Bypass -File install.ps1
# → copies cgw.ps1 + cgw.cmd → ~/.local/bin, adds to user PATH
# → offers to create your `default` profile right away
```

> Requirements: PowerShell 5.1+ (preinstalled on Win 10/11) + `claude` in `PATH`. Works in both PowerShell and CMD after install.
> Same CLI, same `.conf` format — copy profiles between Windows ↔ macOS ↔ Linux freely.

<details>
<summary>🔧 Manual / advanced install</summary>

- **Custom binary name:** `CLAUDE_BIN=/path/to/claude cgw`
- **Custom config dir:** `XDG_CONFIG_HOME=/my/config cgw` (also honored on Windows)
- **Verify install:** `cgw doctor` — checks binary, URL shape, key, permissions, `settings.json` conflicts

</details>

---

## 🎯 What does `cgw` *actually* do?

<img src="assets/how-it-works.png" width="820" alt="how cgw works — load profile, export env, launch claude" />

When you type `cgw`, exactly **3 things** happen — nothing more:

```text
1. Load active profile      →  BASE_URL + MODEL_ID + (optional) API_KEY
2. Export env for this run  →  ANTHROPIC_BASE_URL, ANTHROPIC_MODEL
                               + ANTHROPIC_AUTH_TOKEN or ANTHROPIC_API_KEY (only if key set)
                               + CLAUDE_CODE_USE_GATEWAY=1 (if discovery enabled)
3. Launch Claude Code       →  claude --model "<MODEL_ID>"  + your extra args
```

✅ `~/.claude/settings.json` is **never read, never written, never merged.**  
✅ Uninstalling `cgw` leaves Claude Code exactly as it was.  
✅ Each `cgw` invocation is isolated — no global env pollution.

### Why profiles > editing `settings.json`?

| 😫 Without cgw | 😎 With cgw |
|---|---|
| Copy-paste URLs & keys every time you switch gateways | `cgw setup work` / `setup local` → `cgw use local` |
| Keyless local gateway chokes on empty `Authorization:` header | No key → **no auth vars, no auth headers.** Clean. |
| Accidentally commit a key to your dotfiles repo | Profiles live outside git, `600` permissions, `.gitignore`'d |
| `settings.json` model-pinning bugs across Claude versions | Model passed explicitly `claude --model …` every run |
| Need WSL/Git Bash hacks on Windows | Native `cgw.ps1` + `cgw.cmd` — just works |

---

## 🚀 60-Second Tour

```bash
# 1 — keyless LOCAL profile (URL is pre-filled: http://localhost:20128/v1)
cgw setup local
#   Gateway base URL (e.g. http://localhost:20128/v1) [http://localhost:20128/v1]:
#   API key [optional, Enter to skip]:
#   Model ID: glm-4.6

# 2 — OFFICE gateway that needs a key
cgw setup work
#   Gateway base URL: https://gw.office.example
#   API key [optional, Enter to skip]: ********
#   Auth type: 1) Bearer token  2) x-api-key [1]: 1
#   Model ID: claude-opus-4-6

# 3 — switch & go
cgw use local
cgw                            # interactive Claude on local gateway (FREE)
cgw -p "explain this repo"     # non-interactive — args pass straight through
cgw run work -- -p "fix tests" # one-off run on a different profile
cgw models                     # test gateway: GET <BASE_URL>/v1/models
```

<img src="assets/profiles.png" width="820" alt="multiple profiles — local, work, fast" />

> 💡 **Tip:** Paste `http://localhost:20128/v1` with the trailing `/v1` — `cgw` strips it automatically. Empty key = `auth: none`, the auth-type question is skipped entirely.

---

## 📖 All Commands — Cheat Sheet

```bash
cgw setup [name]          # interactive wizard  (default: default)
cgw edit [name]           # re-run wizard — Enter keeps value, "-" clears the key
cgw use <name>            # make a profile active  ★
cgw list                  # list profiles  (* = active)
cgw show [name]           # print profile (key masked as abcd…wxyz)
cgw models [name]         # GET <BASE_URL>/v1/models — connectivity + auth check
cgw doctor [name]         # health check: binary, URL, key, perms, settings.json
cgw run [name] -- [args]  # run a profile with extra claude args
cgw delete <name>         # delete a profile
cgw [args...]             # anything else → claude args on active profile
```

**Shortcuts baked in:**
- Default URL `http://localhost:20128/v1` pre-filled in wizard
- Trailing `/v1` / `/v1/` auto-stripped
- `cgw -p "hello"` == `cgw run active -- -p "hello"`

---

## 🔑 Keyless Gateways — First-Class, Not an Afterthought

Most local gateways need **no key**. `cgw` treats that as normal:

- `cgw show` → `API key: (not set)`
- `cgw doctor` → `[..] No API key set (connecting without auth)` — not an error
- Runtime → **no** `ANTHROPIC_AUTH_TOKEN` / `ANTHROPIC_API_KEY` exported
- `cgw models` → **no** `Authorization` / `x-api-key` header sent
- `cgw edit` → type `-` to clear a previously saved key

Perfect for `localhost` gateways where auth just gets in the way.

---

## 💾 Where Profiles Live

```text
~/.config/claude-gateway-switcher/profiles/*.conf      # macOS / Linux / WSL
%APPDATA%\claude-gateway-switcher\profiles\*.conf      # Windows
# $XDG_CONFIG_HOME wins if set, then $HOME\.config
```

| Platform | Permissions | Notes |
|---|---|---|
| Unix | files `600`, dirs `700` | Key never enters this repo |
| Windows | NTFS ACL (user-only) | Same `.conf` format, LF/no-BOM, single-quote style |
| Cross-OS | — | Bash `source`s PS files as-is; bash tolerates CRLF; PS parses all bash `%q` spellings (`bare`, `'...'`, `$'...'`, `"..."`) — **copy profiles freely** |

---

## 🌐 Gateway Requirements

Any gateway speaking the **Anthropic Messages API** (what Claude Code uses). Tested with LiteLLM, OpenRouter, Z.AI, ModelScope, custom proxies.

Optional discovery probe:

```text
GET <BASE_URL>/v1/models
```

Run `cgw models` any time to test. Auth headers attached **only** when a key is stored. Enable discovery with the wizard's last question → exports `CLAUDE_CODE_USE_GATEWAY=1` + `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`.

---

## 🔒 Security

- 🔐 **Never commit keys** — profiles live outside the repo by design
- 🌐 Prefer `https://` for remote gateways; `http://localhost:*` is fine for local
- 👁️ `cgw models` contacts your gateway **only** when you explicitly run it
- ⚠️ Treat the gateway operator as trusted — prompts & code you send may be visible to that service

---

## 🧹 Uninstall

```bash
./uninstall.sh                                            # macOS / Linux / WSL
powershell -ExecutionPolicy Bypass -File uninstall.ps1    # Windows
```

Removes the command, **keeps profiles on purpose.** To wipe credentials too:

```bash
rm -rf ~/.config/claude-gateway-switcher/          # Unix
Remove-Item -Recurse $env:APPDATA\claude-gateway-switcher  # Windows
```

---

## ❓ FAQ

<details>
<summary><b>Is Claude Code really free with cgw?</b></summary>

`cgw` itself is free & open-source. Whether *inference* is free depends on your gateway. Point it at a local model or a gateway with a free tier (e.g. GLM-4.6 on Z.AI) → zero cost. Point it at Anthropic directly → normal billing.

</details>

<details>
<summary><b>Does cgw modify my Claude Code settings?</b></summary>

Never. It only sets env vars for the child `claude` process. Your `~/.claude/settings.json` is untouched. That's the whole point.

</details>

<details>
<summary><b>Can I use different models per profile?</b></summary>

Yes — each profile stores its own `MODEL_ID`. `cgw setup fast` with `glm-4-flash`, `cgw setup max` with `claude-opus-4-6`, switch with `cgw use fast`.

</details>

<details>
<summary><b>Windows without WSL — really?</b></summary>

Really. `bin/cgw.ps1` runs on stock PowerShell 5.1, `bin/cgw.cmd` is a CMD shim. No Git Bash, no WSL, no admin needed.

</details>

---

<div align="center">

### ⭐ If `cgw` saved you from `settings.json` hell, star the repo!

**`cgw setup local` → `cgw` → free Claude CLI. That's the whole pitch.**

*Made with ❤️ for everyone who just wants `claude` to point somewhere else.*

[Report Bug](https://github.com/isina-nej/claude-gateway-switcher/issues) · [Request Feature](https://github.com/isina-nej/claude-gateway-switcher/issues) · [English](README.md) · [فارسی](README.fa.md)

</div>
