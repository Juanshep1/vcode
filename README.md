```
██╗   ██╗ █████╗ ███╗   ██╗████████╗ █████╗
██║   ██║██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗
██║   ██║███████║██╔██╗ ██║   ██║   ███████║
╚██╗ ██╔╝██╔══██║██║╚██╗██║   ██║   ██╔══██║
 ╚████╔╝ ██║  ██║██║ ╚████║   ██║   ██║  ██║
  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝   c o d e
```

**A Claude Code–style terminal coding agent that speaks [Vanta](https://github.com/Juanshep1/vanta).**
It reads, writes, edits, runs, and debugs `.va` programs for you from a chat
prompt — with live diffs, a thinking spinner, themes, and your choice of model.
On launch the wordmark is swept by a "vantablack dusk" gradient (indigo → violet
→ magenta → coral → amber).

---

## Install

```sh
vanbrew install vcode    # or:  curl -fsSL https://raw.githubusercontent.com/Juanshep1/vcode/main/install.sh | sh
vcode                    # first run walks you through adding an API key
```

That's it. On first launch vcode asks you to **pick a provider and paste an API
key** right in the terminal (saved locally to `~/.vanta-code/config.json`) — no
`export` needed. Change it anytime with **`/provider`** or **`/key`**. Prefer env
vars? You can still set `ANTHROPIC_API_KEY` / `OPENROUTER_API_KEY` /
`OLLAMA_API_KEY` and vcode will use them.

> For the **Run** features (`run_vanta` / `run_app`) you need the `vanta` CLI:
> `vanbrew install vanta`. Everything else works without it.

---

## 🧩 Skills (Claude Code compatible)

Skills are reusable expertise the agent loads **on demand**. A skill is just a
folder with a `SKILL.md` (YAML frontmatter `name`/`description` + markdown
instructions, optionally bundling scripts). vcode reads them from:

- `~/.vanta-code/skills/<name>/SKILL.md` (and `./.vanta-code/skills/` per-project)
- **`~/.claude/skills/<name>/SKILL.md`** — so your existing **Claude Code skills work as-is**.

The agent sees each skill's name + description, and calls the `use_skill` tool to
load a skill's full instructions when a task matches. List them with **`/skills`**.

**Grab a pile in one command:** `/skills install` clones Anthropic's official
skills (pdf, docx, xlsx, pptx, frontend-design, mcp-builder, skill-creator,
webapp-testing, canvas-design, brand-guidelines, …) into your skills folder. Add
any other repo with `/skills install owner/repo` (or a full git URL). With hundreds of skills installed, vcode keeps the prompt lean (it lists names only and the agent uses `find_skill` to search them on demand). vcode also
ships `vanta-web-app` and `vanta-game` skills, so it's an expert at building Vanta
apps and games out of the box.

```sh
mkdir -p ~/.vanta-code/skills/my-skill
cat > ~/.vanta-code/skills/my-skill/SKILL.md <<'EOF'
---
name: my-skill
description: What this is for and when to use it.
---
Step-by-step instructions the agent should follow...
EOF
```

## 📱 On a phone (Android or iPhone)

vcode and Vanta are pure Python, so they run in a mobile terminal app. You'll
need an **API key** and **internet**.

### Android — [Termux](https://f-droid.org/packages/com.termux/)
Install **Termux from F-Droid** (the Play Store build is outdated). Then:
```sh
pkg update -y && pkg install -y python
curl -fsSL https://raw.githubusercontent.com/Juanshep1/vanbrew/main/install.sh | sh
. ~/.bashrc 2>/dev/null ; . ~/.profile 2>/dev/null
vanbrew install vanta vcode
vcode                                     # it'll prompt you for an API key
```

### iPhone / iPad — [iSH](https://apps.apple.com/app/ish-shell/id1436902243)
Install **iSH** from the App Store (a tiny Linux shell). Then:
```sh
apk update && apk add python3 curl
curl -fsSL https://raw.githubusercontent.com/Juanshep1/vanbrew/main/install.sh | sh
. ~/.profile
vanbrew install vanta vcode
vcode                                     # it'll prompt you for an API key
```

### Any terminal with Python (fallback — also works in a-Shell on iOS)
If a package manager or the installer isn't available, download the two files
with Python itself and make them commands with aliases:
```sh
mkdir -p ~/bin
python3 -c "import urllib.request as u;[u.urlretrieve(a,b) for a,b in [('https://raw.githubusercontent.com/Juanshep1/vcode/main/vcode.py', __import__('os').path.expanduser('~/bin/vcode.py')),('https://raw.githubusercontent.com/Juanshep1/vanta/main/vanta.py', __import__('os').path.expanduser('~/bin/vanta.py'))]]"
echo "alias vcode='python3 ~/bin/vcode.py'" >> ~/.profile
echo "alias vanta='python3 ~/bin/vanta.py'" >> ~/.profile
. ~/.profile
export OPENROUTER_API_KEY="sk-or-..."
vcode
```

**To keep your key**, append it too: `echo 'export OPENROUTER_API_KEY="sk-or-..."' >> ~/.profile`.

> **On phones:** vcode is great for writing, editing, running and chatting about
> Vanta on the go. The one desktop-only feature is `run_app`'s **movable app
> window** (it needs a desktop browser) — for visual apps, run a `serve()`
> program and open `http://localhost:<port>` in your phone's browser. iSH is
> emulated, so it's slower than Termux.

### Phone-keyboard tips
The terminal UI is mobile-hardened (it survives laggy/split key input and the app
being backgrounded, uses narrow-screen layout, and ASCII-safe glyphs). To reach
keys a soft keyboard lacks, use your terminal's **extra-keys row** (Termux shows
one above the keyboard; Terminus/Termius has an accessory bar) for **Esc, Tab,
Ctrl, and the arrow keys**.

