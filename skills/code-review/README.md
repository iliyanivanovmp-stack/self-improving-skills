# code-review

Reviews a code diff or file for correctness bugs, security issues, and simplification opportunities. Returns findings ordered by severity with exact locations and actionable fixes.

## How to invoke

```
/code-review
```

Then paste the code or diff. Or:

```
/code-review [file path]
```

## What it reviews

- **Correctness** — logic errors, null handling, off-by-one, broken edge cases
- **Security** — injection, hardcoded secrets, missing auth, sensitive logging
- **Simplification** — dead code, duplicated logic, unnecessary complexity hiding bugs

Style differences and test coverage are out of scope unless explicitly requested.

## Output format

```
[SEVERITY] Location: file:line
Issue: what the problem is
Fix: how to correct it

N issues found: X critical, Y high, Z medium, W low.
```

## How it improves

After each run Claude checks its output against `eval/criteria.md` — 15 specific criteria covering accuracy, completeness, prioritization, and location specificity. If a gap is found, Claude proposes one targeted fix to its own instructions.

To give direct feedback: just tell Claude what to change. It applies the edit, snapshots the current version, and logs it.

Full history: `versions/CHANGELOG.md`
