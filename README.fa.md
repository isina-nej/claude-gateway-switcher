<div dir="rtl" align="center">

# کلاد CLI رایگان 🐱⚡

### کلاد کد را با یک دستور به هر گیت‌وی سازگار با Anthropic وصل کن — *رایگان، بدون قفل فروشنده.*

**کلاد کد را به هر گیت‌وی سازگار وصل کن. مدل‌های لوکال، GLM، DeepSeek، Qwen — یک CLI، صفر وابستگی.**

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Vazirmatn&weight=600&size=20&pause=1200&color=FF6B35&center=true&vCenter=true&width=700&lines=cgw+setup+local+%E2%80%94+http%3A%2F%2Flocalhost%3A20128%2Fv1;cgw+%E2%80%94+%DA%A9%D9%84%D8%A7%D8%AF+%D8%B1%D9%88%DB%8C+%D9%87%D8%B1+%D9%85%D8%AF%D9%84%D8%8C+%D8%B1%D8%A7%DB%8C%DA%AF%D8%A7%D9%86;cgw+use+work+%E2%86%94+cgw+use+local+%E2%80%94+%D8%B3%D9%88%DB%8C%DB%8C%DA%86+%D9%84%D8%AD%D8%B8%D9%87%E2%80%8C%D8%A7%DB%8C)](https://git.io/typing-svg)

![hero](assets/hero.png)

<p>
  <a href="#نصب-در-۳۰-ثانیه"><img src="https://img.shields.io/badge/نصب-۳۰_ثانیه-FF6B35?style=for-the-badge" /></a>
  <a href="README.md"><img src="https://img.shields.io/badge/🇬🇧_English-README-00B398?style=for-the-badge" /></a>
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

`cgw` یک لانچر کوچک و پروفایل‌محور برای [Claude Code](https://code.claude.com/docs/en/setup) است.
گیت‌وی، مدل و کلید را برای هر اجرا عوض می‌کند — **بدون دست زدن به `~/.claude/settings.json`.**

<img src="assets/demo.gif" width="820" alt="نمایشی از cgw — ساخت، سوییچ، اجرا" />

*☝️ ۳۰ ثانیه از clone تا کلاد رایگان. بدون جراحی فایل کانفیگ.*

</div>

<div dir="rtl">

---

## صبر کن — کلاد CLI *رایگان*؟ چطور؟ 🤔

کلاد کد به‌صورت عادی با API خود Anthropic حرف می‌زند (پولی). **`cgw` جلویش می‌ایستد و مسیر را عوض می‌کند** به هر گیت‌ویی که همان Anthropic Messages API را بلد باشد:

| گیت‌وی | هزینه | مدل‌های نمونه |
|---|---|---|
| 🏠 **لوکال** (LiteLLM، پراکسی Ollama، LM Studio) | **رایگان** | `glm-4.6`، `qwen2.5-coder`، `deepseek-v3` روی سیستم خودت |
| 🇨🇳 **Z.AI / ModelScope / OpenRouter** | پلن رایگان / ارزان | `glm-4.6`، `deepseek-v3`، `qwen3` از طریق `http://localhost:20128/v1` |
| 🏢 **گیت‌وی اداره / تیم** | زیرساخت خودت | `claude-opus-4-6` از `https://gw.office.example` |

> **cgw خودش مدل میزبانی نمی‌کند — فقط CLI را آزاد می‌کند تا *هر* مدلی را *هرجا* استفاده کنی. اگر گیت‌وی‌ات رایگان باشد، کلاد CLI تو هم رایگان است.** 🎉

---

## نصب در ۳۰ ثانیه ⚡

> **سیستم‌عاملت را انتخاب کن. همین. بقیه فایل فقط آموزش استفاده است.**

### مک 🍎 / لینوکس 🐧 / دبلیواس‌ال 🐧

```bash
git clone https://github.com/isina-nej/claude-gateway-switcher.git claude-gateway-switcher
cd claude-gateway-switcher
./install.sh
# ← سیم‌لینک bin/cgw → ~/.local/bin/cgw می‌سازد (با git pull همیشه تازه می‌ماند)
# ← همان‌جا پیشنهاد ساخت پروفایل پیش‌فرض را می‌دهد
```

> پیش‌نیاز: `bash` + نصب بودن `claude` در `PATH`. فقط `cgw models` به `curl` نیاز دارد.

### ویندوز 🪟 — پاورشل / CMD به‌صورت native (بدون WSL، بدون Git Bash)

```powershell
git clone https://github.com/isina-nej/claude-gateway-switcher.git claude-gateway-switcher
cd claude-gateway-switcher
powershell -ExecutionPolicy Bypass -File install.ps1
# ← فایل‌های cgw.ps1 و cgw.cmd را به ~/.local/bin کپی و به PATH اضافه می‌کند
# ← همان‌جا پیشنهاد ساخت پروفایل پیش‌فرض را می‌دهد
```

> پیش‌نیاز: پاورشل ۵.۱+ (روی ویندوز ۱۰/۱۱ از قبل هست) + `claude` در `PATH`. بعدش `cgw` هم در پاورشل کار می‌کند هم در CMD.
> یک CLI، یک فرمت `.conf` — پروفایل را بین ویندوز ↔ مک ↔ لینوکس آزاد کپی کن.

<details>
<summary>🔧 نصب دستی / پیشرفته</summary>

- نام باینری دلخواه: `CLAUDE_BIN=/path/to/claude cgw`
- پوشه کانفیگ دلخواه: `XDG_CONFIG_HOME=/my/config cgw` (روی ویندوز هم کار می‌کند)
- تست سلامت نصب: `cgw doctor` — باینری، شکل URL، کلید، دسترسی‌ها و تداخل `settings.json` را چک می‌کند

</details>

---

## دقیقاً چکار می‌کند؟ 🎯

<img src="assets/how-it-works.png" width="820" alt="cgw چطور کار می‌کند — لود پروفایل، اکسپورت env، اجرای claude" />

وقتی `cgw` را می‌زنی، دقیقاً **۳ اتفاق** می‌افتد — نه بیشتر:

```text
۱. لود پروفایل فعال     ←  BASE_URL + MODEL_ID + (اختیاری) API_KEY
۲. اکسپورت env همان اجرا ←  ANTHROPIC_BASE_URL, ANTHROPIC_MODEL
                            + ANTHROPIC_AUTH_TOKEN یا ANTHROPIC_API_KEY (فقط اگر کلید باشد)
                            + CLAUDE_CODE_USE_GATEWAY=1 (اگر discovery روشن باشد)
۳. اجرای کلاد کد         ←  claude --model "<MODEL_ID>"  + آرگومان‌های اضافه‌ات
```

✅ فایل `~/.claude/settings.json` **نه خوانده می‌شود، نه نوشته، نه مرج.**  
✅ با حذف `cgw` کلاد کد دقیقاً مثل قبل می‌ماند.  
✅ هر اجرای `cgw` ایزوله است — آلودگی env سراسری ندارد.

### چرا پروفایل به‌جای ویرایش settings؟

| 😫 بدون cgw | 😎 با cgw |
|---|---|
| کپی‌پیست مداوم URL و کلید برای هر سوییچ گیت‌وی | `cgw setup work` / `setup local` → `cgw use local` |
| گیت‌وی لوکال بدون کلید با هدر خالی خفه می‌شود | بدون کلید ← **بدون متغیر auth، بدون هدر.** تمیز. |
| ترس از کامیت اتفاقی کلید در ریپوی دات‌فایل‌ها | پروفایل بیرون از گیت، دسترسی `600`، ignore شده |
| باگ‌های model-pinning در `settings.json` بین نسخه‌ها | مدل هر بار صریح `claude --model …` پاس داده می‌شود |
| روی ویندوز نیاز به ترفند WSL/Git Bash | `cgw.ps1` + `cgw.cmd` بومی — مستقیم کار می‌کند |

---

## تور ۶۰ ثانیه‌ای 🚀

```bash
# ۱ — پروفایل لوکال بدون کلید (آدرس پیش‌فرض از قبل پر است)
cgw setup local
#   Gateway base URL (e.g. http://localhost:20128/v1) [http://localhost:20128/v1]:
#   API key [optional, Enter to skip]:
#   Model ID: glm-4.6

# ۲ — گیت‌وی اداره که کلید می‌خواهد
cgw setup work
#   Gateway base URL: https://gw.office.example
#   API key [optional, Enter to skip]: ********
#   Auth type: 1) Bearer token  2) x-api-key [1]: 1
#   Model ID: claude-opus-4-6

# ۳ — سوییچ و برو
cgw use local
cgw                            # کلاد تعاملی روی گیت‌وی لوکال (رایگان)
cgw -p "explain this repo"     # غیرتعاملی — آرگومان مستقیم به کلاد می‌رسد
cgw run work -- -p "fix tests" # اجرای تکی روی پروفایل دیگر
cgw models                     # تست گیت‌وی: GET <BASE_URL>/v1/models
```

<img src="assets/profiles.png" width="820" alt="چند پروفایل — local, work, fast" />

> 💡 **نکته:** اگر `http://localhost:20128/v1` را با `/v1` انتهایی پیست کنی، `cgw` خودش strip می‌کند. کلید خالی = `auth: none`، سؤال نوع احراز هویت کلاً پرسیده نمی‌شود.

---

## همه دستورات — برگه تقلب 📖

```bash
cgw setup [name]          # ویزارد ساخت پروفایل  (پیش‌فرض: default)
cgw edit [name]           # اجرای مجدد ویزارد — Enter نگه‌می‌دارد، "-" کلید را پاک می‌کند
cgw use <name>            # فعال‌کردن پروفایل  ★
cgw list                  # لیست پروفایل‌ها  (* یعنی فعال)
cgw show [name]           # چاپ پروفایل (کلید ماسک: abcd…wxyz)
cgw models [name]         # زدن GET <BASE_URL>/v1/models — تست اتصال و auth
cgw doctor [name]         # چک سلامت: باینری، URL، کلید، دسترسی، settings.json
cgw run [name] -- [args]  # اجرای یک پروفایل با آرگومان اضافه برای کلاد
cgw delete <name>         # حذف پروفایل
cgw [args...]             # هر چیز دیگر → آرگومان کلاد روی پروفایل فعال
```

**میان‌برها:**
- URL پیش‌فرض `http://localhost:20128/v1` در ویزارد پر است
- `/v1` انتهایی خودکار strip می‌شود
- `cgw -p "hello"` معادل `cgw run active -- -p "hello"` است

---

## گیت‌وی بدون کلید — شهروند درجه یک 🔑

خیلی از گیت‌وی‌های لوکال اصلاً کلید نمی‌خواهند. `cgw` این را عادی می‌داند:

- `cgw show` → `API key: (not set)`
- `cgw doctor` → `[..] No API key set (connecting without auth)` — خطا نیست
- اجرا → **هیچ** `ANTHROPIC_AUTH_TOKEN` / `ANTHROPIC_API_KEY` اکسپورت نمی‌شود
- `cgw models` → **هیچ** هدر `Authorization` / `x-api-key` فرستاده نمی‌شود
- `cgw edit` → با `-` کلید قبلی پاک می‌شود

برای `localhost` که احراز هویت فقط مزاحم است، عالی.

---

## پروفایل‌ها کجا ذخیره می‌شوند؟ 💾

```text
~/.config/claude-gateway-switcher/profiles/*.conf      # مک / لینوکس / WSL
%APPDATA%\claude-gateway-switcher\profiles\*.conf      # ویندوز
# اگر $XDG_CONFIG_HOME باشد، اولویت دارد
```

| پلتفرم | دسترسی | توضیح |
|---|---|---|
| یونیکس | فایل `600`، پوشه `700` | کلید هرگز وارد ریپو نمی‌شود |
| ویندوز | ACL کاربر | همان فرمت `.conf`، LF بدون BOM، سینگل‌کووت |
| بین سیستم‌عامل | — | bash فایل PS را مستقیم `source` می‌کند؛ PS همه املاهای `%q` را می‌فهمد (`bare`، `'...'`، `$'...'`، `"..."`) — **کپی آزاد** |

---

## نیازمندی گیت‌وی 🌐

هر گیت‌ویی که **Anthropic Messages API** (همانی که کلاد کد استفاده می‌کند) را حرف بزند. تست‌شده با LiteLLM، OpenRouter، Z.AI، ModelScope و پراکسی‌های سفارشی.

پراب اختیاری discovery:

```text
GET <BASE_URL>/v1/models
```

هر وقت خواستی `cgw models` بزن. هدر auth فقط وقتی کلید ذخیره شده باشد اضافه می‌شود. discovery را با سؤال آخر ویزارد روشن کن → متغیرهای `CLAUDE_CODE_USE_GATEWAY=1` + `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1` اکسپورت می‌شوند.

---

## امنیت 🔒

- 🔐 **کلید را کامیت نکن** — پروفایل از اول بیرون از ریپو طراحی شده
- 🌐 برای گیت‌وی ریموت `https://` بگذار؛ `http://localhost:*` برای لوکال کافی است
- 👁️ `cgw models` فقط وقتی به گیت‌وی وصل می‌شود که خودت صریح اجرایش کنی
- ⚠️ اپراتور گیت‌وی را قابل اعتماد بدان — پرامپت و کدی که می‌فرستی ممکن است برای آن سرویس قابل مشاهده باشد

---

## حذف 🧹

```bash
./uninstall.sh                                            # مک / لینوکس / WSL
powershell -ExecutionPolicy Bypass -File uninstall.ps1    # ویندوز
```

دستور حذف می‌شود، **پروفایل‌ها عمداً می‌مانند.** برای پاک‌کردن کر دنشیال:

```bash
rm -rf ~/.config/claude-gateway-switcher/          # یونیکس
Remove-Item -Recurse $env:APPDATA\claude-gateway-switcher  # ویندوز
```

---

## سؤالات پرتکرار ❓

<details>
<summary><b>آیا کلاد کد با cgw واقعاً رایگان می‌شود؟</b></summary>

خود `cgw` رایگان و اوپن‌سورس است. رایگان بودن *استنتاج* به گیت‌وی‌ات بستگی دارد. اگر به مدل لوکال یا گیت‌ویی با پلن رایگان (مثلاً GLM-4.6 روی Z.AI) وصل شوی → هزینه صفر. اگر مستقیم به Anthropic بزنی → تعرفه عادی.

</details>

<details>
<summary><b>آیا تنظیمات کلاد کد دستکاری می‌شود؟</b></summary>

هرگز. فقط متغیر محیطی برای پروسه فرزند `claude` ست می‌شود. `~/.claude/settings.json` دست‌نخورده می‌ماند. تمام فلسفه ابزار همین است.

</details>

<details>
<summary><b>می‌توانم برای هر پروفایل مدل جدا داشته باشم؟</b></summary>

بله — هر پروفایل `MODEL_ID` خودش را دارد. `cgw setup fast` با `glm-4-flash`، `cgw setup max` با `claude-opus-4-6`، سوییچ با `cgw use fast`.

</details>

<details>
<summary><b>روی ویندوز بدون WSL واقعاً کار می‌کند؟</b></summary>

واقعاً. `bin/cgw.ps1` روی پاورشل ۵.۱ stock اجرا می‌شود، `bin/cgw.cmd` شیم CMD است. بدون Git Bash، بدون WSL، بدون نیاز به admin.

</details>

---

<div align="center">

### ⭐ اگر `cgw` تو را از جهنم `settings.json` نجات داد، به ریپو ستاره بده!

**`cgw setup local` → `cgw` → کلاد CLI رایگان. همین.**

*ساخته شده با ❤️ برای هر کسی که فقط می‌خواهد `claude` به جای دیگری اشاره کند.*

[گزارش باگ](https://github.com/isina-nej/claude-gateway-switcher/issues) · [درخواست قابلیت](https://github.com/isina-nej/claude-gateway-switcher/issues) · [English](README.md) · [فارسی](README.fa.md)

</div>

</div>
