---
name: code-modernizer
description: >
  Analyzes source code files in any programming language and improves them without changing logic or architecture.
  Improvements include: renaming cryptic identifiers (variables, functions, classes, parameters) to meaningful names,
  replacing generic exceptions/errors with specific typed ones and better messages, adding doc comments to functions
  and classes, and inserting inline comments for complex logic.
  
  Use this skill whenever the user asks to modernize, clean up, improve readability, rename identifiers, add documentation,
  or make code more understandable — regardless of programming language. Also trigger when the user says things like
  "make my code better", "this code is messy", "add comments", "improve naming", or provides files to refactor.
  
  IMPORTANT: This skill must NEVER change program logic, control flow, algorithms, or architecture. Only surface-level
  improvements: names, comments, exception types/messages.
---

# Code Modernizer Skill

Improves code readability and documentation across any programming language without altering logic or architecture.

---

## What This Skill Does

Given one or more source files, Claude will:

1. **Detect the programming language** from file extension and content.
2. **Rename cryptic identifiers** — variables, functions/methods, classes, parameters — to descriptive names that clearly convey intent.
3. **Improve exception/error handling expressiveness** — replace generic exceptions (e.g., `Exception`, `Error`, `RuntimeError`) with specific typed ones where the language provides them, and replace vague messages with clear, actionable ones.
4. **Add doc comments** — generate documentation comments for all functions, methods, and classes using the language's idiomatic format (JSDoc, XML doc, docstring, Javadoc, etc.).
5. **Add inline comments** for complex or non-obvious logic blocks — explain *why* or *what* the code is doing, not just *how*.

### Hard Constraints — Never Violate

- Do NOT change control flow, algorithms, or program logic.
- Do NOT add, remove, or reorder function calls or statements.
- Do NOT change function signatures beyond renaming parameters.
- Do NOT refactor architecture (e.g., splitting classes, extracting methods) unless the user explicitly asks.
- Do NOT change return types or data structures.
- When in doubt whether a change affects logic: **skip it**.

---

## Step-by-Step Workflow

### Step 1 — Identify files and language

Read each target file. Determine the language from:
- File extension (`.cs`, `.ts`, `.py`, `.go`, `.java`, `.rs`, `.cpp`, `.php`, `.rb`, `.kt`, etc.)
- Shebang line or first-line directives if extension is ambiguous.
- Content patterns (keywords, syntax) as fallback.

Log: `Detected language: [LANGUAGE] for [FILENAME]`

### Step 2 — Analysis pass (do NOT edit yet)

Scan the file and build a catalogue of issues:

```
IDENTIFIER ISSUES:
  - [line X] function `a` → rename to `sum` (adds two numbers)
  - [line Y] variable `x` → rename to `userAge`
  - [line Z] class `Mgr` → rename to `UserManager`

EXCEPTION ISSUES:
  - [line X] throw new Exception("bad") → ArgumentException("userId cannot be null or empty")
  - [line Y] raise Exception("fail") → raise ValueError("Expected positive integer, got {value}")

MISSING DOCS:
  - [line X] function `calculateTotal` — no doc comment
  - [line Y] class `OrderProcessor` — no doc comment

COMPLEX LOGIC:
  - [lines X-Y] bitwise mask operation — needs inline comment
  - [lines A-B] regex pattern — needs explanation comment
```

Present this catalogue to the user in a readable summary before making changes. Ask for confirmation if any rename is ambiguous.

### Step 3 — Apply changes

