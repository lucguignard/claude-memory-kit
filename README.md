# claude-memory-kit

**A Claude Code assistant that learns from you every night — with guardrails.**

![license](https://img.shields.io/badge/license-MIT-blue) ![platform](https://img.shields.io/badge/Linux%20%7C%20macOS-bash-lightgrey)

Most memory tools for Claude Code *store and recall*. This kit closes the loop: you correct Claude once, it writes the rule down; every night it re-reads the day's conversations like a coach reviewing a match, fixes its own notes, builds the small tools it was missing, and every morning suggests what would have helped you yesterday. Everything is plain Markdown in git, and every unattended step is fenced by guards.

Built for **people who use Claude Code as a daily work assistant** (marketing, operations, consulting, research, freelancing), not only for coding. No server, no database, no account: bash, git, jq and Claude Code.

[Version française](README.fr.md)

```
   you correct Claude ──► rule written to memory/preferences.md ──► committed to git
          ▲                                                              │
          │                                                              ▼
   morning radar: 5 tools        nightly audit re-reads yesterday ◄── next session
   that would have helped   ◄──  writes missing rules & facts          loads it at start
   (one-command install)         self-tooling builds what was missing
                                 (checked, rolled back on failure)
```

### What a session start looks like

```
Today: 2026-11-23
# Memory index
## Where to find what
| I am looking for… | Note |
| How to answer: tone, length, habits | preferences.md |
| Projects and deadlines              | projects.md    |
…
User preferences (apply from the first reply):
- Answers: short and precise; the result first, the explanation after.
- Never ask "do you want me to…" for a safe, reversible action: do it. (2026-11-20, audit)
Last audit (memory/audit/2026-11-22.md):
Summary: 2 rules · 1 fact · 1 tooling need — stop re-asking for info already in notes
Today's radar (memory/radar/2026-11-23.md):
Summary: 1. PDF table extraction skill · 2. Calendar MCP server · …
```
*(Real output of `scripts/startup.sh`; the preference, audit and radar lines are illustrative.)*

### How it compares

| | Typical memory plugin | claude-memory-kit |
|---|---|---|
| Storage | Database or vector store | Plain Markdown in git: readable, editable, revertable |
| Learning | Recalls what was said | Turns corrections into rules; nightly audit catches what slipped |
| Tooling | — | Builds missing hooks/scripts at night, checks them, rolls back on failure |
| Discovery | — | Morning radar: tools matched to what you actually did |
| Safety | — | Secret filter on every commit, prompt-injection guard, cost guard, `.claude/` changes staged for your OK |

## What you get

| Piece | What it does |
|---|---|
| `memory/` | Plain Markdown notes: `INDEX.md` (where to find what), `preferences.md`, `profile.md`, `projects.md`, a daily `journal/`, multi-session `workstreams/`. |
| `CLAUDE.md` | The rules Claude follows: read the index first, write every durable correction to `preferences.md` immediately, "a mistake corrected twice becomes a rule", invent nothing. |
| **startup** hook | Prints today's date, the index and the top of your preferences at each session start (kept under 9,000 characters so it is never truncated). |
| **autosave** hook | Commits `memory/` to local git after every reply. Files over 5 MB are skipped. |
| **filter** | Blocks the commit if the diff contains a password, an API key (Anthropic, OpenAI, GitHub, AWS, Google, Slack…), an IBAN, a card number, or a personal email / phone number. Add your own patterns in `filter-custom.txt`, allowed generic contacts in `filter-allow.txt`. |
| **guard-secret** | Warns when you paste a secret into a prompt (without repeating it). |
| **guard-injection** | Once a session has read outside content (web page, PDF, connector), any action that sends, publishes, pushes or deletes requires your confirmation. |
| **guard-reply** | Nudges Claude once when a reply ends with "do you want me to…?" for a safe action, or hands verification back to you. |
| **guard-cost** | Warns when you resume a very long conversation after the prompt cache has expired. |
| **pre/post-compact** | Tells the compaction summary what to keep, then points back to the active workstream. |
| **notify** | Optional phone alerts through [ntfy](https://ntfy.sh) when Claude waits for you or a night job fails. |
| **nightly audit** (optional) | Re-reads yesterday's conversations, writes missing rules and facts, and lists tooling needs. |
| **self-tooling** (optional) | Builds those tools (hooks, scripts), checks that everything still works, and rolls back otherwise. Changes to `.claude/` are only *staged*, for you to confirm. |
| **radar** (optional) | Every morning, 5 skills, plugins or techniques that would have helped with what you actually did yesterday — verified sources only. `radar-install.sh <date> <n>` installs one. |

## Install

```bash
git clone https://github.com/lucguignard/claude-memory-kit.git
cd claude-memory-kit
./install.sh ~/assistant        # never overwrites an existing file
cd ~/assistant && claude
```

Claude Code asks you to trust the folder's hooks the first time: read `.claude/settings.json` (it only calls the scripts in `scripts/`), then accept. Then fill in `memory/profile.md` and the top of `memory/preferences.md`, or simply tell Claude about yourself and let it write them.

Requirements: Claude Code, bash, git, jq (`brew install jq` on macOS). Tested on Linux; the scripts avoid GNU-only options so they also run on macOS (bash 3.2) — macOS reports welcome. The night jobs need a machine that is on at night (cron on Linux; on a Mac, cron works but the machine must be awake).

### Night jobs (optional)

```bash
claude setup-token     # long-lived token for unattended runs
mkdir -p ~/.config/claude-memory-kit
echo 'export CLAUDE_CODE_OAUTH_TOKEN=…' > ~/.config/claude-memory-kit/token.env
chmod 600 ~/.config/claude-memory-kit/token.env
crontab -e             # paste the lines from cron.example
```

Settings live in `kit.conf`: time zone, ntfy topic, model for the night jobs (Sonnet by default, to keep costs down).

## How it learns

1. You correct Claude ("shorter", "never say X").
2. Claude writes a dated bullet in `memory/preferences.md` right away and tells you in one line.
3. The Stop hook commits it; the next session loads it at startup.
4. At night, the audit catches what slipped through: repeated mistakes, useless questions, facts you had to explain twice.

Everything is plain text in git: you can read, edit or revert any of it.

## Safety model

- Nothing leaves your machine except what Claude Code itself sends, and the optional ntfy alerts (generic text, no conversation content).
- Unattended runs use explicit `--allowedTools` lists, no MCP servers (`--strict-mcp-config`), and cannot touch `CLAUDE.md`, the autosave or the filter.
- Claude Code protects `.claude/` from unattended edits; the kit respects that and stages changes in `staged/<date>/`. The next interactive session shows them and asks you before connecting anything.
- The filter is a safety net, not a guarantee: keep real secrets in a password manager.

## Layout

```
your-folder/
├── CLAUDE.md
├── kit.conf
├── .claude/settings.json     hooks
├── scripts/                  hooks, night jobs and their prompts
└── memory/
    ├── INDEX.md  preferences.md  profile.md  projects.md
    ├── journal/  workstreams/  audit/  radar/
```

## License

MIT