- **Permission modes:** Shift+Tab cycles them — but if your keyboard can't send it,
  just run **`/mode`** (cycles default → auto-accept → plan), or `/auto` / `/plan`.
- **The `/` menu:** press `/`, then **type to filter** and **Enter** to pick — you
  don't strictly need the arrow keys (use them to disambiguate similar commands).
- **`@file` completion** works with the Tab key from the extra-keys row.

---

## What it does

```
╭──────────────────────────────────────────╮
│ ✻  Welcome to Vanta Code                   │
╰──────────────────────────────────────────╯
› build a draggable tip calculator and run it

⏺ I'll write it and pop it open.
⏺ Write(tipjar.va)
  ⎿  +38 lines
⏺ Open app(tipjar.va)
  ⎿  window opened
⏺ Done — drag it by the header.
```

- **Speaks Vanta natively** — its system prompt is a compact, accurate Vanta
  reference (plain-English syntax, `serve`/`http_get`/filesystem builtins, the
  `{{ }}` brace rule), so the code it writes actually runs.
- **Real tools (14)** — `read_file`, `write_file`, **`edit_file`** (surgical
  find/replace), **`search`** (grep), **`glob`**, `make_dir`, `move_path`,
  `delete_path`, `run_vanta`, **`run_app`** (pops the app in a movable window),
  `bash`, and **`use_skill`** (load a Skill on demand). Full filesystem access; writes are frictionless, deletes/shell
  confirm once.
- **Live diffs** — every write/edit shows a Claude-Code-style diff (`+` green,
  `-` red, with line numbers).
- **Builds from scratch** — ask for an app and it writes fresh `.va` code, makes
  a folder for it, runs it, and fixes its own errors.
- **Looks the part** — welcome wordmark, `⏺`/`⎿` tool lines, a thinking spinner,
  markdown-rendered replies, and a bordered prompt.

## Bring your own key

vcode thinks with an LLM, so it uses **your** API key from the environment —
nothing is hard-coded or stored on a server:

| Set this | Provider |
| --- | --- |
| `ANTHROPIC_API_KEY` | Claude, directly |
| `OPENROUTER_API_KEY` | OpenRouter (all ~337 models) |
| `OLLAMA_API_KEY` | Ollama Cloud (full cloud catalog) |

Switch live with **`/provider`**. The **`/model`** picker fetches the provider's
**full live model list** — just **type to filter** (e.g. `claude`, `qwen`).

## Commands & shortcuts

| | |
| --- | --- |
| `/help` | show help |
| `/provider [name]` | switch Anthropic / OpenRouter / Ollama |
| `/model [n\|name]` | pick a model (type to filter the full list) |
| `/themes` | color theme: ember · synthwave · matrix · ice · gold · mono |
| `/init` | scan the project and write a `VANTA.md` (auto-loaded next time) |
| `/resume` | reload your last session (or start with `vcode --continue`) |
| `/compact` | summarize the conversation (also automatic) |
| `/auto`, `/cwd`, `/clear`, `/exit` | … |
| **Esc** | interrupt the agent mid-task |
| `!command` | run a shell command directly |
| `@path` | inline a file's contents into your message |
| `"""` | start a multi-line message (end with `"""`) |
| ↑ / ↓ | recall previous prompts |

## Themes

Six gradient themes, set with `/themes` and remembered across sessions:

`ember` (default) · `synthwave` · `matrix` · `ice` · `gold` · `mono`

## Honest scope

A single self-contained Python file, standard library only. It's a clean,
line-based REPL styled to look like Claude Code — same banner, tool rendering,
spinner, diffs and flow — not a full raw-mode TUI, and it doesn't stream tokens
(replies print when complete). It runs Vanta programs to verify them and pops
visual/web apps in a movable window.

## Requirements

- **Python 3** (no third-party packages)
- An API key (above)
- Optional: the [`vanta`](https://github.com/Juanshep1/vanta) CLI for running
  programs; **Chrome** for the movable app windows.

## License

MIT — see [LICENSE](LICENSE).
