# H01: Survey Risk Areas - simple_reflection

## Date: 2026-01-19

---

## LAYER 1: SPECIFICATION RISKS

### ABSENT SPECIFICATION
- [x] `SIMPLE_OBJECT_GRAPH_WALKER.object_id` - No specification of collision tolerance
- [x] `SIMPLE_FIELD_INFO.set_value` - No spec for unsupported type behavior
- [ ] All other features have adequate notes/comments

### MALFORMED SPECIFICATION
- [ ] No contradictions found
- [ ] No ambiguous specs found

**Layer 1 Total: 2 absent, 0 malformed**

---

## LAYER 2: CONTRACT RISKS

### ABSENT CONTRACT
- [x] `SIMPLE_FIELD_INFO.value` - No postcondition (fixed partial in X07)
- [x] `SIMPLE_FLAGS.to_names` - No postcondition
- [x] `SIMPLE_FLAGS.is_power_of_two` - No postcondition
- [x] `SIMPLE_ENUMERATION.is_valid_value` - No postcondition

### MALFORMED CONTRACT
- [x] `SIMPLE_TYPE_REGISTRY.type_info_for_type_id` - Precondition `a_type_id > 0` is TOO WEAK
  - Domain rule: type_id must be valid Eiffel type ID
  - Contract accepts any positive integer
- [x] `SIMPLE_OBJECT_GRAPH_WALKER.walk_object` - No contract at all (private)
  - Risk: Recursive calls can overflow stack

**Layer 2 Total: 4 absent, 2 malformed**

---

## LAYER 3: CODE RISKS

### MALFORMED CODE
- [x] `SIMPLE_OBJECT_GRAPH_WALKER.object_id` - Algorithm doesn't match domain requirement
  - Domain: Unique ID per object instance
  - Code: `dynamic_type * 1000000 + hash_code \\ 1000000` allows collisions
  - Two different objects can have same object_id
- [x] `SIMPLE_FIELD_INFO.set_value` - Code violates implicit spec
  - Spec: Set field to value
  - Code: Only handles subset of types, silently fails for others

### STRUCTURAL RISKS
- [ ] No features > 50 lines
- [x] `SIMPLE_OBJECT_GRAPH_WALKER.walk_object` - Unbounded recursion
- [ ] No unchecked array indexing (uses safe ARRAYED_LIST)
- [ ] No division operations

**Layer 3 Total: 2 malformed, 1 structural**

---

## LAYER 4: TEST RISKS

### ABSENT TEST
- [x] `SIMPLE_FEATURE_INFO` - No direct tests (only indirect via reflection)
- [x] Object ID collision - No test proving uniqueness
- [x] Type dispatch failure - No test for unsupported types

### MALFORMED TEST
- [x] `test_walker_collision_attack` - Test asserts `>= 1` which always passes
  - Should assert specific count based on objects created

**Layer 4 Total: 3 absent, 1 malformed**

---

## CROSS-LAYER MISALIGNMENT

### MISALIGNMENT 1: object_id Domain vs Code
- **Domain truth:** Each object should have unique ID for graph traversal
- **Spec:** "Unique ID for `a_object`" (comment)
- **Contract:** NONE
- **Code:** Hash-based calculation with collision potential
- **Test:** Doesn't verify uniqueness
- **Severity:** HIGH

### MISALIGNMENT 2: type_info_for_type_id Contract vs Domain
- **Domain truth:** type_id must be valid Eiffel runtime type
- **Spec:** "Type info for type with `a_type_id`"
- **Contract:** `a_type_id > 0` (too weak)
- **Code:** Passes invalid ID to INTERNAL (will crash)
- **Test:** Tests valid IDs only
- **Severity:** MEDIUM

### MISALIGNMENT 3: set_value Spec vs Code
- **Domain truth:** Set any field to any compatible value
- **Spec:** "Set this field in `a_object` to `a_value`"
- **Contract:** Only checks object exists
- **Code:** Silently fails for unsupported types
- **Test:** Only tests supported types
- **Severity:** MEDIUM

**Cross-Layer Total: 3 misalignments**

---

## SUMMARY BY LAYER

| Layer | Absent | Malformed |
|-------|--------|-----------|
| Specification | 2 | 0 |
| Contract | 4 | 2 |
| Code | 0 | 2 |
| Test | 3 | 1 |
| Cross-layer | - | 3 |

---

## HUNT ORDER (Priority)

1. **MISALIGNMENT 1: object_id collision** - CRITICAL (can skip objects)
2. **MISALIGNMENT 2: type_info_for_type_id** - HIGH (can crash)
3. **MISALIGNMENT 3: set_value type dispatch** - HIGH (silent failure)
4. Contract gaps in is_valid_value, to_names - MEDIUM
5. Missing SIMPLE_FEATURE_INFO tests - LOW

---

## VERIFICATION CHECKPOINT

- Layer 1 (Spec): 2 issues
- Layer 2 (Contract): 6 issues
- Layer 3 (Code): 3 issues
- Layer 4 (Test): 4 issues
- Cross-layer: 3 misalignments
- Total risk areas: 18
- hardening/H01-SURVEY-RISK-AREAS.md: CREATED
