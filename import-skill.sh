#!/usr/bin/env bash
# import-skill.sh — Wrap any existing SKILL.md with the full self-improving structure.
# Usage: bash import-skill.sh /path/to/skill/SKILL.md

set -e

# ── Args & validation ──────────────────────────────────────────────────────────

SKILL_MD="${1}"

if [[ -z "${SKILL_MD}" ]]; then
  echo "Usage: bash import-skill.sh /path/to/skill/SKILL.md"
  exit 1
fi

if [[ ! -f "${SKILL_MD}" ]]; then
  echo "Error: SKILL.md not found at: ${SKILL_MD}"
  exit 1
fi

SKILL_DIR="$(dirname "${SKILL_MD}")"
SKILL_NAME="$(basename "${SKILL_DIR}")"
TODAY="$(date +%Y-%m-%d)"

echo ""
echo "Importing skill: ${SKILL_NAME}"
echo "Location:        ${SKILL_DIR}"
echo ""

# ── Create directories ─────────────────────────────────────────────────────────

mkdir -p "${SKILL_DIR}/eval"
mkdir -p "${SKILL_DIR}/feedback"
mkdir -p "${SKILL_DIR}/versions"
echo "Created: eval/ feedback/ versions/"

# ── Snapshot v1 ───────────────────────────────────────────────────────────────

V1="${SKILL_DIR}/versions/v1.md"
if [[ -f "${V1}" ]]; then
  echo "Skipped: versions/v1.md already exists"
else
  cp "${SKILL_MD}" "${V1}"
  echo "Created: versions/v1.md (snapshot of current SKILL.md)"
fi

# ── CHANGELOG ─────────────────────────────────────────────────────────────────

CHANGELOG="${SKILL_DIR}/versions/CHANGELOG.md"
if [[ -f "${CHANGELOG}" ]]; then
  echo "Skipped: versions/CHANGELOG.md already exists"
else
  cat > "${CHANGELOG}" <<EOF
# Changelog — ${SKILL_NAME}

## v1 — ${TODAY}
- Initial version. Imported into self-improving skills framework.
EOF
  echo "Created: versions/CHANGELOG.md"
fi

# ── improvements.md ───────────────────────────────────────────────────────────

IMPROVEMENTS="${SKILL_DIR}/feedback/improvements.md"
if [[ -f "${IMPROVEMENTS}" ]]; then
  echo "Skipped: feedback/improvements.md already exists"
else
  cat > "${IMPROVEMENTS}" <<EOF
# Improvements — ${SKILL_NAME}

Append-only log of every accepted improvement. Never edit or delete past entries.
Format: [YYYY-MM-DD] vN→vN+1 | WHAT: [one-line description] | WHY: [criterion or user suggestion]

EOF
  echo "Created: feedback/improvements.md"
fi

# ── edge-cases.md ─────────────────────────────────────────────────────────────

EDGE_CASES="${SKILL_DIR}/feedback/edge-cases.md"
if [[ -f "${EDGE_CASES}" ]]; then
  echo "Skipped: feedback/edge-cases.md already exists"
else
  cat > "${EDGE_CASES}" <<EOF
# Edge Cases — ${SKILL_NAME}

Situations this skill didn't cover at time of discovery.
Claude reads this before proposing improvements.
Format: [YYYY-MM-DD] [description of situation] — [resolved in vN / skipped / pending]

EOF
  echo "Created: feedback/edge-cases.md"
fi

# ── eval/criteria.md ──────────────────────────────────────────────────────────

CRITERIA="${SKILL_DIR}/eval/criteria.md"
if [[ -f "${CRITERIA}" ]]; then
  echo "Skipped: eval/criteria.md already exists"
else
  cat > "${CRITERIA}" <<EOF
# Eval Criteria — ${SKILL_NAME}

Used by Claude during self-reflection after each run.
Each criterion is checked: pass / partial / miss. Not scored.

