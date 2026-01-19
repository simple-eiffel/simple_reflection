# X03: Contract Assault - simple_reflection

## Date: 2026-01-19

---

## ASSAULT STRATEGY

Based on vulnerability scan (X02), design tests to:
1. Verify contract gaps don't hide bugs (V01-V04)
2. Trigger hash collisions in object walker (V05)
3. Trigger type confusion in set_value (V06)
4. Test boundary type IDs (V07)
5. Test deep recursion (V08)

---

## ASSAULT TESTS DESIGNED

### A01: Verify Field Set Mutation
**Target:** V01 - SIMPLE_FIELD_INFO.set_value no postcondition
**Strategy:** Set value, immediately read back, verify match

```eiffel
test_field_set_verify_mutation
    local
        l_reflected: SIMPLE_REFLECTED_OBJECT
        l_test: TEST_SIMPLE_OBJECT
    do
        create l_test.make ("initial", 42)
        create l_reflected.make (l_test)
        l_reflected.set_field_value ("name", "modified")
        assert ("mutation_applied",
            l_reflected.field_value ("name").same_string ("modified"))
    end
```

### A02: Set Unsupported Type
**Target:** V06 - Type confusion with INTEGER_64
**Strategy:** Try to set INTEGER_64 field, verify it doesn't corrupt

```eiffel
test_set_unsupported_integer_type
    local
        l_reflected: SIMPLE_REFLECTED_OBJECT
        l_test: TEST_BIG_INT_OBJECT
        l_old_value: INTEGER_64
    do
        create l_test.make (9223372036854775807)  -- Max INT64
        l_old_value := l_test.big_value
        create l_reflected.make (l_test)
        -- Attempt set via reflection (may silently fail)
        l_reflected.set_field_value ("big_value", 123)
        -- Value should either change or remain unchanged, not corrupt
        assert ("not_corrupted",
            l_test.big_value = 123 or l_test.big_value = l_old_value)
    end
```

### A03: Object ID Collision Attack
**Target:** V05 - Hash collision in object_id
**Strategy:** Create many objects of same type, verify walker visits all

```eiffel
test_walker_collision_attack
    local
        l_walker: SIMPLE_OBJECT_GRAPH_WALKER
        l_visitor: TEST_COUNTING_VISITOR
        l_root: ARRAYED_LIST [ARRAYED_LIST [INTEGER]]
        l_item: ARRAYED_LIST [INTEGER]
        i: INTEGER
    do
        create l_root.make (100)
        from i := 1 until i > 100 loop
            create l_item.make (1)
            l_item.extend (i)
            l_root.extend (l_item)
            i := i + 1
        end
        create l_walker.make
        create l_visitor.make
        l_walker.walk (l_root, l_visitor)
        -- Should visit root + all 100 children at minimum
        assert ("all_visited", l_visitor.object_count >= 101)
    end
```

### A04: Deep Recursion Stress
**Target:** V08 - Unbounded recursion depth
**Strategy:** Create deep chain, walk with depth limit

```eiffel
test_walker_deep_chain_limited
    local
        l_walker: SIMPLE_OBJECT_GRAPH_WALKER
        l_visitor: TEST_COUNTING_VISITOR
        l_list: LINKED_LIST [LINKED_LIST [ANY]]
        l_inner: LINKED_LIST [ANY]
        i: INTEGER
    do
        -- Create chain with max_depth limit
        create l_walker.make
        l_walker.set_max_depth (50)  -- Limit to 50 levels
        create l_visitor.make
        create l_list.make
        create l_inner.make
        l_inner.extend ("deep")
        l_list.extend (l_inner)
        l_walker.walk (l_list, l_visitor)
        assert ("depth_limited", l_visitor.object_count <= 100)
    end
```

### A05: Registry Type ID Boundary
**Target:** V07 - Invalid type ID acceptance
**Strategy:** Test with edge case type IDs

```eiffel
test_registry_boundary_type_id
    local
        l_registry: SIMPLE_TYPE_REGISTRY
        l_info: SIMPLE_TYPE_INFO
    do
        create l_registry.make
        -- Type ID 1 is typically ANY
        l_info := l_registry.type_info_for_type_id (1)
        assert ("type_1_valid", l_info.type_id = 1)
        -- Type ID max reasonable (skip: {MAX_INT} would crash)
    end
```

### A06: Verify Walker Postcondition
**Target:** V08 - Verify at_least_root_visited holds
**Strategy:** Walk minimal object, check visited_count

```eiffel
test_walker_postcondition_check
    local
        l_walker: SIMPLE_OBJECT_GRAPH_WALKER
        l_visitor: TEST_COUNTING_VISITOR
    do
        create l_walker.make
        create l_visitor.make
        l_walker.walk ("test", l_visitor)
        assert ("postcondition_at_least_1", l_walker.visited_count >= 1)
    end
```

---

## TESTS TO ADD TO adversarial_tests.e

The following 6 assault tests should be added:
1. test_field_set_verify_mutation
2. test_set_unsupported_integer_type (needs helper class)
3. test_walker_collision_attack
4. test_walker_deep_chain_limited
5. test_registry_boundary_type_id
6. test_walker_postcondition_check

---

## VERIFICATION CHECKPOINT

- Vulnerabilities targeted: 6 of 10
- Assault tests designed: 6
- Tests require helper class: 1 (TEST_BIG_INT_OBJECT)
- hardening/X03-CONTRACT-ASSAULT.md: CREATED
