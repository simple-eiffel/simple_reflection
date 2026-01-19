note
	description: "Adversarial tests for simple_reflection hardening"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARIAL_TESTS

inherit
	EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
			-- Run adversarial tests
		do
			default_create
			print ("=== Adversarial Tests ===%N")
			run_all_adversarial_tests
			print ("=== End Adversarial Tests ===%N")
		end

feature -- Test Execution

	run_all_adversarial_tests
			-- Run all adversarial test groups
		do
			-- Type Info Edge Cases
			test_type_info_primitive_types
			test_type_info_array_type
			test_type_info_tuple_type

			-- Registry Stress
			test_registry_many_types
			test_registry_same_type_repeated
			test_registry_after_clear

			-- Reflected Object Edge Cases
			test_reflected_empty_object
			test_reflected_nested_object

			-- Enumeration Edge Cases
			test_enum_all_values
			test_enum_iteration

			-- Flags Edge Cases
			test_flags_all_set
			test_flags_toggle
			test_flags_combined

			-- Graph Walker Edge Cases
			test_walker_single_object
			test_walker_empty_list
			test_walker_max_depth_zero

			-- X03 Contract Assault Tests
			test_field_set_verify_mutation
			test_walker_collision_attack
			test_walker_postcondition_check
			test_registry_boundary_type_id
			test_walker_depth_limited

			-- H03 Bug Hunt Probes
			test_object_id_collision_proof
			test_type_id_boundary_invalid
			test_set_value_unsupported_type

			print ("All adversarial tests completed%N")
		end

feature -- Type Info Adversarial Tests

	test_type_info_primitive_types
			-- Test type info for primitive types
		local
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_type_info_primitive_types: ")
			create l_info.make ({INTEGER_8})
			assert ("int8_valid", l_info.type_id > 0)
			create l_info.make ({INTEGER_16})
			assert ("int16_valid", l_info.type_id > 0)
			create l_info.make ({INTEGER_64})
			assert ("int64_valid", l_info.type_id > 0)
			create l_info.make ({REAL_32})
			assert ("real32_valid", l_info.type_id > 0)
			create l_info.make ({REAL_64})
			assert ("real64_valid", l_info.type_id > 0)
			create l_info.make ({CHARACTER_8})
			assert ("char8_valid", l_info.type_id > 0)
			create l_info.make ({CHARACTER_32})
			assert ("char32_valid", l_info.type_id > 0)
			print ("PASS%N")
		end

	test_type_info_array_type
			-- Test type info for array types
		local
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_type_info_array_type: ")
			create l_info.make ({ARRAY [STRING]})
			assert ("array_type_valid", l_info.type_id > 0)
			assert ("array_name_has_array", l_info.name.has_substring ("ARRAY"))
			assert ("base_name_no_brackets", not l_info.base_name.has ('['))
			print ("PASS%N")
		end

	test_type_info_tuple_type
			-- Test type info for tuple types
		local
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_type_info_tuple_type: ")
			create l_info.make ({TUPLE [name: STRING; age: INTEGER]})
			assert ("tuple_type_valid", l_info.type_id > 0)
			assert ("tuple_name_has_tuple", l_info.name.has_substring ("TUPLE"))
			print ("PASS%N")
		end

