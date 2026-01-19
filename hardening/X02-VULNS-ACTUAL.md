# X02: Vulnerability Scan - simple_reflection

## Date: 2026-01-19

---

## VULNERABILITY CATALOG

### V01: Missing Postcondition - SIMPLE_FIELD_INFO.set_value
**Severity:** HIGH
**Location:** `src/simple_field_info.e:92-113`
**Pattern:** CONTRACT GAP

**Description:** The `set_value` command modifies object state through reflection but has no postcondition to verify the mutation succeeded. The type dispatch logic handles a subset of Eiffel types but failures are silent.

**Missing Types in Dispatch:**
- INTEGER_8, INTEGER_16, INTEGER_64
- NATURAL_8, NATURAL_16, NATURAL_32, NATURAL_64
- REAL_32
- CHARACTER_32
- POINTER

**Code:**
```eiffel
set_value (a_object: ANY; a_value: detachable ANY)
    require
        object_exists: a_object /= Void
    do
        -- Type dispatch with gaps...
    end  -- NO POSTCONDITION
```

**Impact:** Type mismatch silently fails, corrupted state possible.

---

### V02: Missing Postcondition - SIMPLE_FIELD_INFO.value
**Severity:** HIGH
**Location:** `src/simple_field_info.e:81-90`
**Pattern:** CONTRACT GAP

**Description:** The `value` query returns field value but has no postcondition linking result to field contents.

**Code:**
```eiffel
value (a_object: ANY): detachable ANY
    require
        object_exists: a_object /= Void
    local
        l_internal: INTERNAL
    do
        create l_internal
        Result := l_internal.field (index, a_object)
    end  -- NO POSTCONDITION
```

**Impact:** Cannot verify correct field was accessed.

---

### V03: Missing Postcondition - SIMPLE_REFLECTED_OBJECT.field_value
**Severity:** HIGH
**Location:** `src/simple_reflected_object.e:37-45`
**Pattern:** CONTRACT GAP

**Description:** Returns field value but no postcondition. If `field_by_name` returns Void (despite precondition), Result silently becomes Void.

**Code:**
```eiffel
field_value (a_name: READABLE_STRING_GENERAL): detachable ANY
    require
        has_field: type_info.has_field (a_name)
    do
        if attached type_info.field_by_name (a_name) as l_field then
            Result := l_field.value (target)
        end
    end  -- NO POSTCONDITION
```

**Impact:** Silent Void on field lookup failure (defensive code masks bug).

---

### V04: Missing Postcondition - SIMPLE_REFLECTED_OBJECT.set_field_value
**Severity:** HIGH
**Location:** `src/simple_reflected_object.e:47-55`
**Pattern:** CONTRACT GAP

**Description:** Sets field value but no postcondition to verify mutation occurred.

**Code:**
```eiffel
set_field_value (a_name: READABLE_STRING_GENERAL; a_value: detachable ANY)
    require
        has_field: type_info.has_field (a_name)
    do
        if attached type_info.field_by_name (a_name) as l_field then
            l_field.set_value (target, a_value)
        end
    end  -- NO POSTCONDITION
```

**Impact:** Write may silently fail, cannot verify mutation.

---

### V05: Object ID Hash Collision
**Severity:** MEDIUM
**Location:** `src/simple_object_graph_walker.e:101-108`
**Pattern:** LOGIC ERROR

**Description:** Object ID calculation uses formula prone to collisions:
```eiffel
Result := l_internal.dynamic_type (a_object) * 1000000 + a_object.generator.hash_code \\ 1000000
```

- Different objects of same type with same `generator.hash_code % 1000000` collide
- Large type_id values cause integer overflow
- Two objects may share object_id, causing walker to skip one

**Impact:** Object graph traversal may miss objects.

---

### V06: Incomplete Type Dispatch
**Severity:** MEDIUM
**Location:** `src/simple_field_info.e:100-112`
**Pattern:** TYPE CONFUSION