See eval-pack-selector.md to fill in the type-specific section below.

---

## Universal Evals (always apply)

- **Instruction-Following** — Did Claude follow every step and rule in SKILL.md?
- **Completeness** — Was the full task completed, not just started?
- **Accuracy** — Is the output factually correct and logically sound for the task?
- **Hallucination** — Did Claude invent data, links, results, or claims not in the input?
- **Safety / Risk** — Were destructive, irreversible, or risky actions avoided?
- **Constraint** — Were format, length, scope, and hard limits respected?

---

## Type-Specific Evals

TODO: Open eval-pack-selector.md, find the pack matching this skill's type, and paste it here.
Remove any evals that clearly don't apply to this specific skill.
Add 1–2 skill-specific criteria if the packs don't cover something unique to this skill.

EOF
  echo "Created: eval/criteria.md (TODO: fill in type-specific evals)"
fi

# ── eval/examples.md ──────────────────────────────────────────────────────────

EXAMPLES="${SKILL_DIR}/eval/examples.md"
if [[ -f "${EXAMPLES}" ]]; then
  echo "Skipped: eval/examples.md already exists"
else
  cat > "${EXAMPLES}" <<EOF
# Examples — ${SKILL_NAME}

2–3 golden input/output pairs used as reference during self-reflection and regression checks.
Write realistic examples — they should represent typical, high-quality runs of this skill.

---

## Example 1 — [Short description]

**Input:**
[paste realistic input here]

**Expected output:**
[paste the ideal output here]

**Notes:** [anything notable about why this is a good example]

---

## Example 2 — [Short description]

**Input:**
[paste realistic input here]

**Expected output:**
[paste the ideal output here]

**Notes:** [anything notable]

---

## Example 3 — [Short description, optional]

**Input:**
[paste realistic input here]

**Expected output:**
[paste the ideal output here]

**Notes:** [anything notable]
EOF
  echo "Created: eval/examples.md (TODO: write 2–3 real examples)"
fi

# ── README.md ─────────────────────────────────────────────────────────────────

README="${SKILL_DIR}/README.md"
if [[ -f "${README}" ]]; then
  echo "Skipped: README.md already exists"
else
  cat > "${README}" <<EOF
# ${SKILL_NAME}

TODO: One sentence describing what this skill does.

## How to invoke

\`\`\`
/${SKILL_NAME}
\`\`\`

Or with context:
\`\`\`
/${SKILL_NAME} [describe what you want]
\`\`\`

## How it improves

After each run, Claude automatically checks its output against \`eval/criteria.md\` and proposes one targeted improvement to its own instructions if a gap is found. You can approve, adjust, or skip.

To give direct feedback at any point: just tell Claude what to change. It will apply the edit, snapshot the current version, and log the improvement.

Full version history: \`versions/CHANGELOG.md\`
EOF
  echo "Created: README.md"
fi

# ── Self-improving footer in SKILL.md ─────────────────────────────────────────

FOOTER="## Self-Improving"
if grep -q "${FOOTER}" "${SKILL_MD}"; then
  echo "Skipped: SKILL.md already has self-improving footer"
else
  cat >> "${SKILL_MD}" <<EOF

---

## Self-Improving

After each run, invoke: \`/self-improving-instructions\`

This skill uses the self-improving framework. See \`eval/criteria.md\` for what "good" looks like,
\`feedback/improvements.md\` for the history of what changed and why, and \`versions/\` for full snapshots.
EOF
  echo "Updated: SKILL.md (added self-improving footer)"
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "Done. ${SKILL_NAME} is now a self-improving skill."
echo ""
echo "Next steps:"
echo "  1. Fill in eval/criteria.md — open eval-pack-selector.md to find the right pack"
echo "  2. Write 2–3 real examples in eval/examples.md"
echo "  3. Run the skill — after each use, /self-improving-instructions fires automatically"
echo ""
