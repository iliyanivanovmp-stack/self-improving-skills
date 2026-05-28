# Skill Folder — Structure & Purpose

## The 6-Step Checklist (every skill needs all six)

1. **Name + Trigger** — what it's called and the natural language that fires it (`description` in frontmatter)
2. **Goal** — one sentence: what this skill accomplishes (first line of the body)
3. **Step-by-step Process** — the exact workflow, human-in-the-loop decision points called out
4. **Reference Files** — style guides, examples, context docs (separate files, referenced from SKILL.md)
5. **Rules** — guardrails: what could go wrong and how to prevent it
6. **Self-Improvement** — footer that calls `/self-improving-instructions` after each run

---

## Folder Structure

```
skill-name/
├── SKILL.md              Core instructions. Covers steps 1–6. Stays under 300 lines.
├── README.md             User-facing: what it does, how to invoke, how to give feedback.
│
├── eval/
│   ├── criteria.md       What "good" looks like. Auto-populated on first run. Don't edit manually.
│   └── examples.md       2–3 golden input/output pairs. Fill this after creation. Used as reference.
│
├── feedback/
│   ├── improvements.md   Append-only log of every accepted improvement. Agent reads this before proposing changes.
│   └── edge-cases.md     Situations SKILL.md didn't cover at discovery time. Feeds future improvements.
│
├── versions/
│   ├── v1.md, v2.md …    Full SKILL.md snapshots. Written BEFORE each edit is applied. Never after.
│   └── CHANGELOG.md      Human-readable history: what changed and why, one entry per version.
│
├── scripts/              Executable code for deterministic or repetitive tasks.
├── references/           Docs loaded into context as needed (style guides, tool docs, examples).
└── assets/               Files used in output (templates, icons, fonts).
```

---

## Quick Commands

**Wrap an existing skill with the full structure:**
```bash
bash /Users/iliyanivanov/Desktop/self-improving-skills/import-skill.sh \
  ~/.claude/skills/your-skill/SKILL.md
```

**Run the improvement loop after any skill run:**
```
/self-improving-instructions
```

**Roll back to a previous version:**
```bash
cp ~/.claude/skills/your-skill/versions/v2.md ~/.claude/skills/your-skill/SKILL.md
```

---

## Symptom → Fix

| Symptom | Fix |
|---|---|
| Wrong steps or wrong order | Edit SKILL.md instructions |
| Missing tone / style / context | Add a reference file |
| Same mistake repeating | Add a rule |
| Struggles with a tool or MCP | Create a tool reference doc in `references/` |
| Works but could improve over time | Add self-improving footer + run `import-skill.sh` |
| Skill not triggering | Check the YAML `description` field |
| Skill triggers too often | Add `disable-model-invocation: true` to frontmatter |