**Description:** `set_value` only handles: INTEGER (32), BOOLEAN, CHARACTER_8, REAL_64, reference. Missing:
- All INTEGER_* variants (8, 16, 64)
- All NATURAL_* variants
- REAL_32
- CHARACTER_32
- POINTER

Setting these types falls through to `set_reference_field` which will fail or corrupt.

**Impact:** Type-specific mutations silently fail for unsupported types.

---

### V07: Invalid Type ID Acceptance
**Severity:** MEDIUM
**Location:** `src/simple_type_registry.e:41-55`
**Pattern:** BOUNDARY VIOLATION

**Description:** `type_info_for_type_id` accepts any `a_type_id > 0` but doesn't validate it corresponds to an actual Eiffel type. Invalid type IDs cause INTERNAL to fail unpredictably.

**Precondition:**
```eiffel
require
    valid_type_id: a_type_id > 0
```

Should be: `valid_type_id: {INTERNAL}.is_valid_type_id (a_type_id)` (if such query exists).

**Impact:** Invalid type_id causes crash or undefined behavior in INTERNAL.

---

### V08: Unbounded Recursion Depth
**Severity:** MEDIUM
**Location:** `src/simple_object_graph_walker.e:68-99`
**Pattern:** RESOURCE EXHAUSTION

**Description:** When `max_depth = 0` (unlimited), deeply nested object graphs cause stack overflow. The `walk_object` recursive call has no protection against extreme depth.

**Scenario:** Object graph with 10,000+ levels of nesting causes stack overflow.

**Impact:** Denial of service via deep object graphs.

---

### V09: Linear Scan Not Thread-Safe
**Severity:** LOW
**Location:** `src/simple_type_registry.e:78-90`
**Pattern:** CONCURRENCY HAZARD

**Description:** `type_info_by_name` uses `cache.current_keys` then iterates. In SCOOP context, cache could be modified between getting keys and accessing items.

**Impact:** Potential stale data or missing entries in concurrent access.

---

### V10: Silent Void Return on Lookup Failure
**Severity:** LOW
**Location:** `src/simple_reflected_object.e:37-45, 47-55`
**Pattern:** LOGIC ERROR

**Description:** Both `field_value` and `set_field_value` have defensive `if attached` checks that silently handle lookup failures. The precondition `has_field: type_info.has_field (a_name)` should guarantee success, but the defensive code masks potential bugs if precondition-postcondition linkage breaks.

**Impact:** Bugs hidden by defensive coding.

---

## VULNERABILITY SUMMARY

| ID | Severity | Pattern | Location |
|----|----------|---------|----------|
| V01 | HIGH | CONTRACT GAP | simple_field_info.e:92-113 |
| V02 | HIGH | CONTRACT GAP | simple_field_info.e:81-90 |
| V03 | HIGH | CONTRACT GAP | simple_reflected_object.e:37-45 |
| V04 | HIGH | CONTRACT GAP | simple_reflected_object.e:47-55 |
| V05 | MEDIUM | LOGIC ERROR | simple_object_graph_walker.e:101-108 |
| V06 | MEDIUM | TYPE CONFUSION | simple_field_info.e:100-112 |
| V07 | MEDIUM | BOUNDARY VIOLATION | simple_type_registry.e:41-55 |
| V08 | MEDIUM | RESOURCE EXHAUSTION | simple_object_graph_walker.e:68-99 |
| V09 | LOW | CONCURRENCY HAZARD | simple_type_registry.e:78-90 |
| V10 | LOW | LOGIC ERROR | simple_reflected_object.e:37-45 |

## TOTAL: 10 vulnerabilities (4 HIGH, 4 MEDIUM, 2 LOW)

---

## VERIFICATION CHECKPOINT

- Source files scanned: 9
- Vulnerabilities cataloged: 10
- HIGH priority: 4 (all contract gaps)
- MEDIUM priority: 4
- LOW priority: 2
- hardening/X02-VULNS-ACTUAL.md: CREATED
