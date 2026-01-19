note
	description: "Test suite for simple_reflection"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	LIB_TESTS

inherit
	EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests
		do
			default_create
			print ("=== simple_reflection Tests ===%N")
			run_all_tests
			print ("=== End Tests ===%N")
		end

feature -- Tests

	run_all_tests
			-- Run all test groups
		do
			-- Type Info Tests
			test_type_info_basic
			test_type_info_fields
			test_type_info_name
			test_type_info_base_name
			test_type_info_conformance

			-- Type Registry Tests
			test_registry_caching
			test_registry_lookup
			test_registry_clear

			-- Reflected Object Tests
			test_reflected_object_basic
			test_reflected_field_access
			test_reflected_field_names

			-- Enumeration Tests
			test_enum_basic
			test_enum_names
			test_enum_validation
			test_enum_set_from_name

			-- Flags Tests
			test_flags_basic
			test_flags_set_clear
			test_flags_to_names

			-- Object Graph Tests
			test_graph_walker_basic
			test_graph_walker_depth

			-- Adversarial Tests
			run_adversarial_tests

			-- Summary
			print ("Results: Tests completed%N")
		end

	run_adversarial_tests
			-- Run hardening tests
		local
			l_adv: ADVERSARIAL_TESTS
		do
			create l_adv.make
		end

feature -- Type Info Tests

	test_type_info_basic
			-- Test basic type info creation
		local
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_type_info_basic: ")
			create l_info.make ({STRING_8})
			assert ("type_id_positive", l_info.type_id > 0)
			assert ("name_not_empty", not l_info.name.is_empty)
			print ("PASS%N")
		end

	test_type_info_fields
			-- Test field introspection
		local
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_type_info_fields: ")
			create l_info.make ({ARRAYED_LIST [STRING]})
			assert ("fields_exist", l_info.fields /= Void)
			assert ("field_count_valid", l_info.field_count >= 0)
			print ("PASS%N")
		end

	test_type_info_name
			-- Test type name extraction
		local
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_type_info_name: ")
			create l_info.make ({INTEGER_32})
			assert ("name_contains_integer", l_info.name.has_substring ("INTEGER"))
			print ("PASS%N")
		end

feature -- Registry Tests

	test_registry_caching
			-- Test that registry caches type info
		local
			l_registry: SIMPLE_TYPE_REGISTRY
			l_info1: SIMPLE_TYPE_INFO
			l_info2: SIMPLE_TYPE_INFO
		do
			print ("test_registry_caching: ")
			create l_registry.make
			l_info1 := l_registry.type_info_for ({STRING_32})
			l_info2 := l_registry.type_info_for ({STRING_32})
			assert ("same_instance", l_info1 = l_info2)
			assert ("cached", l_registry.has_type ({STRING_32}))
			print ("PASS%N")
		end

	test_registry_lookup
			-- Test registry lookup by type ID
		local
			l_registry: SIMPLE_TYPE_REGISTRY
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_registry_lookup: ")
			create l_registry.make
			l_info := l_registry.type_info_for ({BOOLEAN})
			assert ("can_lookup_by_id", l_registry.has_type_id (l_info.type_id))
			print ("PASS%N")
		end

feature -- Reflected Object Tests

	test_reflected_object_basic
			-- Test basic reflected object creation
		local
			l_reflected: SIMPLE_REFLECTED_OBJECT
			l_string: STRING_32
		do
			print ("test_reflected_object_basic: ")
			l_string := "test"
			create l_reflected.make (l_string)
			assert ("target_set", l_reflected.target = l_string)
			assert ("type_info_exists", l_reflected.type_info /= Void)
			print ("PASS%N")
		end

	test_reflected_field_access
			-- Test field access through reflection
		local
			l_reflected: SIMPLE_REFLECTED_OBJECT
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_reflected_field_access: ")
			create l_list.make (5)
			l_list.extend (42)
			create l_reflected.make (l_list)
			assert ("has_fields", l_reflected.type_info.field_count > 0)
			assert ("field_names_not_empty", not l_reflected.field_names.is_empty)
			print ("PASS%N")
		end

	test_type_info_base_name
			-- Test base name extraction (without generics)
		local
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_type_info_base_name: ")
			create l_info.make ({ARRAYED_LIST [STRING]})
			assert ("base_name_no_brackets", not l_info.base_name.has ('['))
			assert ("base_name_has_list", l_info.base_name.has_substring ("ARRAYED_LIST"))
			print ("PASS%N")
		end

	test_type_info_conformance
			-- Test type conformance checking
		local
			l_info: SIMPLE_TYPE_INFO
			l_any_info: SIMPLE_TYPE_INFO
		do
			print ("test_type_info_conformance: ")
			create l_info.make ({STRING_32})
			create l_any_info.make ({ANY})
			assert ("string_conforms_to_any", l_info.conforms_to_type (l_any_info.type_id))
			print ("PASS%N")
		end

	test_registry_clear
			-- Test registry cache clearing
		local
			l_registry: SIMPLE_TYPE_REGISTRY
			l_info: SIMPLE_TYPE_INFO
		do
			print ("test_registry_clear: ")
			create l_registry.make
			l_info := l_registry.type_info_for ({STRING})
			assert ("has_cached", l_registry.cached_count > 0)
			l_registry.clear_cache
			assert ("cache_cleared", l_registry.cached_count = 0)
			print ("PASS%N")
		end

	test_reflected_field_names
			-- Test getting field names via reflection
		local
			l_reflected: SIMPLE_REFLECTED_OBJECT
			l_list: ARRAYED_LIST [STRING]
		do
			print ("test_reflected_field_names: ")
			create l_list.make (5)
			create l_reflected.make (l_list)
			assert ("field_names_exist", l_reflected.field_names /= Void)
			assert ("field_count_matches", l_reflected.field_names.count = l_reflected.type_info.field_count)
			print ("PASS%N")
		end

