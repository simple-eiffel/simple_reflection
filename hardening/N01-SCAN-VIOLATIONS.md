# N01: Scan Naming Violations - simple_reflection

## Date: 2026-01-19

---

## SUMMARY

| Category | Critical | High | Medium | Low | Total |
|----------|----------|------|--------|-----|-------|
| Class names | 0 | 0 | 0 | 0 | 0 |
| Feature names | 0 | 0 | 0 | 0 | 0 |
| Constant names | 0 | 0 | 0 | 0 | 0 |
| Argument names | 0 | 0 | 0 | 0 | 0 |
| Local names | 0 | 0 | 0 | 0 | 0 |
| Cursor names | 0 | 0 | 0 | 3 | 3 |
| Generic params | 0 | 0 | 0 | 0 | 0 |
| Contract tags | 0 | 0 | 0 | 0 | 0 |
| Tuple labels | 0 | 0 | 0 | 0 | 0 |
| Clause labels | 0 | 0 | 0 | 0 | 0 |
| Magic numbers | 0 | 0 | 0 | 5 | 5 |
| **TOTAL** | **0** | **0** | **0** | **8** | **8** |

---

## SCAN 1: CLASS NAMES ✓ CLEAN

All class names follow ALL_CAPS convention:
- SIMPLE_TYPE_INFO ✓
- SIMPLE_TYPE_REGISTRY ✓
- SIMPLE_FIELD_INFO ✓
- SIMPLE_FEATURE_INFO ✓
- SIMPLE_REFLECTED_OBJECT ✓
- SIMPLE_ENUMERATION ✓
- SIMPLE_FLAGS ✓
- SIMPLE_OBJECT_VISITOR ✓
- SIMPLE_OBJECT_GRAPH_WALKER ✓
- LIB_TESTS ✓
- ADVERSARIAL_TESTS ✓
- TEST_STATUS_ENUM ✓
- TEST_PERMISSION_FLAGS ✓
- TEST_COUNTING_VISITOR ✓
- TEST_SIMPLE_OBJECT ✓

---

## SCAN 2: FEATURE NAMES ✓ CLEAN

All feature names follow all_lowercase convention:
- Queries use nouns: `name`, `type_id`, `fields`, `value`
- Commands use verbs: `set_value`, `clear_cache`, `walk`
- Boolean queries use is_/has_ prefix: `is_valid_value`, `has_field`, `is_empty`
- Creation procedures use make prefix: `make`, `make_from_type_id`

---

## SCAN 3: CONSTANT NAMES ✓ CLEAN

No manifest constants found that violate conventions.

---

## SCAN 4: ARGUMENT NAMES ✓ CLEAN

All arguments use a_ prefix:
- `a_type`, `a_type_id`, `a_name`, `a_object`, `a_value`
- `a_root`, `a_visitor`, `a_depth`, `a_action`, `a_flag`

---

## SCAN 5: LOCAL VARIABLE NAMES ✓ CLEAN

All locals follow conventions:
- Standard l_ prefix: `l_internal`, `l_info`, `l_field`, `l_cursor`
- Short loop counters: `i` (acceptable per naming doc)

---

## SCAN 6: CURSOR NAMES - 3 LOW Violations

Loop cursors use `ic` which is acceptable but `ic_` prefix is preferred.

**CURSOR 1:** simple_enumeration.e:32
```eiffel
across Result as ic all is_valid_value (ic) end
```
Severity: LOW (works, but `ic_value` more explicit)

**CURSOR 2:** simple_flags.e:22
```eiffel
across Result as ic all is_power_of_two (ic) end
```
Severity: LOW

**CURSOR 3:** simple_flags.e:192,195
```eiffel
across a_names as ic all is_valid_flag_name (ic) end
across a_names as ic loop set_flag (flag_for_name (ic)) end
```
Severity: LOW

---

## SCAN 7: GENERIC PARAMETERS ✓ CLEAN

No generic parameters defined in source classes.

---

## SCAN 8: CONTRACT TAGS ✓ CLEAN

All contract tags are descriptive:
- Preconditions: `type_exists`, `name_not_empty`, `object_exists`, `valid_flag`
- Postconditions: `type_id_set`, `name_set`, `definition`, `flag_set`
- Invariants: `valid_type_id`, `name_not_empty`, `fields_exist`

---

## SCAN 9: TUPLE LABELS ✓ CLEAN

One tuple with labels found, no conflicts:
```eiffel
TUPLE [arg_name: STRING_32; arg_type_id: INTEGER]
```
Labels `arg_name` and `arg_type_id` don't shadow TUPLE features. ✓

---

## SCAN 10: FEATURE CLAUSE LABELS ✓ CLEAN

Standard labels used:
- `feature {NONE} -- Initialization`
- `feature -- Access`
- `feature -- Status Query`
- `feature -- Element change` (Setting, Modification)
- `feature -- Implementation`

---

## SCAN 11: MAGIC NUMBERS - 5 LOW Violations

**MAGIC 1:** simple_type_info.e:175-177
```eiffel
create fields.make (10)
create features.make (10)
create creation_procedures.make (2)
```
Numbers: 10, 10, 2 (initial capacities)
Severity: LOW (collection capacities, acceptable)

**MAGIC 2:** simple_type_registry.e:18
```eiffel
create cache.make (100)
```
Number: 100 (initial capacity)
Severity: LOW

**MAGIC 3:** simple_object_graph_walker.e:18
```eiffel
create visited.make (100)
```
Number: 100 (initial capacity)
Severity: LOW

**MAGIC 4:** simple_object_graph_walker.e:112,114
```eiffel
Result := l_internal.dynamic_type (a_object) * 100000 + (a_object.out.hash_code \\ 100000)
```
Number: 100000 (hash range multiplier)
Severity: LOW (algorithm constant, could be named)

---

## CRITICAL VIOLATIONS: NONE

No critical naming violations that cause compile errors.

---

## VERIFICATION CHECKPOINT

- Files scanned: 15 (9 src + 6 testing)
- Classes scanned: 15
- Features scanned: ~150
- Critical violations: 0
- Total violations: 8 (all LOW)
- hardening/N01-SCAN-VIOLATIONS.md: CREATED
