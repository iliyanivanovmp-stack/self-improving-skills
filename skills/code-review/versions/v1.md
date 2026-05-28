---
name: code-review
description: Review a code diff or file for correctness bugs, security issues, and simplification opportunities. Returns prioritized findings with severity and exact location. Invoked when the user asks to review code, check a diff, or audit a file.
argument-hint: [paste code, diff, or file path to review]
---

# Code Review

Review the provided code or diff and return a prioritized list of findings. Focus on real bugs — not style preferences. Every finding must name the exact location and be actionable.

---

## Step 1 — Understand Context

Before reviewing, establish:
- What language and framework is this?
- Is this a diff (changes only) or a full file?
- Is there a stated purpose or ticket context? If yes, keep it in mind throughout.

Do not ask clarifying questions for obvious code. Only ask if the context is genuinely ambiguous and matters for the review.

---

## Step 2 — Check for Correctness

Look for logic errors, incorrect assumptions, off-by-one errors, null/undefined handling, incorrect return values, and broken edge cases. These are severity: **critical** or **high**.

Flag only real bugs — not "this could theoretically fail in an unusual scenario" unless it's a realistic one.

---

## Step 3 — Security Analysis

Check for:
- Injection vulnerabilities (SQL, command, XSS, prompt)
- Hardcoded secrets or credentials
- Unsafe deserialization
- Insecure direct object references
- Missing auth or authorization checks
- Logging sensitive data

Security findings default to **critical** unless the vector is extremely narrow.

---

## Step 4 — Simplification Opportunities

Look for:
- Dead code that can be deleted
- Duplicated logic that can be extracted
- Unnecessary complexity — functions doing more than one thing, deep nesting, overly abstract interfaces for a single call site

These are severity: **low** unless the complexity is actively hiding a bug.

Do not flag style differences (naming conventions, formatting) unless the project has an explicit style guide provided.

---

## Step 5 — Synthesize Findings

Compile all findings. Order by severity: critical → high → medium → low.

For each finding, output:

```
[SEVERITY] Location: [file:line or function name]
Issue: [one sentence describing the problem]
Fix: [one sentence or short code snippet showing the correction]
```

If no findings at a severity level: omit that level entirely — do not write "No critical issues found."

---

## Step 6 — Summary

After all findings, one sentence: "N issues found: X critical, Y high, Z medium, W low." If zero issues: "No issues found."

---

## Constraints

- Do not invent issues. If the code is fine, say so.
- Do not suggest refactors that weren't asked for unless they're hiding a real bug.
- Do not comment on test coverage unless specifically asked.
- Keep findings focused: one issue per finding, not multi-part findings.
- Maximum 15 findings per review. If there are more, report the most severe 15.

---

## Self-Improving

After each run, invoke: `/self-improving-instructions`

This skill uses the self-improving framework. See `eval/criteria.md` for what "good" looks like,
`feedback/improvements.md` for the history of what changed and why, and `versions/` for full snapshots.
