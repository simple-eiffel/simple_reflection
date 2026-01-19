# H02: Analyze Semantic Alignment - simple_reflection

## Date: 2026-01-19

---

## FEATURE 1: SIMPLE_OBJECT_GRAPH_WALKER.object_id

### ALIGNMENT TRACE

| Layer | Says |
|-------|------|
| Domain truth | Each object instance needs unique identifier for graph traversal |
| Spec says | "Unique ID for `a_object`" (line 101-102) |
| Contract says | ABSENT |
| Code does | `dynamic_type * 1000000 + a_object.generator.hash_code \\ 1000000` |
| Test expects | ABSENT (no uniqueness test) |

### ALIGNMENT STATUS
- Domain → Spec: **ALIGNED** (spec claims uniqueness)
- Spec → Contract: **CONTRACT_ABSENT**
- Contract → Code: **N/A** (no contract)
- Code → Test: **TEST_ABSENT**

### GAPS FOUND

**Gap 1: Between Spec and Code**
- Spec says: "Unique ID for `a_object`"
- Code does: Hash-based calculation with collision potential
- Bug implication: Two different objects of same type with same `generator.hash_code % 1000000` will have identical object_id, causing walker to skip the second object

**Gap 2: Between Code and Domain**
- Domain requires: True object identity
- Code provides: Hash-based pseudo-identity
- Bug implication: Graph traversal incomplete in presence of hash collisions

### MALFORMATIONS FOUND
- **Code: MALFORMED** - Algorithm doesn't guarantee spec claim
- **Contract: ABSENT** - No postcondition `Result = {unique for this object}`

### PRIORITY: **CRITICAL**

---

## FEATURE 2: SIMPLE_TYPE_REGISTRY.type_info_for_type_id

### ALIGNMENT TRACE

| Layer | Says |
|-------|------|
| Domain truth | Type IDs are assigned by Eiffel runtime; invalid IDs don't correspond to real types |
| Spec says | "Type info for type with `a_type_id`" (line 41-42) |
| Contract says | `valid_type_id: a_type_id > 0` (line 44) |
| Code does | Passes type_id to INTERNAL.type_name_of_type (crashes on invalid) |
| Test expects | Valid type_id always used |

### ALIGNMENT STATUS
- Domain → Spec: **ALIGNED**
- Spec → Contract: **MISALIGNED** (contract too weak)
- Contract → Code: **CODE_ASSUMES_STRONGER** (code expects valid runtime type)
- Code → Test: **ALIGNED** (tests only use valid IDs)

### GAPS FOUND

**Gap 1: Between Domain and Contract**
- Domain requires: type_id must be valid Eiffel type
- Contract accepts: Any positive integer
- Bug implication: Passing 999999999 passes precondition but crashes in INTERNAL

### MALFORMATIONS FOUND
- **Contract: MALFORMED (TOO WEAK)** - Precondition accepts invalid inputs
- **Code: FRAGILE** - Depends on INTERNAL behavior for invalid input

### PRIORITY: **HIGH**

---

## FEATURE 3: SIMPLE_FIELD_INFO.set_value

### ALIGNMENT TRACE

| Layer | Says |
|-------|------|
| Domain truth | Eiffel has many basic types (INTEGER_8/16/32/64, NATURAL_*, REAL_32/64, etc.) |
| Spec says | "Set this field in `a_object` to `a_value`" (line 92-93) |
| Contract says | `object_exists: a_object /= Void` (line 95) |
| Code does | Handles INTEGER_32, BOOLEAN, CHARACTER_8, REAL_64, references only |
| Test expects | Supported types only tested |

### ALIGNMENT STATUS
- Domain → Spec: **MISALIGNED** (spec implies all types, domain has many)
- Spec → Contract: **CONTRACT_ABSENT** (no type compatibility check)
- Contract → Code: **MISALIGNED** (code silently fails for unsupported)
- Code → Test: **TEST_ABSENT** (no unsupported type test)

### GAPS FOUND

**Gap 1: Between Spec and Code**
- Spec implies: Set field to value (general)
- Code does: Only handles subset of types
- Bug implication: Setting INTEGER_64 field falls through to set_reference_field, corrupting data

**Gap 2: Between Code and Contract**
- Code behavior: Silent failure for unsupported types
- Contract: No postcondition to verify
- Bug implication: User thinks field is set, but it isn't (or is corrupted)

### MALFORMATIONS FOUND
- **Spec: INCOMPLETE** - Doesn't specify type support limits
- **Contract: ABSENT** - No type compatibility precondition
- **Code: SILENT FAILURE** - Doesn't reject unsupported types

### PRIORITY: **HIGH**

---

## SUMMARY

| Feature | Gap Count | Priority | Fix Layer |
|---------|-----------|----------|-----------|
| object_id | 2 | CRITICAL | Code (algorithm) |
| type_info_for_type_id | 1 | HIGH | Contract (strengthen) |
| set_value | 2 | HIGH | Contract + Spec |

---

## VERIFICATION CHECKPOINT

- Features analyzed: 3
- Alignment traces complete: 3
- Gaps identified: 5
- Malformations: 7
- hardening/H02-ANALYZE-SEMANTICS.md: CREATED
