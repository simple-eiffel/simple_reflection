note
	description: "Metadata about a single field"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_FIELD_INFO

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING_32; a_type_id: INTEGER; a_index: INTEGER; a_owner_type_id: INTEGER)
			-- Create field info.
		require
			name_not_empty: not a_name.is_empty
			positive_index: a_index > 0
			valid_owner: a_owner_type_id > 0
		do
			name := a_name
			field_type_id := a_type_id
			index := a_index
			owner_type_id := a_owner_type_id
		ensure
			name_set: name = a_name
			type_set: field_type_id = a_type_id
			index_set: index = a_index
			owner_set: owner_type_id = a_owner_type_id
		end

feature -- Access

	name: STRING_32
			-- Field name

	field_type_id: INTEGER
			-- Type ID of field's declared type

	index: INTEGER
			-- Field index within object (1-based)

	owner_type_id: INTEGER
			-- Type ID of the type that declares this field

feature -- Type Classification

	is_reference: BOOLEAN
			-- Is this a reference field?
		do
			Result := not is_expanded
		ensure
			definition: Result = not is_expanded
		end

	is_expanded: BOOLEAN
			-- Is this an expanded field?

	is_attached: BOOLEAN
			-- Is this declared as attached?

	set_expanded (a_value: BOOLEAN)
			-- Set `is_expanded` flag.
		do
			is_expanded := a_value
		ensure
			expanded_set: is_expanded = a_value
		end

	set_attached (a_value: BOOLEAN)
			-- Set `is_attached` flag.
		do
			is_attached := a_value
		ensure
			attached_set: is_attached = a_value
		end

feature -- Value Access

	value (a_object: ANY): detachable ANY
			-- Value of this field in `a_object`.
		require
			object_exists: a_object /= Void
		local
			l_internal: INTERNAL
		do
			create l_internal
			Result := l_internal.field (index, a_object)
		end

	set_value (a_object: ANY; a_value: detachable ANY)
			-- Set this field in `a_object` to `a_value`.
		require
			object_exists: a_object /= Void
		local
			l_internal: INTERNAL
		do
			create l_internal
			if a_value = Void then
				l_internal.set_reference_field (index, a_object, Void)
			elseif attached {INTEGER_32} a_value as l_int then
				l_internal.set_integer_32_field (index, a_object, l_int)
			elseif attached {INTEGER_64} a_value as l_int64 then
				-- FIX for BUG-002: Added INTEGER_64 handler
				l_internal.set_integer_64_field (index, a_object, l_int64)
			elseif attached {INTEGER_16} a_value as l_int16 then
				l_internal.set_integer_16_field (index, a_object, l_int16)
			elseif attached {INTEGER_8} a_value as l_int8 then
				l_internal.set_integer_8_field (index, a_object, l_int8)
			elseif attached {NATURAL_32} a_value as l_nat32 then
				l_internal.set_natural_32_field (index, a_object, l_nat32)
			elseif attached {NATURAL_64} a_value as l_nat64 then
				l_internal.set_natural_64_field (index, a_object, l_nat64)
			elseif attached {BOOLEAN} a_value as l_bool then
				l_internal.set_boolean_field (index, a_object, l_bool)
			elseif attached {CHARACTER_8} a_value as l_char then
				l_internal.set_character_8_field (index, a_object, l_char)
			elseif attached {CHARACTER_32} a_value as l_char32 then
				l_internal.set_character_32_field (index, a_object, l_char32)
			elseif attached {REAL_32} a_value as l_real32 then
				l_internal.set_real_32_field (index, a_object, l_real32)
			elseif attached {REAL_64} a_value as l_real then
				l_internal.set_real_64_field (index, a_object, l_real)
			elseif attached {POINTER} a_value as l_ptr then
				l_internal.set_pointer_field (index, a_object, l_ptr)
			else
				l_internal.set_reference_field (index, a_object, a_value)
			end
		ensure
			value_set_or_type_mismatch: value (a_object) = a_value or else
				(attached {READABLE_STRING_GENERAL} a_value as l_str and then
				 attached {READABLE_STRING_GENERAL} value (a_object) as l_result and then
				 l_result.same_string (l_str))
		end

invariant
	name_not_empty: not name.is_empty
	positive_index: index > 0
	valid_owner: owner_type_id > 0

end