Apply all confirmed improvements to the file(s). Preserve:
- Indentation and whitespace style (tabs vs spaces, line endings).
- Existing comments (do not remove or rewrite user's existing comments unless they are stale after a rename).
- All logic exactly as-is.

When renaming an identifier, rename **all occurrences** consistently across the file (and note if cross-file renaming may be needed).

### Step 4 — Output

- **Overwrite the original file(s) in place** with the modernized content. Do not copy to any output folder.
- After writing, provide a concise change summary per file:
  - Identifiers renamed (old → new)
  - Exceptions improved (old → new)
  - Doc comments added (count)
  - Inline comments added (count)

---

## Language-Specific Doc Comment Formats

Use the idiomatic format for the detected language:

### C# — XML doc comments
```csharp
/// <summary>
/// Calculates the total price including tax.
/// </summary>
/// <param name="basePrice">The pre-tax price.</param>
/// <param name="taxRate">Tax rate as a decimal (e.g., 0.18 for 18%).</param>
/// <returns>The total price after tax.</returns>
public decimal CalculateTotalPrice(decimal basePrice, decimal taxRate)
```

### TypeScript / JavaScript — JSDoc
```typescript
/**
 * Calculates the total price including tax.
 * @param basePrice - The pre-tax price.
 * @param taxRate - Tax rate as a decimal (e.g., 0.18 for 18%).
 * @returns The total price after tax.
 */
function calculateTotalPrice(basePrice: number, taxRate: number): number
```

### Python — docstring (Google style preferred, or numpy if codebase uses it)
```python
def calculate_total_price(base_price: float, tax_rate: float) -> float:
    """Calculate the total price including tax.

    Args:
        base_price: The pre-tax price.
        tax_rate: Tax rate as a decimal (e.g., 0.18 for 18%).

    Returns:
        The total price after tax.
    """
```

### Java / Kotlin — Javadoc
```java
/**
 * Calculates the total price including tax.
 *
 * @param basePrice the pre-tax price
 * @param taxRate   tax rate as a decimal (e.g., 0.18 for 18%)
 * @return the total price after tax
 */
```

### Go — godoc
```go
// CalculateTotalPrice returns the total price after applying the given tax rate.
// taxRate should be a decimal, e.g. 0.18 for 18%.
func CalculateTotalPrice(basePrice float64, taxRate float64) float64
```

### Rust — rustdoc
```rust
/// Calculates the total price including tax.
///
/// # Arguments
/// * `base_price` - The pre-tax price.
/// * `tax_rate` - Tax rate as a decimal (e.g., `0.18` for 18%).
///
/// # Returns
/// The total price after tax.
fn calculate_total_price(base_price: f64, tax_rate: f64) -> f64
```

### PHP — PHPDoc
```php
/**
 * Calculates the total price including tax.
 *
 * @param float $basePrice The pre-tax price.
 * @param float $taxRate   Tax rate as a decimal (e.g., 0.18 for 18%).
 * @return float The total price after tax.
 */
```

### Ruby — YARD
```ruby
# Calculates the total price including tax.
#
# @param base_price [Float] the pre-tax price
# @param tax_rate [Float] tax rate as a decimal (e.g., 0.18 for 18%)
# @return [Float] the total price after tax
```

For any other language, use the closest conventional comment format for that ecosystem.

---

## Exception/Error Improvement Guide

### C#
| Generic | Prefer |
|---|---|
| `Exception` | `ArgumentException`, `ArgumentNullException`, `InvalidOperationException`, `NotSupportedException`, `KeyNotFoundException`, `FormatException`, `OverflowException`, `UnauthorizedAccessException`, `TimeoutException` |

### Python
| Generic | Prefer |
|---|---|
| `Exception` | `ValueError`, `TypeError`, `KeyError`, `IndexError`, `AttributeError`, `RuntimeError`, `NotImplementedError`, `PermissionError`, `FileNotFoundError`, `TimeoutError` |

### Java / Kotlin
| Generic | Prefer |
|---|---|
| `Exception` / `RuntimeException` | `IllegalArgumentException`, `IllegalStateException`, `NullPointerException`, `UnsupportedOperationException`, `NoSuchElementException` |

### TypeScript / JavaScript
| Generic | Prefer |
|---|---|
| `Error` | `TypeError`, `RangeError`, `ReferenceError`, custom error classes extending `Error` |

### Go
Go uses returned errors; improve message clarity:
- `errors.New("error")` → `fmt.Errorf("failed to parse user ID %q: %w", id, err)`

### Rust
- `panic!("error")` → specific `Result<T, E>` returns where applicable (only if the function already returns Result; don't change panics in main logic to Results as that's a logic change).

---

## Identifier Renaming Heuristics

**Functions/Methods:** Name should describe what the function *does* or *returns*.
- Single-letter or abbreviated: `a()` → `add()`, `calc()` → `calculateDiscount()`
- Vague verbs: `process()` → `validateUserInput()`, `do()` → `sendWelcomeEmail()`

**Variables:** Name should describe what the variable *holds*.
- `x`, `y`, `z`, `tmp`, `val`, `res`, `ret` → descriptive names based on usage
- `i`, `j` in nested loops → `rowIndex`, `colIndex` or domain-specific names

**Classes:** Name should be a noun describing the entity.
- `Mgr` → `SessionManager`, `Proc` → `OrderProcessor`

**Parameters:** Same as variables — name based on what the caller is expected to pass.

**Preserve** names that are already clear and idiomatic (e.g., `i` in a simple single-level loop is acceptable, `err` in Go is idiomatic).

---

## Inline Comment Guidelines

Add inline comments for:
- Bitwise operations: explain what bits are being set/checked and why.
- Regex patterns: explain what pattern matches.
- Magic numbers/constants: explain their meaning if not obvious from context.
- Non-obvious algorithm steps: explain the intent behind a transformation.
- Workarounds or known gotchas: explain why a seemingly odd approach is used.

Do NOT add comments that just restate what the code plainly says:
```python
# Bad: increment counter by 1
counter += 1

# Good: (no comment needed — self-evident)
counter += 1
```

---

## Multi-file Handling

If the user provides multiple files:
- Process each file independently for language detection and analysis.
- Note cross-file identifier renaming impact (e.g., "This rename may affect imports in other files — check usages").
- Do not automatically modify files not provided by the user.