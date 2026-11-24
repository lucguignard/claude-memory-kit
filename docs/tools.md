# Tools: skills, agents and helper scripts

Everything below is what I actually use every day with Claude, cleaned of anything personal or work-specific. It is all installed by `./install.sh` (in `.claude/skills/`, `.claude/agents/` and `scripts/`). Python helpers need `python3`; each one says what it needs.

## How they fit together

You never have to call most of them. When you ask for something to be *made* (a PDF, a deck, a post, a visual, a mail campaign…), the **project-lead** skill takes over: it frames the request (with **interview-me** if it is vague), splits it into batches, picks the right skill for each, has the result checked, delivers it and writes down what it learned.

## Skills (`.claude/skills/`)

| Skill | When it triggers | What it does |
|---|---|---|
| `project-lead` | Any request to create or redo a deliverable | Frames, splits into batches, picks skills, runs a quality check before delivery, logs lessons. |
| `interview-me` | A vague request ("make me a flyer") | One question at a time until goal, audience, success criterion and main constraint are clear. Adapted from addyosmani/agent-skills (MIT). |
| `call-the-sages` | "Call the sages" + a question | A panel of personas (strategist, finance, customer, devil's advocate, operations…) works separately; a chair decides. Optional "wild cards". |
| `test-my-idea` | "Test my idea" + an idea | 10–12 fictional customers react; viability score, weakest assumption, a real-world test to run in 48 h. Keeps a log in `memory/ideas.md`. |
| `resume` | "Where were we?", "pick up X" | Runs `scripts/resume.sh`: latest journal, matching workstream, git status — then a 5-line recap. |
| `check-render` | Before delivering a PDF, page or image | Renders it, looks at it, fixes overflow, cut-off text, contrast, alignment. |
| `print-pdf` | A printed or PDF document (flyer, brochure, catalog) | HTML/CSS → PDF with `html2pdf.cjs` (Playwright), print rules (bleed, safe zone, fonts), booklet imposition with `scripts/booklet.py`. |
| `presentation-method` | A deck | One idea per slide, story structure, then `scripts/pptx-check.py` on the result. |
| `image-enhancer` | Before putting images in a document | Checks resolution and sharpness with Pillow, upscales or sharpens when needed. |
| `image-prompt-series` | A series of AI image prompts | Same style base and format for every prompt, so a series looks consistent. |
| `place-logo` | An AI visual that needs a real logo | AI tools redraw logos badly: generate without logo, then paste the real file with `place_logo.py`. |

## Agents (`.claude/agents/`)

Small helpers the main session (or `project-lead`) can delegate to:

- **reader** — reads long pages, files or exports and returns only what matters (cheap model).
- **writer** — writes one precise batch of text (captions, a mail, a post) from a complete brief.
- **checker** — independent re-check of figures: recomputes totals from the source files without seeing the first reasoning, lists differences.

## Helper scripts (`scripts/`)

| Script | Hook / usage | What it does |
|---|---|---|
| `resume.sh [topic]` | used by `resume` | Latest journal, matching workstream progress, git status. |
| `guard-artifact.sh` | PreToolUse `Artifact` | Blocks publishing an internal file (scripts, settings, memory notes, journal) as a claude.ai artifact. |
| `guard-pptx.sh` | PostToolUse `Edit\|Write\|Bash` | After a `.pptx` is written, runs `pptx-check.py` and sends warnings back to Claude. |
| `pptx-check.py file.pptx` | manual or via guard-pptx | Shapes off the slide, overlapping text boxes, text probably too long. Needs `python-pptx`. |
| `booklet.py in.pdf out.pdf` | manual | Imposes A5 pages as a fold-in-half booklet on A4 (`--flip-backs`, `--check`). Needs `pypdf`. |
| `ssh-hosts.sh` | SessionStart | Reminds Claude of your `~/.ssh/config` aliases (names only) so it tries before saying it has no access. |
| `session-trace.sh` | SessionEnd | One line per session in `~/.cache/claude-memory-kit/` (outside the repo), for the nightly audit. |
| `public-link.sh <folder\|port>` | manual | Temporary public link through a Cloudflare quick tunnel; sends it to your phone if `NTFY_TOPIC` is set. Anyone with the link can see what is served. |

Python packages, if you want everything: `pip install --user pillow python-pptx pypdf` and, for PDF rendering, Node + `npm i playwright` (or any Chromium).

## Browser for Claude (optional)

To let Claude open pages, take screenshots and check renderings:

```bash
claude mcp add playwright -- npx @playwright/mcp@latest
```

## Third-party skills I use (not included)

I don't redistribute other people's skills. These are the ones I use most; install them from their source and check each license:

- [anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins) (Apache-2.0): `content-creation`, `campaign-plan`, `brand-review`, `competitive-brief`, `email-sequence`, `seo-audit`, `performance-report`, `design-critique`, `product-brainstorming`, `analyze`, `explore-data`, `statistical-analysis`, `validate-data`, `data-visualization`, `memory-management`.
- [anthropics/skills](https://github.com/anthropics/skills): `canvas-design`, `theme-factory`, `doc-coauthoring`, `internal-comms`, `frontend-design` (Apache-2.0), and the document skills `pptx`, `docx`, `xlsx`, `pdf` (their own license: read it before copying).

The morning **radar** (`scripts/radar.sh`) suggests new ones based on what you actually did the day before.