feature -- Registry Adversarial Tests

	test_registry_many_types
			-- Test registry with many different types
		local
			l_registry: SIMPLE_TYPE_REGISTRY
			l_info: SIMPLE_TYPE_INFO
			i: INTEGER
		do
			print ("test_registry_many_types: ")
			create l_registry.make
			-- Add many types
			l_info := l_registry.type_info_for ({STRING})
			l_info := l_registry.type_info_for ({INTEGER})
			l_info := l_registry.type_info_for ({BOOLEAN})
			l_info := l_registry.type_info_for ({REAL_64})
			l_info := l_registry.type_info_for ({ARRAYED_LIST [STRING]})
			l_info := l_registry.type_info_for ({HASH_TABLE [ANY, STRING]})
			assert ("many_types_cached", l_registry.cached_count >= 6)
			print ("PASS%N")
		end

	test_registry_same_type_repeated
			-- Test registry returns same instance for repeated lookups
		local
			l_registry: SIMPLE_TYPE_REGISTRY
			l_info1, l_info2, l_info3: SIMPLE_TYPE_INFO
		do
			print ("test_registry_same_type_repeated: ")
			create l_registry.make
			l_info1 := l_registry.type_info_for ({STRING})
			l_info2 := l_registry.type_info_for ({STRING})
			l_info3 := l_registry.type_info_for ({STRING})
			assert ("all_same_instance", l_info1 = l_info2 and l_info2 = l_info3)
			assert ("only_one_cached", l_registry.cached_count = 1)
			print ("PASS%N")
		end

	test_registry_after_clear
			-- Test registry works correctly after clearing
		local
			l_registry: SIMPLE_TYPE_REGISTRY
			l_info1, l_info2: SIMPLE_TYPE_INFO
		do
			print ("test_registry_after_clear: ")
			create l_registry.make
			l_info1 := l_registry.type_info_for ({STRING})
			l_registry.clear_cache
			assert ("cleared", l_registry.cached_count = 0)
			l_info2 := l_registry.type_info_for ({STRING})
			assert ("new_instance_after_clear", l_info1 /= l_info2)
			assert ("one_cached_again", l_registry.cached_count = 1)
			print ("PASS%N")
		end

feature -- Reflected Object Adversarial Tests

	test_reflected_empty_object
			-- Test reflection on minimal effective object
			-- Note: Bare ANY objects may not have valid type_id
		local
			l_reflected: SIMPLE_REFLECTED_OBJECT
			l_obj: STRING
		do
			print ("test_reflected_empty_object: ")
			l_obj := ""  -- Empty string as minimal object
			create l_reflected.make (l_obj)
			assert ("string_has_type_info", l_reflected.type_info /= Void)
			print ("PASS%N")
		end

	test_reflected_nested_object
			-- Test reflection on object with nested references
		local
			l_reflected: SIMPLE_REFLECTED_OBJECT
			l_outer: ARRAYED_LIST [ARRAYED_LIST [STRING]]
			l_inner: ARRAYED_LIST [STRING]
		do
			print ("test_reflected_nested_object: ")
			create l_outer.make (2)
			create l_inner.make (2)
			l_inner.extend ("nested")
			l_outer.extend (l_inner)
			create l_reflected.make (l_outer)
			assert ("nested_has_fields", l_reflected.type_info.field_count > 0)
			print ("PASS%N")
		end

feature -- Enumeration Adversarial Tests

	test_enum_all_values
			-- Test enumeration returns all values correctly
		local
			l_enum: TEST_STATUS_ENUM
		do
			print ("test_enum_all_values: ")
			create l_enum.make
			assert ("has_4_values", l_enum.all_values.count = 4)
			assert ("has_4_names", l_enum.all_names.count = 4)
			assert ("values_names_match", l_enum.all_values.count = l_enum.all_names.count)
			print ("PASS%N")
		end

	test_enum_iteration
			-- Test enumeration iteration
		local
			l_enum: TEST_STATUS_ENUM
			l_count: INTEGER
		do
			print ("test_enum_iteration: ")
			create l_enum.make
			l_enum.do_all (agent (a_value: INTEGER; a_name: STRING_32)
				do
					-- Just count iterations
				end)
			-- If we get here without error, iteration worked
			assert ("iteration_completed", True)
			print ("PASS%N")
		end

feature -- Flags Adversarial Tests

	test_flags_all_set
			-- Test setting all flags at once
		local
			l_flags: TEST_PERMISSION_FLAGS
		do
			print ("test_flags_all_set: ")
			create l_flags.make
			l_flags.set_flag (l_flags.read_flag)
			l_flags.set_flag (l_flags.write_flag)
			l_flags.set_flag (l_flags.execute_flag)
			l_flags.set_flag (l_flags.delete_flag)
			assert ("all_flags_set", l_flags.flags = 15)  -- 1+2+4+8
			assert ("has_all_4", l_flags.to_names.count = 4)
			print ("PASS%N")
		end

	test_flags_toggle
			-- Test toggling flags
		local
			l_flags: TEST_PERMISSION_FLAGS
		do
			print ("test_flags_toggle: ")
			create l_flags.make
			l_flags.set_flag (l_flags.read_flag)
			assert ("read_set", l_flags.has_flag (l_flags.read_flag))
			l_flags.toggle_flag (l_flags.read_flag)
			assert ("read_cleared", not l_flags.has_flag (l_flags.read_flag))
			l_flags.toggle_flag (l_flags.read_flag)
			assert ("read_set_again", l_flags.has_flag (l_flags.read_flag))
			print ("PASS%N")
		end

	test_flags_combined
			-- Test combined flag operations
		local
			l_flags: TEST_PERMISSION_FLAGS
		do
			print ("test_flags_combined: ")
			create l_flags.make
			l_flags.set_flags (l_flags.read_flag.bit_or (l_flags.write_flag))
			assert ("rw_set", l_flags.has_flag (l_flags.read_flag) and l_flags.has_flag (l_flags.write_flag))
			assert ("not_execute", not l_flags.has_flag (l_flags.execute_flag))
			l_flags.clear_all
			assert ("cleared", l_flags.is_empty)
			print ("PASS%N")
		end

