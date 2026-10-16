---
name: afterthought
description: Look up known solutions before solving, and get a critical second opinion before spending big effort. Use before starting ANY agent (Agent tool, Workflow, fork), and before any multi-step task or problem (testing, installing, debugging, building, research) - check ~/.claude/afterthought/solutions/ by folder names first; if no file fits, or an agent is about to be started, call the afterthought agent. Also use after finishing work that taught something reusable, to update the solution files. Skip for chat answers and one-line edits.
---

# Afterthought

Goal: don't reinvent solutions, and don't spend effort out of proportion to the task.

## 1. Look up (always, cheap)
Tree: `~/.claude/afterthought/solutions/` = topic/subtopic/[project]/file.md. The hook shows the top folders on every prompt.
- Read **names only**, one level at a time (`ls`), until one file clearly fits. Then open that one file and follow it.
- Don't read whole folders or several files "to be sure"; names are the index.

## 2. Call the afterthought agent when
- you are about to start any agent (not for the afterthought agent itself), or
- a multi-step problem has no fitting file.

Brief it (Agent, `subagent_type: "afterthought"`) with:
- goal (the owner's real goal) and the planned method;
- actions so far, one line each;
- real numbers: tokens spent since the request (from context size now vs at the request), agents started, files touched;
- why it was called.

## 3. Act on the verdict
- **CONTINUE**: go on.
- **STOP**: stop the planned method. Show the owner the reason and the alternatives in a question box (AskUserQuestion), alternatives as options plus "Continue as planned". Don't decide for them.
The agent has already written or updated a solution file; mention its path in one line.

## 4. Keep the tree true
After work that taught something reusable (a fix, a trap, a faster method), update the fitting file or add one:
- badge line first: `Complexity: low|high|very high · Accuracy: tested|partly tested|untested · Best: confirmed by Claude|afterthought|owner (YYYY-MM-DD)`; then max 200 words, no filler.
- Rank: Claude < afterthought < owner. Only the owner sets "owner". Never overwrite a higher rank; add a dated line.
- Name files and folders so the path alone says what's inside.
