# F02: Classify Fix Layers - simple_reflection

## Date: 2026-01-19

---

## BUG-001: Object ID Collision

### LAYER STATUS

| Layer | Status | Notes |
|-------|--------|-------|
| Specification | MALFORMED | Claims "Unique ID" but doesn't define uniqueness |
| Contract | ABSENT | No postcondition guaranteeing uniqueness |
| Code | MALFORMED | Uses class name hash, not object identity |
| Test | ABSENT | No uniqueness test existed |

### ROOT CAUSE LAYER: CODE

The spec implies uniqueness, but code algorithm is fundamentally wrong - it uses class name hash which is identical for all instances of a type.

### FIX PLAN

1. **Spec**: Clarify uniqueness requirement
2. **Contract**: Add postcondition (difficult - would need storing previous IDs)
3. **Code**: Replace algorithm with true object identity
4. **Test**: Add regression test proving uniqueness

### FIX APPROACH: Use `$a_object` (object address) for true identity

---

## BUG-002: INTEGER_64 Crash

### LAYER STATUS

| Layer | Status | Notes |
|-------|--------|-------|
| Specification | MALFORMED | Says "Set field" but doesn't specify type limits |
| Contract | ABSENT | No type compatibility precondition |
| Code | MALFORMED | Missing handlers for most Eiffel types |
| Test | ABSENT | No test for unsupported types existed |

### ROOT CAUSE LAYER: CODE

The spec is vague, but the real issue is incomplete type dispatch in code.

### FIX PLAN

1. **Spec**: Document supported types or claim all types
2. **Contract**: Add precondition checking field type compatibility, OR
3. **Code**: Add handlers for all Eiffel basic types
4. **Test**: Add regression test for INTEGER_64

### FIX APPROACH: Add INTEGER_64 handler (and others in Phase 2)

---

## BUG-003: Invalid Type ID Acceptance

### LAYER STATUS

| Layer | Status | Notes |
|-------|--------|-------|
| Specification | CORRECT | Implies valid type ID needed |
| Contract | MALFORMED | `a_type_id > 0` is too weak |
| Code | CORRECT | Code is fine if precondition is met |
| Test | ABSENT | No invalid type_id test existed |

### ROOT CAUSE LAYER: CONTRACT

Precondition doesn't properly guard against invalid type IDs.

### FIX PLAN

1. **Contract**: Strengthen precondition (if INTERNAL provides validation)
2. **Test**: Add regression test for invalid type_id
3. **Documentation**: Document that invalid type_id behavior is undefined

### FIX APPROACH: Document limitation (INTERNAL doesn't expose validation)

---

## FIX PRIORITY MATRIX

| Bug | Root Layer | Fix Effort | Phase 1 Action |
|-----|------------|------------|----------------|
| BUG-001 | CODE | MEDIUM | FIX - Replace algorithm |
| BUG-002 | CODE | LOW | FIX - Add INTEGER_64 handler |
| BUG-003 | CONTRACT | LOW | DOCUMENT - No runtime validation available |

---

## VERIFICATION CHECKPOINT

- Bugs classified: 3
- Root cause layers: CODE (2), CONTRACT (1)
- Fix plans created: 3
- hardening/F02-CLASSIFY-FIXES.md: CREATED
