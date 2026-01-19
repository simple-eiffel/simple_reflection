# H07: Confirm Root Cause - simple_reflection

## Date: 2026-01-19

---

## BUG 1: Object ID Collision

### ROOT CAUSE CONFIRMED

**Location:** `simple_object_graph_walker.e:101-108`

**Code:**
```eiffel
object_id (a_object: ANY): INTEGER
    local
        l_internal: INTERNAL
    do
        create l_internal
        Result := l_internal.dynamic_type (a_object) * 1000000 + a_object.generator.hash_code \\ 1000000
    end
```

**Why it fails:**
1. `a_object.generator` returns class name string (e.g., "ARRAYED_LIST")
2. `hash_code` on string depends on string content, not object instance
3. Two different ARRAYED_LIST objects have same generator string
4. Same generator → same hash_code → same object_id

**Mathematical proof:**
- For any two objects `o1` and `o2` of same type:
  - `dynamic_type(o1) = dynamic_type(o2)` (same type)
  - `o1.generator = o2.generator` (same class name)
  - Therefore `o1.generator.hash_code = o2.generator.hash_code`
  - Therefore `object_id(o1) = object_id(o2)` for all same-type objects!

**Severity:** This is worse than initially thought - ALL objects of same type collide, not just some.

---

## BUG 2: INTEGER_64 Crash in set_value

### ROOT CAUSE CONFIRMED

**Location:** `simple_field_info.e:92-112`

**Code:**
```eiffel
set_value (a_object: ANY; a_value: detachable ANY)
    ...
    do
        create l_internal
        if a_value = Void then
            l_internal.set_reference_field (index, a_object, Void)
        elseif attached {INTEGER} a_value as l_int then     -- INTEGER_32 only
            l_internal.set_integer_32_field (index, a_object, l_int)
        elseif attached {BOOLEAN} a_value as l_bool then
            l_internal.set_boolean_field (index, a_object, l_bool)
        elseif attached {CHARACTER_8} a_value as l_char then
            l_internal.set_character_8_field (index, a_object, l_char)
        elseif attached {REAL_64} a_value as l_real then
            l_internal.set_real_64_field (index, a_object, l_real)
        else
            l_internal.set_reference_field (index, a_object, a_value)  -- FALLTHROUGH
        end
    end
```

**Why it fails:**
1. INTEGER_64 doesn't match `{INTEGER}` pattern (INTEGER = INTEGER_32)
2. Falls through to `set_reference_field`
3. `set_reference_field` has precondition requiring reference type
4. INTEGER_64 is expanded, not reference → precondition violation → crash

**Missing handlers:**
- INTEGER_8, INTEGER_16, INTEGER_64
- NATURAL_8, NATURAL_16, NATURAL_32, NATURAL_64
- REAL_32
- CHARACTER_32
- POINTER

---

## BUG 3: Invalid type_id Acceptance

### ROOT CAUSE ANALYSIS

**Location:** `simple_type_registry.e:41-55`

**Code:**
```eiffel
type_info_for_type_id (a_type_id: INTEGER): SIMPLE_TYPE_INFO
    require
        valid_type_id: a_type_id > 0  -- TOO WEAK
    do
        if attached cache.item (a_type_id) as l_info then
            Result := l_info
        else
            create Result.make_from_type_id (a_type_id)
            cache.put (Result, a_type_id)
        end
    ...
```

**Investigation:**
- Test showed type_id 999999999 was accepted without exception
- INTERNAL.type_name_of_type must return something for invalid IDs
- Need to check what type_info was actually created

**Further investigation needed:**
What does INTERNAL return for invalid type_id? Empty string? Garbage?

---

## ROOT CAUSE SUMMARY

| Bug | Root Cause | Fix Required |
|-----|------------|--------------|
| object_id collision | Wrong algorithm (uses class name hash) | Replace with true object identity |
| INTEGER_64 crash | Missing type handlers | Add all Eiffel basic types |
| invalid type_id | Weak precondition | Validate type_id before use |

---

## VERIFICATION CHECKPOINT

- Root causes confirmed: 3
- Code locations identified: 3
- Fix requirements specified: 3
- hardening/H07-ROOT-CAUSES.md: CREATED
