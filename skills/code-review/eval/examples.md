# Examples — code-review

Golden input/output pairs used as reference during self-reflection.

---

## Example 1 — SQL Injection (critical security finding)

**Input:**
```python
def get_user(username):
    query = f"SELECT * FROM users WHERE username = '{username}'"
    return db.execute(query)
```

**Expected output:**
```
[CRITICAL] Location: get_user, line 2
Issue: String interpolation in SQL query allows injection — an attacker passing `' OR '1'='1` as username retrieves all rows.
Fix: Use parameterized queries: db.execute("SELECT * FROM users WHERE username = ?", (username,))

1 issue found: 1 critical.
```

**Notes:** Classic injection. No other issues — the function does exactly one thing. Good example of keeping the review focused and not inventing problems.

---

## Example 2 — Logic bug with a simplification opportunity

**Input:**
```javascript
function isEligible(user) {
  if (user.age >= 18) {
    if (user.verified === true) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
```

**Expected output:**
```
[LOW] Location: isEligible, lines 2–9
Issue: Nested conditionals are redundant — the function can be expressed as a single return.
Fix: return user.age >= 18 && user.verified === true;

1 issue found: 1 low.
```

**Notes:** No bugs — correct logic. The only finding is the unnecessary complexity, which is a low-severity simplification. The review correctly avoids inventing a bug.

---

## Example 3 — Clean code, no findings

**Input:**
```typescript
export function clamp(value: number, min: number, max: number): number {
  return Math.min(Math.max(value, min), max);
}
```

**Expected output:**
```
No issues found.
```

**Notes:** This is a correct, minimal, readable function. The review should not manufacture a finding just to appear thorough. "No issues found" is a valid and complete review.
