# Self-Improving Skills Framework

Skills that improve themselves. Every run is an opportunity to get better.

---

## What This Is

A self-improving skill is a normal Claude skill (SKILL.md + optional scripts/) wrapped with a feedback loop. After each run, Claude checks its own output against the skill's evaluation criteria, identifies any gap, proposes a targeted fix to SKILL.md, and — if approved — updates itself, saves a version snapshot, and logs what changed and why.

No manual scoring. No separate workflow step. No manual eval pack selection. The improvement is part of the skill run — fully automatic.

Over time each skill accumulates a versioned history of every improvement it has made to itself, with the reasoning behind each change.

---

## The Loop

```
SKILL RUNS
      ↓
/self-improving-instructions fires
      ↓
Auto-setup check: is eval/criteria.md filled?
  → NO  → Claude reads SKILL.md, picks the right eval pack automatically,
           populates eval/criteria.md. One-time setup, no user input needed.
  → YES → proceed
      ↓
Self-reflect against eval/criteria.md
  → Did I follow all SKILL.md instructions?
  → Which criteria did I miss or only partially satisfy?
  → Did I hit a situation the skill doesn't cover?
      ↓
      ├── Gap found → propose one specific SKILL.md edit
      │                (what to change, where, why it helps)
      │                User: approve / refine / skip
      │                      ↓
      │               Approved → snapshot → apply edit → log
      │               Refined  → incorporate adjustment → snapshot → apply → log
      │               Skipped  → if new situation: log to edge-cases.md
      │
      └── No gap found → silent (no noise when the run was clean)

Optional at any point:
  User volunteers a suggestion → treated same as approved proposal
  → snapshot → apply edit → log

After every accepted edit:
  → Documenter subagent verifies SKILL.md coherence
  → Script-reviewer subagent runs if scripts/ were modified
```

### What "one specific edit" means

Not a rewrite. A surgical change: one instruction clarified, one missing step added, one ambiguous constraint tightened. This keeps skills readable and makes the CHANGELOG meaningful — each entry traces to one real gap, not a vague "improved quality."

---

## Skill Directory Structure

```
~/.claude/skills/{skill-name}/
  SKILL.md                  Core instructions. Last section references self-improving-instructions.
  README.md                 User-facing: what the skill does, how to invoke, how to give feedback.
  eval/
    criteria.md             Checklist of what "good" looks like for this skill.
                            Auto-populated on first run if empty (no manual setup needed).
                            Built from 6 universal evals + the type-specific pack.
                            Used by Claude during self-reflection — not scored, just checked.
    examples.md             2–3 golden input/output pairs as reference.
  feedback/
    improvements.md         Append-only log of every accepted improvement.
                            Format: [YYYY-MM-DD] vN→vN+1 | WHAT: ... | WHY: ...
    edge-cases.md           Situations SKILL.md didn't cover at time of discovery.
                            Claude reads this before proposing improvements.
  versions/
    v1.md                   Full SKILL.md snapshot at version 1.
    v2.md                   Full snapshot at version 2.
    vN.md                   One file per version, created before each edit is applied.
    CHANGELOG.md            Human-readable history. One entry per version.
  scripts/                  Execution scripts (existing convention — unchanged).
```

### File rules
- `versions/vN.md` is written **before** the edit is applied to SKILL.md — never after
- `feedback/improvements.md` is append-only — never delete or edit past entries
- `eval/criteria.md` is stable once populated — only update if the skill's fundamental type changes
- SKILL.md should stay under 300 lines — if it grows past that, consider splitting into two skills

---

## How to Create a New Self-Improving Skill

### Option A — Wrap an existing SKILL.md (recommended)

```bash
bash /Users/iliyanivanov/Desktop/self-improving-skills/import-skill.sh \
  ~/.claude/skills/my-skill/SKILL.md
```

This creates all directories, stubs every required file, snapshots v1, and adds the self-improving footer to SKILL.md.

