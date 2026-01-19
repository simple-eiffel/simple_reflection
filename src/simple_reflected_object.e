note
	description: "Wrapper providing reflective access to an object"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_REFLECTED_OBJECT

create
	make

feature {NONE} -- Initialization

	make (a_object: ANY)
			-- Create reflective wrapper for `a_object`.
		require
			object_exists: a_object /= Void
		do
			target := a_object
			type_info := type_registry.type_info_for_object (a_object)
		ensure
			target_set: target = a_object
			type_info_set: type_info /= Void
		end

feature -- Access

	target: ANY
			-- The wrapped object

	type_info: SIMPLE_TYPE_INFO
			-- Type information for target

feature -- Field Access

	field_value (a_name: READABLE_STRING_GENERAL): detachable ANY
			-- Value of field `a_name`.
		require
			has_field: type_info.has_field (a_name)
		do
			if attached type_info.field_by_name (a_name) as l_field then
				Result := l_field.value (target)
			end
		end

	set_field_value (a_name: READABLE_STRING_GENERAL; a_value: detachable ANY)
			-- Set field `a_name` to `a_value`.
		require
			has_field: type_info.has_field (a_name)
		do
			if attached type_info.field_by_name (a_name) as l_field then
				l_field.set_value (target, a_value)
			end
		end

feature -- Iteration

	field_names: ARRAYED_LIST [STRING_32]
			-- Names of all fields.
		local
			i: INTEGER
		do
			create Result.make (type_info.field_count)
			from
				i := 1
			until
				i > type_info.fields.count
			loop
				Result.extend (type_info.fields [i].name)
				i := i + 1
			end
		ensure
			correct_count: Result.count = type_info.field_count
		end

	do_all_fields (a_action: PROCEDURE [SIMPLE_FIELD_INFO, detachable ANY])
			-- Apply `a_action` to each (field_info, value) pair.
		require
			action_exists: a_action /= Void
		local
			i: INTEGER
			l_field: SIMPLE_FIELD_INFO
		do
			from
				i := 1
			until
				i > type_info.fields.count
			loop
				l_field := type_info.fields [i]
				a_action.call ([l_field, l_field.value (target)])
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	type_registry: SIMPLE_TYPE_REGISTRY
			-- Shared type registry
		once
			create Result.make
		ensure
			result_exists: Result /= Void
		end

invariant
	target_exists: target /= Void
	type_info_exists: type_info /= Void

end
