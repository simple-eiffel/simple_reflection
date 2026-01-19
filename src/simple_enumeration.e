note
	description: "Type-safe enumeration base class"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_ENUMERATION

feature -- Access

	value: INTEGER
			-- Current enumeration value

	name: STRING_32
			-- Name of current value
		require
			is_valid: is_valid_value (value)
		do
			Result := name_for_value (value)
		ensure
			not_empty: not Result.is_empty
		end

feature -- All Values

	all_values: ARRAYED_LIST [INTEGER]
			-- All valid enumeration values in order
		deferred
		ensure
			not_empty: not Result.is_empty
			all_valid: across Result as ic all is_valid_value (ic) end
		end

	all_names: ARRAYED_LIST [STRING_32]
			-- All value names in order
		local
			i: INTEGER
		do
			create Result.make (all_values.count)
			from
				i := 1
			until
				i > all_values.count
			loop
				Result.extend (name_for_value (all_values [i]))
				i := i + 1
			end
		ensure
			same_count: Result.count = all_values.count
		end

feature -- Status Query

	is_valid_value (a_value: INTEGER): BOOLEAN
			-- Is `a_value` a valid enumeration value?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > all_values.count or Result
			loop
				if all_values [i] = a_value then
					Result := True
				end
				i := i + 1
			end
		end

	is_valid_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_name` a valid enumeration name?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > all_names.count or Result
			loop
				if all_names [i].same_string_general (a_name) then
					Result := True
				end
				i := i + 1
			end
		end

feature -- Conversion

	name_for_value (a_value: INTEGER): STRING_32
			-- Name corresponding to `a_value`
		require
			valid_value: is_valid_value (a_value)
		deferred
		ensure
			not_empty: not Result.is_empty
		end

	value_for_name (a_name: READABLE_STRING_GENERAL): INTEGER
			-- Value corresponding to `a_name`
		require
			valid_name: is_valid_name (a_name)
		deferred
		ensure
			round_trip: name_for_value (Result).same_string_general (a_name)
		end

feature -- Setting

	set_value (a_value: INTEGER)
			-- Set to `a_value`.
		require
			valid: is_valid_value (a_value)
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

	set_from_name (a_name: READABLE_STRING_GENERAL)
			-- Set from `a_name`.
		require
			valid_name: is_valid_name (a_name)
		do
			value := value_for_name (a_name)
		ensure
			name_matches: name.same_string_general (a_name)
		end

feature -- Iteration

	do_all (a_action: PROCEDURE [INTEGER, STRING_32])
			-- Apply `a_action` to each (value, name) pair.
		require
			action_exists: a_action /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > all_values.count
			loop
				a_action.call ([all_values [i], name_for_value (all_values [i])])
				i := i + 1
			end
		end

invariant
	value_is_valid: is_valid_value (value)

end