After running it, the only manual step is writing 2–3 entries in `eval/examples.md`. The eval/criteria.md will be auto-populated on the first skill run — no manual pack selection needed.

### Option B — Create from scratch

1. Write SKILL.md following the standard format (name, description, instructions, rules)
2. Create the directory structure by running `import-skill.sh` on the new SKILL.md
3. Write `eval/examples.md`: 2–3 realistic input/output pairs
4. On first run, `self-improving-instructions` will auto-select and populate `eval/criteria.md`

### When to create a skill at all

A skill is worth creating when all three are true:
- Used 2+ times (it's not a one-off)
- Non-trivial (3+ steps or decisions involved)
- Stable enough to document (the workflow is unlikely to change completely next week)

If the pattern is simpler than 3 steps, add it to CLAUDE.md or memory instead.

---

## How Evolution Works (step by step)

This is what `self-improving-instructions.md` executes after each skill run:

1. **Auto-setup:** Check if `eval/criteria.md` has a TODO placeholder. If yes, read SKILL.md, pick the correct eval pack from `eval-pack-selector.md`, populate criteria.md. Inform the user which pack was selected.

2. **Self-reflect:** Read `eval/criteria.md` and `feedback/edge-cases.md`. Check each criterion: pass / partial / miss.

3. **If no gaps:** Stay silent. Stop here.

4. **If gap found:** Identify the single most important gap. Form a proposal: one sentence describing the gap, the exact SKILL.md edit (current text → proposed text), why it helps.

5. **Present to user:** _"I noticed [gap]. Proposed change: [edit]. Apply?"_
   - **yes** → proceed
   - **adjust [description]** → incorporate adjustment, confirm, proceed
   - **skip** → if new situation, append to `feedback/edge-cases.md`, stop

6. **Apply:**
   - Find highest version number N in `versions/`
   - Write current SKILL.md → `versions/v(N+1).md` (snapshot BEFORE editing)
   - Apply the edit to SKILL.md (surgical — do not touch unrelated sections)
   - Append to `feedback/improvements.md`: `[DATE] vN→vN+1 | WHAT: ... | WHY: ...`
   - Append to `versions/CHANGELOG.md`: `## v(N+1) — DATE` with what changed and why

7. **Quality gates:**
   - Invoke documenter subagent: verify no contradictions or broken references introduced
   - If `scripts/` were modified: invoke script-reviewer subagent

8. **Confirm:** One-line message to user: _"Updated to v(N+1). [What changed.]"_

---

## Eval Packs — Auto-Selection

Evaluation criteria are built from two layers that `self-improving-instructions` combines automatically:

**Universal evals** (`universal_skill_evals.md`) — always included:
- Instruction-Following, Completeness, Accuracy, Hallucination, Safety/Risk, Constraint

**Type-specific packs** (`skill_specific_eval_packs.md`) — 11 packs covering:
Writing, Formatting/Conversion, Tool/API/Automation, Coding, Research, Multi-Turn/Session, Agentic Workflow, Example/Retrieval, Batch/Data, Self-Improvement, Security/Safety

**How auto-selection works:** On first run against a skill with an empty criteria.md, the agent reads SKILL.md and reasons about the skill's type based on its description, output type, and tools used. It picks the best matching pack, trims irrelevant evals, and writes the result to `eval/criteria.md`. The user is told which pack was chosen. Manual intervention is only needed if the auto-selection was wrong (rare).

See `eval-pack-selector.md` for the full type → pack mapping table and how to manually override.

---

## Versioning and Rollback

Every version of every skill is preserved as a full SKILL.md snapshot in `versions/vN.md`.

**Roll back to any prior version:**
```bash
cp ~/.claude/skills/my-skill/versions/v2.md ~/.claude/skills/my-skill/SKILL.md
```

**See full history of what changed and why:**
```bash
cat ~/.claude/skills/my-skill/versions/CHANGELOG.md
```

**See machine-readable improvement log (agent uses this):**
```bash
cat ~/.claude/skills/my-skill/feedback/improvements.md
```

The agent reads the full version history before proposing a new improvement — this prevents re-proposing changes that were already tried and reverted, and surfaces recurring patterns.

---

## Subagent Roles

| Subagent | When invoked | What it does |
|---|---|---|
| **documenter** | After every accepted SKILL.md edit | Verifies the edit is coherent — no contradictions, no broken cross-references, no duplicate instructions |
| **script-reviewer** | When `scripts/` files are modified during evolution | Checks updated scripts for bugs, safety issues, edge cases |
| **qa** | Optional — when `eval/examples.md` contains executable inputs | Runs examples as regression tests after an edit to confirm known-good cases still pass |

Documenter and script-reviewer are invoked automatically by `self-improving-instructions`. No manual calls needed.

---

## Relationship to Existing Framework

This folder is a child workflow of `~/Desktop/my_brain/workflows/Agentic_flowsSKILLED/`. All global rules from that CLAUDE.md still apply.

The parent framework's self-annealing principle:
> Fix → Test → Update SKILL.md → System is stronger

This framework extends it:
> Run → Eval criteria check → Propose one edit → Snapshot → Apply → Log → System is stronger

No conflicts. Same philosophy, more structure.

---

## Source Material

| Concept | Source | What we took |
|---|---|---|
| Loop + file structure + versioning | github.com/RagnarPitla/self-improving-skills-rbuild.ai | Loop mechanics, skill directory layout, CHANGELOG format, simulation agent idea (Phase 2) |
| Eval packs | `skill_specific_eval_packs.md` + `universal_skill_evals.md` | Assessment criteria per skill type |
| Self-healing patterns | `self-healing/` folder | Skill-creation decision criteria, memory hygiene |
| Existing skill baseline | `Agentic_flowsSKILLED/CLAUDE.md` | SKILL.md + scripts/ convention, self-anneal-on-errors, subagent usage |

### What we deliberately left out

| Dropped | Reason |
|---|---|
| 1–5 rating system | Scores are vague — don't tell Claude what to fix. Self-reflection against specific criteria is more actionable. |
| successes.md / failures.md | Not useful without ratings. `improvements.md` and `edge-cases.md` carry the same signal more cleanly. |
| Manual eval pack selection | Auto-selection on first run eliminates this entirely. |
| Install wizard / config file | Overkill for personal use. This document covers every decision. |
| Simulation agent | Powerful but complex. Build after the manual loop is battle-tested. See Phase 2 below. |

---

## Phase 2 — Simulation Agent

Not built yet. The idea: a skill that generates synthetic test scenarios for any other skill, runs evals without needing a real user session, and can auto-apply improvements when confidence is high.

Full architecture exists in the GitHub repo (`docs/SIMULATION.md`). Build this once the manual feedback loop has been used on several real skills and the structures are stable.

---

## File Locations

```
/Users/iliyanivanov/Desktop/self-improving-skills/
  CLAUDE.md                        Project instructions (child of Agentic_flowsSKILLED)
  BUILD_PLAN.md                    Full implementation plan with all decisions documented
  FRAMEWORK.md                     This file — master reference
  self-improving-instructions.md   The skill that runs the improvement loop (7 steps)
  eval-pack-selector.md            Type → pack mapping table + how to build criteria.md
  import-skill.sh                  Wraps any existing SKILL.md with the full structure
  universal_skill_evals.md         Source: 20 universal evals
  skill_specific_eval_packs.md     Source: 141 type-specific evals across 11 packs
  self-healing/                    Source material: skill-creation guide, memory patterns
  skills/
    code-review/                   Complete working example of a self-improving skill
      SKILL.md
      README.md
      eval/criteria.md + examples.md
      feedback/improvements.md + edge-cases.md
      versions/v1.md + CHANGELOG.md
```

Actual skills in use live at `~/.claude/skills/`. This folder is framework + examples only.
