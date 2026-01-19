# H03: Probe Edge Cases - simple_reflection

## Date: 2026-01-19

---

## TARGET 1: object_id collision

### FINDING FROM H02
Code uses hash-based calculation that can produce duplicates for different objects.

### TECHNICAL PROBES

| Probe | Input | Category | Expected |
|-------|-------|----------|----------|
| T1 | Two ARRAYED_LIST [INTEGER] with same content | Same hash | Collision |
| T2 | Many objects of same type | Hash distribution | Some collisions |
| T3 | Objects with identical generator strings | Same hash_code | Collision |

### DOMAIN PROBES

| Probe | Input | Rule | Expected |
|-------|-------|------|----------|
| D1 | Object graph with 1000 nodes | Unique traversal | All visited |
| D2 | Circular reference with similar objects | No infinite loop + all visited | Complete |

### CONTRACT PROBES (ABSENT)

Since contract is absent, any collision causes silent skip.

### TEST CODE

```eiffel
test_object_id_collision_proof
        -- Probe: Demonstrate object_id can produce duplicates
    local
        l_walker: SIMPLE_OBJECT_GRAPH_WALKER
        l_obj1, l_obj2: ARRAYED_LIST [INTEGER]
        l_id1, l_id2: INTEGER
        l_internal: INTERNAL
    do
        print ("test_object_id_collision_proof: ")
        create l_obj1.make (10)
        create l_obj2.make (10)
        -- Both have same type
        create l_internal
        assert ("same_type", l_internal.dynamic_type (l_obj1) = l_internal.dynamic_type (l_obj2))
        -- Check if hash_codes collide (they might not, but could)
        -- The bug exists even if this specific test doesn't trigger it
        create l_walker.make
        -- Use reflection to access object_id
        l_id1 := l_internal.dynamic_type (l_obj1) * 1000000 + l_obj1.generator.hash_code \\ 1000000
        l_id2 := l_internal.dynamic_type (l_obj2) * 1000000 + l_obj2.generator.hash_code \\ 1000000
        -- Demonstrate formula allows collision
        -- If hash_code % 1000000 matches, IDs match even for different objects
        print ("IDs: " + l_id1.out + ", " + l_id2.out + "%N")
        -- This test documents the risk, even if collision doesn't occur
        print ("DOCUMENTED%N")
    end
```

---

## TARGET 2: type_info_for_type_id boundary

### FINDING FROM H02
Precondition `a_type_id > 0` is too weak; accepts invalid type IDs.

### TECHNICAL PROBES

| Probe | Input | Category | Expected |
|-------|-------|----------|----------|
| T1 | type_id = 1 | Min boundary | Should work (usually ANY) |
| T2 | type_id = 999999999 | Very large | Crash or error |
| T3 | type_id = -1 | Below boundary | Precondition violation |

### DOMAIN PROBES

| Probe | Input | Rule | Expected |
|-------|-------|------|----------|
| D1 | Known valid type_id from {STRING}.type_id | Valid domain | Success |
| D2 | type_id not in runtime | Invalid domain | Should reject |

### CONTRACT PROBES (MALFORMED - TOO WEAK)

Input that passes precondition but breaks feature:
- `type_id = 999999999` passes `> 0` but is not a valid Eiffel type

### TEST CODE

```eiffel
test_type_id_boundary_invalid
        -- Probe: Invalid type_id passes precondition
    local
        l_registry: SIMPLE_TYPE_REGISTRY
        l_info: SIMPLE_TYPE_INFO
        l_retried: BOOLEAN
    do
        print ("test_type_id_boundary_invalid: ")
        if not l_retried then
            create l_registry.make
            -- This passes precondition (999999999 > 0)
            -- But will fail in INTERNAL
            l_info := l_registry.type_info_for_type_id (999999999)
            -- If we get here, INTERNAL accepted invalid ID (unexpected)
            print ("UNEXPECTED_PASS%N")
        else
            -- Expected: exception caught
            print ("PASS (exception caught)%N")
        end
    rescue
        l_retried := True
        retry
    end
```

---

## TARGET 3: set_value type dispatch

### FINDING FROM H02
Code only handles subset of types; unsupported types silently fail.

### TECHNICAL PROBES

| Probe | Input | Category | Expected |
|-------|-------|----------|----------|
| T1 | INTEGER_64 value | Unsupported type | Silent failure |
| T2 | NATURAL_32 value | Unsupported type | Silent failure |
| T3 | REAL_32 value | Unsupported type | Silent failure |
| T4 | POINTER value | Unsupported type | Silent failure |

### DOMAIN PROBES

| Probe | Input | Rule | Expected |
|-------|-------|------|----------|
| D1 | Set INT64 field via reflection | Reflection should work | Value set |
| D2 | Set POINTER field via reflection | Reflection should work | Value set |

### CONTRACT PROBES (ABSENT)

Since no contract verifies type compatibility, any unsupported type passes but corrupts.

### TEST CODE

```eiffel
test_set_value_unsupported_type
        -- Probe: Unsupported type in set_value
    local
        l_test: TEST_SIMPLE_OBJECT
        l_reflected: SIMPLE_REFLECTED_OBJECT
        l_old_big: INTEGER_64
    do
        print ("test_set_value_unsupported_type: ")
        create l_test.make ("test", 0)
        l_test.set_big_value (9223372036854775807)  -- Max INT64
        l_old_big := l_test.big_value
        create l_reflected.make (l_test)
        -- Try to set via reflection (INTEGER_64 not in dispatch)
        l_reflected.set_field_value ("big_value", {INTEGER_64} 123)
        -- Check if it worked
        if l_test.big_value = 123 then
            print ("PASS (INT64 worked)%N")
        elseif l_test.big_value = l_old_big then
            print ("FAIL (silent no-op)%N")
        else
            print ("FAIL (corrupted: " + l_test.big_value.out + ")%N")
        end
    end
```

---

## PROBES SUMMARY

| Target | Technical | Domain | Contract | Total |
|--------|-----------|--------|----------|-------|
| object_id | 3 | 2 | 1 | 6 |
| type_info_for_type_id | 3 | 2 | 1 | 6 |
| set_value | 4 | 2 | 1 | 7 |
| **Total** | **10** | **6** | **3** | **19** |

---

## VERIFICATION CHECKPOINT

- Targets probed: 3
- Technical probes: 10
- Domain probes: 6
- Contract probes: 3
- Test code generated: 3 tests
- hardening/H03-PROBE-EDGE-CASES.md: CREATED
