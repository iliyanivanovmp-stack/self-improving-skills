# Self-Improving Skills

**Purpose:** Framework for making Claude skills self-improving. Every skill run automatically triggers a self-reflection loop that proposes targeted improvements to the skill's own instructions, with full versioning and rollback.

---

## How This Works

After any self-improving skill finishes, invoke `/self-improving-instructions`. It will:
1. Auto-select and populate the eval pack if not yet done (no manual setup needed)
2. Check the run against that skill's evaluation criteria
3. Propose one targeted SKILL.md edit if a gap is found — or stay silent if the run was clean
4. On approval: snapshot the old version, apply the edit, log it

The skill gets better. Every change is tracked and reversible.

---

## Project-Specific Skills

Skills in `./skills/` are examples demonstrating the framework structure:

- **`code-review`** — Full working example of a self-improving skill. Use as a template when adding new skills to the framework.

Actual skills in use live at `~/.claude/skills/`. This folder is the framework definition only.

---

## Key Files & Paths

| File | Purpose |
|---|---|
| `BUILD_PLAN.md` | Full implementation plan — start here for complete context |
| `FRAMEWORK.md` | Master reference: loop diagram, file structure spec, how to create a skill |
| `self-improving-instructions.md` | The skill that runs the improvement loop |
| `eval-pack-selector.md` | Maps skill type → which eval pack to use (auto-used by self-improving-instructions) |
| `import-skill.sh` | Wraps any existing SKILL.md with the full self-improving structure |
| `universal_skill_evals.md` | Source: 20 universal evals |
| `skill_specific_eval_packs.md` | Source: 141 type-specific evals across 11 packs |
| `self-healing/` | Source material: skill-creation decision criteria, memory patterns |
| `skills/code-review/` | Complete example skill with all files populated |

---

## Commands

**Wrap an existing skill with the self-improving structure:**
```bash
bash /Users/iliyanivanov/Desktop/self-improving-skills/import-skill.sh \
  ~/.claude/skills/your-skill-name/SKILL.md
```

**After running any self-improving skill:**
```
/self-improving-instructions
```

**Roll back a skill to a previous version:**
```bash
cp ~/.claude/skills/your-skill/versions/v2.md ~/.claude/skills/your-skill/SKILL.md
```

---

## Self-Improving Skill Directory Structure

```
~/.claude/skills/{skill-name}/
  SKILL.md              Core instructions + self-improving footer
  README.md             User-facing docs
  eval/
    criteria.md         Eval checklist (auto-populated on first run if empty)
    examples.md         Golden input/output pairs
  feedback/
    improvements.md     Append-only log of every accepted improvement
    edge-cases.md       Situations SKILL.md didn't cover at discovery time
  versions/
    v1.md               Full SKILL.md snapshots (one per version)
    CHANGELOG.md        Human-readable history of what changed and why
  scripts/              Execution scripts (unchanged from existing convention)
```

---

## Relationship to Parent Framework

This folder is a **child workflow** of `~/Desktop/my_brain/workflows/Agentic_flowsSKILLED/`.

Global rules from the parent still apply: Skills architecture, self-annealing, gws CLI, subagent conventions, cloud deliverables. This folder adds no conflicting rules — it extends the self-annealing principle with formal versioning and eval-driven improvement proposals.

**Self-annealing in parent:** Fix → Test → Update SKILL.md → Stronger
**Extended here:** Fix → Test → Eval criteria check → Propose one edit → Snapshot → Log → Stronger

---

## Learnings

- Eval pack selection is automatic — `self-improving-instructions` reads SKILL.md and picks the right pack on first run. No manual selection needed.
- The improvement loop is silent when a skill runs cleanly — it only surfaces when there's a real gap.
- Versioning is always full snapshots (vN.md), not diffs — this makes rollback trivial and lets the agent read the full history.
- Improvements.md and CHANGELOG.md both get updated on every accepted change — improvements.md is for the agent (one-line machine-readable log), CHANGELOG.md is for humans (readable with context).