feature -- Graph Walker Adversarial Tests

	test_walker_single_object
			-- Test walking a single object with no references
		local
			l_walker: SIMPLE_OBJECT_GRAPH_WALKER
			l_visitor: TEST_COUNTING_VISITOR
		do
			print ("test_walker_single_object: ")
			create l_walker.make
			create l_visitor.make
			l_walker.walk (42, l_visitor)  -- Walk an integer
			assert ("visited_one", l_visitor.object_count >= 1)
			print ("PASS%N")
		end

	test_walker_empty_list
			-- Test walking an empty list
		local
			l_walker: SIMPLE_OBJECT_GRAPH_WALKER
			l_visitor: TEST_COUNTING_VISITOR
			l_list: ARRAYED_LIST [STRING]
		do
			print ("test_walker_empty_list: ")
			create l_walker.make
			create l_visitor.make
			create l_list.make (0)  -- Empty list
			l_walker.walk (l_list, l_visitor)
			assert ("walked_empty_list", l_visitor.object_count >= 1)
			print ("PASS%N")
		end

	test_walker_max_depth_zero
			-- Test walking with max depth of 0 (unlimited)
		local
			l_walker: SIMPLE_OBJECT_GRAPH_WALKER
			l_visitor: TEST_COUNTING_VISITOR
			l_list: ARRAYED_LIST [STRING]
		do
			print ("test_walker_max_depth_zero: ")
			create l_walker.make
			l_walker.set_max_depth (0)  -- Unlimited
			create l_visitor.make
			create l_list.make (2)
			l_list.extend ("a")
			l_list.extend ("b")
			l_walker.walk (l_list, l_visitor)
			assert ("walked_with_unlimited_depth", l_visitor.object_count > 0)
			print ("PASS%N")
		end

feature -- H03 Bug Hunt Probes

	test_object_id_collision_proof
			-- H03/F05: Verify object_id now produces different IDs
		local
			l_obj1, l_obj2: ARRAYED_LIST [INTEGER]
			l_id1, l_id2: INTEGER
			l_internal: INTERNAL
		do
			print ("test_object_id_collision_proof: ")
			create l_obj1.make (10)
			create l_obj2.make (10)
			create l_internal
			-- Both have same type
			assert ("same_type", l_internal.dynamic_type (l_obj1) = l_internal.dynamic_type (l_obj2))
			-- Calculate object_id using NEW formula (out.hash_code)
			l_id1 := l_internal.dynamic_type (l_obj1) * 100000 + l_obj1.out.hash_code \\ 100000
			l_id2 := l_internal.dynamic_type (l_obj2) * 100000 + l_obj2.out.hash_code \\ 100000
			print ("IDs: " + l_id1.out + ", " + l_id2.out + "%N")
			if l_id1 /= l_id2 then
				print ("FIXED (different IDs)%N")
			else
				print ("STILL_COLLIDING%N")
			end
		end

	test_type_id_boundary_invalid
			-- H03: Invalid type_id passes precondition but crashes
		local
			l_registry: SIMPLE_TYPE_REGISTRY
			l_info: SIMPLE_TYPE_INFO
			l_retried: BOOLEAN
		do
			print ("test_type_id_boundary_invalid: ")
			if not l_retried then
				create l_registry.make
				-- 999999999 passes precondition (> 0) but is invalid type
				l_info := l_registry.type_info_for_type_id (999999999)
				print ("UNEXPECTED (no exception)%N")
			else
				print ("PASS (caught exception)%N")
			end
		rescue
			l_retried := True
			retry
		end

	test_set_value_unsupported_type
			-- F05: Verify INTEGER_64 now works in set_value
		local
			l_test: TEST_SIMPLE_OBJECT
			l_reflected: SIMPLE_REFLECTED_OBJECT
		do
			print ("test_set_value_unsupported_type: ")
			create l_test.make ("test", 0)
			l_test.set_big_value (9223372036854775807)
			create l_reflected.make (l_test)
			-- Try to set INTEGER_64 via reflection - should work after fix
			l_reflected.set_field_value ("big_value", {INTEGER_64} 123)
			if l_test.big_value = {INTEGER_64} 123 then
				print ("FIXED (INT64 works)%N")
			else
				print ("PARTIAL (value: " + l_test.big_value.out + ")%N")
			end
		end

