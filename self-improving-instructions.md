---
name: self-improving-instructions
description: Post-execution improvement loop for self-improving skills. Invoke after any self-improving skill run to check the output against eval criteria, propose a targeted SKILL.md improvement, and apply it with versioning. Invoked automatically — not by the user directly.
argument-hint: [skill-name or skill path — used to locate eval/criteria.md and feedback/ files]
---

# Self-Improving Instructions

This skill runs automatically at the end of every self-improving skill. It checks the just-completed run against that skill's evaluation criteria, proposes one targeted improvement if a gap is found, and applies the change with a full version snapshot and log entry.

---

## Step 1 — Locate the Skill

Identify the skill that just ran. Find its directory:
- Check `~/.claude/skills/{skill-name}/` first
- Fall back to the project's `skills/{skill-name}/` folder
- If uncertain, ask: "Which skill just ran, and where does it live?"

From that directory you need:
- `SKILL.md` — the instructions that were followed (or should have been)
- `eval/criteria.md` — the checklist defining what "good" looks like
- `feedback/edge-cases.md` — known situations the skill didn't handle before
- `versions/` — to determine the current version number

---

## Step 2 — Auto-Select Eval Pack (if criteria.md is not yet filled)

Before self-reflecting, check whether `eval/criteria.md` contains the placeholder text `TODO:`.

**If it does — the eval pack has not been filled in yet. Do this now:**

1. Read `SKILL.md` fully — pay attention to the `description:` field and the instructions
2. Read `eval-pack-selector.md` at `/Users/iliyanivanov/Desktop/self-improving-skills/eval-pack-selector.md`
3. Determine the skill's primary type based on what it does:
   - What kind of output does it produce? (code, writing, data, research, automation...)
   - What tools or APIs does it use?
   - Is it multi-turn, agentic, batch, or single-shot?
4. Pick the best matching pack from the selector table. If the skill spans two types, pick the primary one and note the secondary.
5. Open `skill_specific_eval_packs.md` at `/Users/iliyanivanov/Desktop/self-improving-skills/skill_specific_eval_packs.md` and copy the full chosen pack
6. Replace the `TODO:` section in `eval/criteria.md` with the copied pack, trimming any evals clearly irrelevant to this specific skill
7. Tell the user: "Auto-selected [Pack N: type name] for this skill based on its description. Populated eval/criteria.md."

Then continue to self-reflection with the now-complete criteria.

**If criteria.md is already filled — skip this step entirely.**

---

## Step 3 — Self-Reflect

Read `eval/criteria.md` in full. Then review the run you just completed against each criterion. For each criterion ask:

- **Pass** — I fully satisfied this
- **Partial** — I did this but incompletely or inconsistently
- **Miss** — I skipped this, violated it, or it revealed a gap in SKILL.md

Also read `feedback/edge-cases.md`. Check whether this run encountered a situation already flagged there. If yes, note it — a recurring edge case is stronger signal for an improvement.

Be honest. If you followed instructions perfectly and the output was correct, say so and stop — do not manufacture improvements that aren't real.

---

## Step 4 — Decide

**If no gaps found:**
Stay silent. Do not ask for feedback. Do not propose anything. A clean run should not generate noise.

**If a gap is found:**
Identify the single most important gap — the one that most directly affected output quality or completeness. Do not stack multiple proposals.

Form the proposal:
1. One sentence describing the gap: what it is and when it occurs
2. The exact edit: quote the current SKILL.md text (or location), then show the replacement
3. Why it helps: which criterion it closes, or what failure it prevents

Present to the user:

> I noticed [gap — one sentence].
>
> Proposed change to SKILL.md:
> **Current:** "[existing text or section]"
> **Proposed:** "[new text]"
>
> Apply? (yes / adjust / skip)

Keep the proposal short. If it takes more than 5 lines to explain, the change is probably too large — break it down.

---

## Step 5 — Handle the Response

**User says yes:**
Proceed to Step 5.

**User says adjust [description]:**
Incorporate the adjustment into the proposed edit. Confirm the updated version with the user briefly ("Updated proposal: [edit]. Applying now."), then proceed to Step 5.

**User says skip:**
If this was a new situation that `eval/criteria.md` or `feedback/edge-cases.md` doesn't already cover:
- Append to `feedback/edge-cases.md`:
  ```
  [YYYY-MM-DD] [One-sentence description of the situation] — skipped for now
  ```
Stop here.

**User volunteers a suggestion at any point:**
Even if you found no gap, if the user says "also do X" or "make it shorter" or "add a step for Y" — treat it as an approved proposal and go directly to Step 5.

---

## Step 6 — Apply the Edit

Execute in this exact order:

1. **Read** the current `versions/` directory. Find the highest existing version number N.

2. **Snapshot:** Copy the full current content of `SKILL.md` → write to `versions/v(N+1).md`.
   Do this BEFORE editing SKILL.md. The snapshot captures what the skill was before this change.

3. **Edit** SKILL.md — apply the approved change. Surgical only — do not reformat, restructure, or clean up unrelated sections.

4. **Log to improvements.md** — append one line:
   ```
   [YYYY-MM-DD] v(N)→v(N+1) | WHAT: [one-line description of change] | WHY: [criterion name or user suggestion]
   ```

5. **Update CHANGELOG.md** — append:
   ```
   ## v(N+1) — YYYY-MM-DD
   - [What changed — same as WHAT above]
   - [Why — which eval criterion failed, what failure pattern triggered it, or "user suggestion: [quote]"]
   ```

6. **Invoke documenter subagent** with this prompt:
   "Review SKILL.md at [path]. A targeted edit was just applied. Verify: (1) no contradictions were introduced, (2) no instructions now conflict with each other, (3) no broken internal references. Report any issues found."

7. **If scripts/ were modified** as part of this evolution: invoke script-reviewer subagent on the changed file.

---

## Step 7 — Confirm

After applying, give the user a one-line confirmation:
> Updated to v(N+1). [One sentence on what changed.]

Do not re-summarize the entire skill or narrate everything you did. One sentence is enough.

---

## Critical Rules

1. **One improvement at a time.** Never propose multiple changes in a single round. Stack creates confusion and makes CHANGELOG entries meaningless.

2. **Snapshot before edit, always.** If the snapshot step is skipped for any reason, stop and do it before touching SKILL.md.

3. **improvements.md is append-only.** Never edit or delete past entries. They are the skill's learning history.

4. **Silent when clean.** A skill that ran well should not be asked to improve. Noise trains the user to ignore the prompts.

5. **Propose the minimum viable fix.** The goal is to close one specific gap, not to redesign the skill. If the edit feels large, it probably is — split into two future rounds.

6. **Never change eval/criteria.md during this process.** Criteria are stable. Improvements target SKILL.md, not the measuring stick.

7. **Read edge-cases.md before proposing.** A proposal that addresses a known edge case is stronger than one that addresses a one-time anomaly.