feature -- Enumeration Tests

	test_enum_basic
			-- Test basic enumeration functionality
		local
			l_status: TEST_STATUS_ENUM
		do
			print ("test_enum_basic: ")
			create l_status.make
			assert ("default_is_pending", l_status.value = l_status.pending)
			l_status.set_value (l_status.active)
			assert ("value_changed", l_status.value = l_status.active)
			print ("PASS%N")
		end

	test_enum_names
			-- Test enumeration name conversion
		local
			l_status: TEST_STATUS_ENUM
		do
			print ("test_enum_names: ")
			create l_status.make
			l_status.set_value (l_status.completed)
			assert ("name_is_completed", l_status.name.same_string ("completed"))
			assert ("name_for_value_works", l_status.name_for_value (l_status.active).same_string ("active"))
			print ("PASS%N")
		end

	test_enum_validation
			-- Test enumeration value validation
		local
			l_status: TEST_STATUS_ENUM
		do
			print ("test_enum_validation: ")
			create l_status.make
			assert ("valid_value_true", l_status.is_valid_value (l_status.active))
			assert ("invalid_value_false", not l_status.is_valid_value (999))
			assert ("valid_name_true", l_status.is_valid_name ("pending"))
			assert ("invalid_name_false", not l_status.is_valid_name ("nonexistent"))
			print ("PASS%N")
		end

	test_enum_set_from_name
			-- Test setting enumeration from name
		local
			l_status: TEST_STATUS_ENUM
		do
			print ("test_enum_set_from_name: ")
			create l_status.make
			l_status.set_from_name ("cancelled")
			assert ("value_is_cancelled", l_status.value = l_status.cancelled)
			assert ("name_is_cancelled", l_status.name.same_string ("cancelled"))
			print ("PASS%N")
		end

feature -- Flags Tests

	test_flags_basic
			-- Test basic flags functionality
		local
			l_flags: TEST_PERMISSION_FLAGS
		do
			print ("test_flags_basic: ")
			create l_flags.make
			assert ("initially_empty", l_flags.is_empty)
			l_flags.set_flag (l_flags.read_flag)
			assert ("has_read_flag", l_flags.has_flag (l_flags.read_flag))
			assert ("not_empty", not l_flags.is_empty)
			print ("PASS%N")
		end

	test_flags_set_clear
			-- Test setting and clearing flags
		local
			l_flags: TEST_PERMISSION_FLAGS
		do
			print ("test_flags_set_clear: ")
			create l_flags.make
			l_flags.set_flag (l_flags.read_flag)
			l_flags.set_flag (l_flags.write_flag)
			assert ("has_both", l_flags.has_flag (l_flags.read_flag) and l_flags.has_flag (l_flags.write_flag))
			l_flags.clear_flag (l_flags.read_flag)
			assert ("read_cleared", not l_flags.has_flag (l_flags.read_flag))
			assert ("write_still_set", l_flags.has_flag (l_flags.write_flag))
			print ("PASS%N")
		end

	test_flags_to_names
			-- Test flag to name conversion
		local
			l_flags: TEST_PERMISSION_FLAGS
			l_names: ARRAYED_LIST [STRING_32]
		do
			print ("test_flags_to_names: ")
			create l_flags.make
			l_flags.set_flag (l_flags.read_flag)
			l_flags.set_flag (l_flags.execute_flag)
			l_names := l_flags.to_names
			assert ("two_names", l_names.count = 2)
			print ("PASS%N")
		end

feature -- Object Graph Tests

	test_graph_walker_basic
			-- Test basic object graph walking
		local
			l_walker: SIMPLE_OBJECT_GRAPH_WALKER
			l_visitor: TEST_COUNTING_VISITOR
			l_list: ARRAYED_LIST [STRING]
		do
			print ("test_graph_walker_basic: ")
			create l_walker.make
			create l_visitor.make
			create l_list.make (2)
			l_list.extend ("hello")
			l_list.extend ("world")
			l_walker.walk (l_list, l_visitor)
			assert ("visited_objects", l_visitor.object_count > 0)
			print ("PASS%N")
		end

	test_graph_walker_depth
			-- Test object graph walking with depth limit
		local
			l_walker: SIMPLE_OBJECT_GRAPH_WALKER
			l_visitor: TEST_COUNTING_VISITOR
			l_list: ARRAYED_LIST [STRING]
		do
			print ("test_graph_walker_depth: ")
			create l_walker.make
			l_walker.set_max_depth (1)
			create l_visitor.make
			create l_list.make (2)
			l_list.extend ("test")
			l_walker.walk (l_list, l_visitor)
			assert ("depth_limited", l_walker.max_depth = 1)
			assert ("visited_some", l_visitor.object_count >= 1)
			print ("PASS%N")
		end

end