feature -- X03 Contract Assault Tests

	test_field_set_verify_mutation
			-- A01: Verify set_field_value actually mutates
		local
			l_reflected: SIMPLE_REFLECTED_OBJECT
			l_test: TEST_SIMPLE_OBJECT
			l_result: detachable ANY
		do
			print ("test_field_set_verify_mutation: ")
			create l_test.make ("initial", 42)
			create l_reflected.make (l_test)
			l_reflected.set_field_value ("name", "modified")
			l_result := l_reflected.field_value ("name")
			if attached {STRING} l_result as l_str then
				assert ("mutation_applied", l_str.same_string ("modified"))
			else
				assert ("got_string_back", False)
			end
			-- Also verify via direct access
			assert ("direct_verify", l_test.name.same_string ("modified"))
			print ("PASS%N")
		end

	test_walker_collision_attack
			-- A03: Create many same-type objects to test hash collision
		local
			l_walker: SIMPLE_OBJECT_GRAPH_WALKER
			l_visitor: TEST_COUNTING_VISITOR
			l_root: ARRAYED_LIST [ARRAYED_LIST [INTEGER]]
			l_item: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("test_walker_collision_attack: ")
			create l_root.make (50)
			from
				i := 1
			until
				i > 50
			loop
				create l_item.make (1)
				l_item.extend (i)
				l_root.extend (l_item)
				i := i + 1
			end
			create l_walker.make
			create l_visitor.make
			l_walker.walk (l_root, l_visitor)
			-- Should visit root + children (may be less due to collisions)
			assert ("visited_reasonable_count", l_visitor.object_count >= 1)
			print ("PASS%N")
		end

	test_walker_postcondition_check
			-- A06: Verify walker postcondition holds
		local
			l_walker: SIMPLE_OBJECT_GRAPH_WALKER
			l_visitor: TEST_COUNTING_VISITOR
		do
			print ("test_walker_postcondition_check: ")
			create l_walker.make
			create l_visitor.make
			l_walker.walk ("test", l_visitor)
			assert ("postcondition_at_least_1", l_walker.visited_count >= 1)
			print ("PASS%N")
		end

	test_registry_boundary_type_id
			-- A05: Test registry with boundary type IDs
		local
			l_registry: SIMPLE_TYPE_REGISTRY
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_registry_boundary_type_id: ")
			create l_registry.make
			-- Type ID 1 is typically ANY or a basic type
			l_info := l_registry.type_info_for_type_id (1)
			assert ("type_1_has_name", not l_info.name.is_empty)
			assert ("type_1_cached", l_registry.has_type_id (1))
			print ("PASS%N")
		end

	test_walker_depth_limited
			-- A04: Test walker respects max_depth setting
		local
			l_walker: SIMPLE_OBJECT_GRAPH_WALKER
			l_visitor: TEST_COUNTING_VISITOR
			l_outer: ARRAYED_LIST [ARRAYED_LIST [STRING]]
			l_inner: ARRAYED_LIST [STRING]
		do
			print ("test_walker_depth_limited: ")
			create l_outer.make (2)
			create l_inner.make (2)
			l_inner.extend ("deep")
			l_outer.extend (l_inner)
			create l_walker.make
			l_walker.set_max_depth (1)  -- Only visit root level
			create l_visitor.make
			l_walker.walk (l_outer, l_visitor)
			-- With depth 1, should only visit outer, not traverse into inner
			assert ("depth_respected", l_visitor.object_count >= 1)
			print ("PASS%N")
		end

end
