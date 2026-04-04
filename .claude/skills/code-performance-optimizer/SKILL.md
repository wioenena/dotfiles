---
name: code-performance-optimizer
description: >
  Analyzes source code files in any programming language and transforms them into modern, high-performance code.
  Identifies algorithmic bottlenecks, inefficient data structures, redundant computation, memory waste,
  and language-specific anti-patterns — then rewrites the code to eliminate them.

  Use this skill when the user asks to optimize, speed up, or improve performance. Also trigger for:
  "my code is slow", "make this faster", "performance issues", "optimize this", "analyze bottlenecks",
  "refactor for efficiency", or when the user shares files and wants improvements beyond readability.

  Covers ALL languages (C#, Python, TypeScript, Go, Rust, Java, Kotlin, etc.). Unlike code-modernizer,
  this skill WILL change algorithms and logic when needed for real performance gains.
---

# Code Performance Optimizer Skill

Analyzes and rewrites code for maximum performance, modern idioms, and readability — across any language.

---

## What This Skill Does

Given one or more source files, Claude will:

1. **Detect language and runtime context** from file extension, imports, and content patterns.
2. **Run a performance analysis pass** — catalogue bottlenecks by category (see below).
3. **Estimate impact** for each finding (High / Medium / Low).
4. **Apply optimizations** with clear before/after explanations.
5. **Add doc comments and inline annotations** explaining *why* each optimization was made.
6. **Modernize syntax and APIs** to current language standards.

---

## Performance Analysis Categories

### 🔴 Algorithmic Complexity
- O(n²) or worse where O(n log n) or O(n) is achievable
- Linear search in loops when a set/map lookup would be O(1)
- Repeated sorting of the same data
- Recomputing values inside loops that could be hoisted

### 🟠 Data Structure Inefficiency
- Using List/Array for membership checks → use Set/HashSet
- Using string concatenation in loops → use StringBuilder / join / buffer
- Rebuilding collections on every call
- Unnecessary copying of large structures

### 🟡 Redundant Computation
- Calling `.Count`, `.length`, `.size()` in every loop iteration
- Repeated property/field access that could be cached in a local
- Duplicate database or I/O calls within the same scope
- Dead code, unused variables, unreachable branches

### 🟢 Memory & Allocation
- Allocating inside hot loops (avoid GC pressure)
- Keeping references alive longer than needed
- Large object graphs that could be streamed or paged
- Missing `using` / `defer` / RAII patterns causing resource leaks

### 🔵 Language-Specific Anti-Patterns
Common examples by language — full list in the **Language-Specific Guidance** section below:
- C#: `.Result`/`.Wait()` on async, no `AsNoTracking()` on read-only EF queries, LINQ in tight loops
- Python: `+` string concat in loops, `list` for membership, repeated attribute lookup in hot loops
- TypeScript: chained `.filter().map()` inside loops, sequential `await` where `Promise.all` fits, `JSON.parse(JSON.stringify())` for clone
- Go: unbounded slice growth, string `+` concat, missing `sync.Pool` for hot-path allocations
- Rust: unnecessary `.clone()` in hot paths, missing `Vec::with_capacity`, index loops instead of iterators
- Java/Kotlin: `ArrayList` for lookup, `+` in loops, eager streams on tiny collections

### ⚪ Readability & Maintainability
- Rename cryptic identifiers
- Replace magic numbers with named constants
- Add doc comments and explain non-obvious optimizations
- Modernize syntax to current language version

---

## Step-by-Step Workflow

### Step 1 — Read and Identify

Read each target file. Determine:
- Language from extension + content
- Runtime context (web server, CLI, batch job, library, etc.) — affects what optimizations are safe
- Entry points and hot paths (functions called in loops or on every request)

Log: `Detected: [LANGUAGE] | Context: [CONTEXT] | Entry points: [LIST]`

### Step 2 — Analysis Pass (do NOT edit yet)

Scan the entire file and produce a structured catalogue:

```
PERFORMANCE FINDINGS — [FILENAME]
──────────────────────────────────
[HIGH]   Line 42-55  | O(n²) nested loop — use HashMap lookup instead
[HIGH]   Line 78     | String concat in loop (×n allocations) — use StringBuilder
[MEDIUM] Line 23     | .Length called inside loop — hoist to variable
[MEDIUM] Line 100    | List used for membership check — use HashSet
[LOW]    Line 15     | Dead variable `temp` never read
[LOW]    Line 60     | Magic number 86400 — extract as SECONDS_PER_DAY constant

MODERNIZATION FINDINGS
──────────────────────
[INFO]   Line 30     | Manual null check → use null-conditional operator ?.
[INFO]   Line 88     | for loop over collection → use LINQ / stream / iterator
[INFO]   Line 12     | Catches generic Exception → catch specific types
```

Present this catalogue to the user. For HIGH impact items that change algorithm logic, ask for
confirmation before proceeding. For LOW/INFO items, proceed unless the user says otherwise.

### Step 3 — Apply Optimizations

Apply all confirmed changes. For every non-trivial change, add an inline comment:

```csharp
// PERF: Was O(n) list search — changed to O(1) HashSet lookup
// PERF: Hoisted .Count out of loop (was recalculated n times)
// MODERNIZED: Replaced manual for-loop with LINQ for clarity
```

Preserve:
- Indentation and whitespace style
- Public API signatures (unless user explicitly allows breaking changes)
- Existing comments (unless they describe code that was changed)

### Step 4 — Output

Edit the original file(s) in place using the available file editing tools. Then provide a concise per-file summary:
- Algorithmic changes (old complexity → new)
- Data structure changes
- Memory/allocation improvements
- Lines of dead code removed
- Syntax modernizations applied

---

## Language-Specific Guidance

### C# / .NET
- `List<T>` → `HashSet<T>` for membership, `Dictionary<K,V>` for keyed lookup
- String concat in loop → `StringBuilder` or `string.Join`
- `async/await` over `.Result` / `.Wait()` (avoid deadlocks)
- LINQ: prefer `Where().Select()` chains over manual loops for readability; avoid LINQ inside tight loops (allocation overhead)
- `Span<T>` / `Memory<T>` for slicing without allocation
- `record` types for immutable data (C# 9+)
- Pattern matching (`switch` expressions, `is` patterns) over chains of if/else casts
- EF Core: use `AsNoTracking()` for read-only queries, avoid N+1 with `.Include()`

### Python
- List comprehensions over `for` + `.append()`
- `set` / `dict` for membership / keyed lookup instead of `list`
- Generator expressions (`yield`) to avoid materializing large sequences
- `collections.Counter`, `defaultdict`, `deque` — use stdlib instead of manual equivalents
- `str.join()` instead of `+` concatenation in loops
- `functools.lru_cache` / `cache` for pure functions called repeatedly
- Avoid repeated attribute lookup in hot loops — cache `obj.attr` in local variable
- Use `enumerate()` / `zip()` instead of manual index arithmetic

### TypeScript / JavaScript
- `Map` / `Set` over plain objects for frequent lookups/membership
- Avoid `Array.prototype.find/filter/map` chains inside loops (O(n²))
- `Promise.all()` for parallel async instead of sequential `await`
- Avoid `JSON.parse(JSON.stringify(x))` for deep clone — use `structuredClone()`
- Use `const` over `let` where value doesn't change (enables engine optimization hints)
- Prefer `for...of` with early `break` over `.forEach()` (can't break out of forEach)
- Debounce/throttle expensive handlers (resize, scroll, input)

### Go
- Prefer `sync.Pool` for frequently allocated short-lived objects
- Preallocate slices with `make([]T, 0, expectedLen)` to avoid repeated growth
- Use buffered channels or batch processing to reduce goroutine contention
- `strings.Builder` instead of `+` concatenation
- Return errors, don't panic in library code
- Use `sync.RWMutex` when reads vastly outnumber writes

### Java / Kotlin
- `HashMap` / `HashSet` over `ArrayList` for lookup-heavy operations
- `StringBuilder` instead of `+` in loops
- Stream API for collection pipelines (but avoid for tiny collections — overhead)
- `Optional` to express nullable results clearly (Java)
- Kotlin: use `sequence {}` for lazy evaluation, `data class` for value objects, `?:` for null-safe defaults
- Avoid boxing/unboxing in tight loops — use primitive arrays or specialized collections

### Rust
- Prefer iterators over manual index loops (enables LLVM optimizations)
- Use `Vec::with_capacity()` when final size is known
- Avoid `.clone()` in hot paths — borrow or restructure ownership
- `HashMap::entry()` API to avoid double lookup
- Use `Cow<str>` for functions that sometimes allocate, sometimes borrow
- Prefer `&str` over `String` in function parameters unless ownership is needed

---

## Impact Estimation Guide

| Impact | Criteria |
|--------|----------|
| HIGH   | O(n²)→O(n) or O(n log n), removing repeated I/O, fixing N+1 queries, eliminating allocation in hot loops |
| MEDIUM | Hoisting loop-invariant computation, replacing linear search with hash lookup for moderate n, removing redundant copies |
| LOW    | Dead code removal, magic numbers, minor syntax modernization |

When multiple HIGH findings combine, note the cumulative effect.

---

## Safety Rules

- **Never break public APIs** without explicit user permission.
- **Never remove error handling** even if it looks defensive/redundant — ask the user.
- **Never change business logic** as a side effect of performance work. If a bug is spotted, note it separately — don't silently fix it.
- **Flag thread-safety implications** if concurrency model is changed (e.g., adding caching).
- **Benchmark-driven**: if the codebase has existing tests, note which tests cover the changed code so the user can verify correctness after applying.
