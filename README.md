# Afterthought Skill

A second thought for Claude Code, before it spends the effort.

Claude is good at solving problems and bad at judging what a problem is worth. It will start three agents and write a script for a job one shell command does, and it solves the same problem from scratch every time it comes back. Afterthought adds two habits:

1. **Look it up first.** A small tree of solution files, read by folder and file names only, so known problems get their known fix in a few steps.
2. **Think twice before big effort.** Before Claude starts any agent, or when a multi-step problem has no file, a separate Opus agent checks the plan: is the cost in proportion, is there a simpler method, is something being rebuilt that already exists? It answers `CONTINUE`, or `STOP` with 2-3 cheaper alternatives, and writes down what it learned.

## Examples (real test runs)

| Plan Claude was about to run | Afterthought |
|---|---|
| Research agent + Python script + review agent to get 4 GIFs under 5 MB | **STOP**: one `gifsicle -O3 --lossy=80` loop, ~5k tokens instead of ~150k. Wrote `media/gif/compress-gifs.md`. |
| Browser-automation agent to read Google result titles for 3 pages | **STOP**: open the results URLs directly (`&start=10`, `&start=20`) and read page text, or use WebSearch. Wrote `research/web-search/google-serp-titles.md`. |
| Simple question needing one web search | Not called. One search, answered. |

Each check cost about 10k tokens and 15 seconds.

## How it works

- **Solutions tree** `~/.claude/afterthought/solutions/topic/subtopic/[project]/file.md`. File names are the index. Each file starts with a badge, then at most 200 words:
  `Complexity: low|high|very high · Accuracy: tested|partly tested|untested · Best: confirmed by Claude|afterthought|owner (date)`
  Rank: Claude < afterthought < owner; a lower rank never overwrites a higher one.
- **Skill** `afterthought`: tells Claude when to look up, when to call the agent, and to show a `STOP` to you as a choice, never decide for you.
- **Agent** `afterthought` (Opus, medium effort): judges worth vs cost, simplest fit, and rebuilding; may do up to 2 web searches; writes or updates one solution file.
- **Hook** (UserPromptSubmit): prints the tree's top folder names with every prompt, so the lookup costs almost nothing.

The tree starts nearly empty on purpose. It fills with your own problems as you work.

## Install

Needs Claude Code and `jq`.

```bash
git clone https://github.com/Morfor/afterthought-skill
cd afterthought-skill && ./install.sh
```

It copies the agent and skill into `~/.claude/`, seeds the tree with one example file (only if the tree is empty), and adds the hook to `~/.claude/settings.json` (a backup is saved next to it). Restart Claude Code.

Optional: add a line to your `~/.claude/CLAUDE.md`, e.g. *"Before any agent or multi-step task, use the afterthought skill."*

**Uninstall:** delete `~/.claude/agents/afterthought.md`, `~/.claude/skills/afterthought/`, and the Afterthought entry under `hooks.UserPromptSubmit` in `~/.claude/settings.json`. Keep `~/.claude/afterthought/` if you want your solution files.

## Notes

- It costs tokens when it fires (Opus). It is meant to fire rarely: before agents and on undocumented multi-step problems, not on chat answers or small edits.
- Ideas behind it: Anthropic's [advisor tool](https://code.claude.com/docs/en/advisor) and research showing agents misjudge their own cost and overthink easy tasks. Afterthought adds memory (the tree) and a cost-first check.

## Support

If it saves you tokens, you can [buy my cat a tuna can on Ko-fi](https://ko-fi.com/mortadaforaii).

## License

MIT
