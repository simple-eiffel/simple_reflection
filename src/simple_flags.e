note
	description: "Bit flag enumeration base class"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_FLAGS

feature -- Access

	flags: INTEGER
			-- Current flags value (bit field)

feature -- All Flags

	all_flag_values: ARRAYED_LIST [INTEGER]
			-- All individual flag values (each should be a power of 2)
		deferred
		ensure
			not_empty: not Result.is_empty
			all_powers_of_two: across Result as ic all is_power_of_two (ic) end
		end

	all_flag_names: ARRAYED_LIST [STRING_32]
			-- All flag names in order
		local
			i: INTEGER
		do
			create Result.make (all_flag_values.count)
			from
				i := 1
			until
				i > all_flag_values.count
			loop
				Result.extend (name_for_flag (all_flag_values [i]))
				i := i + 1
			end
		ensure
			same_count: Result.count = all_flag_values.count
		end

feature -- Status Query

	has_flag (a_flag: INTEGER): BOOLEAN
			-- Is `a_flag` set?
		require
			valid_flag: is_valid_flag (a_flag)
		do
			Result := (flags.bit_and (a_flag)) /= 0
		ensure
			definition: Result = ((flags.bit_and (a_flag)) /= 0)
		end

	is_valid_flag (a_flag: INTEGER): BOOLEAN
			-- Is `a_flag` a valid individual flag?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > all_flag_values.count or Result
			loop
				if all_flag_values [i] = a_flag then
					Result := True
				end
				i := i + 1
			end
		end

	is_power_of_two (a_value: INTEGER): BOOLEAN
			-- Is `a_value` a power of two?
		do
			Result := a_value > 0 and then (a_value.bit_and (a_value - 1)) = 0
		end

	is_empty: BOOLEAN
			-- Are no flags set?
		do
			Result := flags = 0
		ensure
			definition: Result = (flags = 0)
		end

feature -- Conversion

	name_for_flag (a_flag: INTEGER): STRING_32
			-- Name corresponding to individual `a_flag`
		require
			valid_flag: is_valid_flag (a_flag)
		deferred
		ensure
			not_empty: not Result.is_empty
		end

	flag_for_name (a_name: READABLE_STRING_GENERAL): INTEGER
			-- Flag value corresponding to `a_name`
		require
			valid_name: is_valid_flag_name (a_name)
		deferred
		ensure
			round_trip: name_for_flag (Result).same_string_general (a_name)
		end

	is_valid_flag_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_name` a valid flag name?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > all_flag_names.count or Result
			loop
				if all_flag_names [i].same_string_general (a_name) then
					Result := True
				end
				i := i + 1
			end
		end

	to_names: ARRAYED_LIST [STRING_32]
			-- Names of all set flags
		local
			i: INTEGER
		do
			create Result.make (all_flag_values.count)
			from
				i := 1
			until
				i > all_flag_values.count
			loop
				if has_flag (all_flag_values [i]) then
					Result.extend (name_for_flag (all_flag_values [i]))
				end
				i := i + 1
			end
		end

feature -- Setting

	set_flag (a_flag: INTEGER)
			-- Set `a_flag`.
		require
			valid_flag: is_valid_flag (a_flag)
		do
			flags := flags.bit_or (a_flag)
		ensure
			flag_set: has_flag (a_flag)
		end

	clear_flag (a_flag: INTEGER)
			-- Clear `a_flag`.
		require
			valid_flag: is_valid_flag (a_flag)
		do
			flags := flags.bit_and (a_flag.bit_not)
		ensure
			flag_cleared: not has_flag (a_flag)
		end

	toggle_flag (a_flag: INTEGER)
			-- Toggle `a_flag`.
		require
			valid_flag: is_valid_flag (a_flag)
		do
			flags := flags.bit_xor (a_flag)
		ensure
			toggled: has_flag (a_flag) = not old has_flag (a_flag)
		end

	set_flags (a_flags: INTEGER)
			-- Set all flags to `a_flags`.
		do
			flags := a_flags
		ensure
			flags_set: flags = a_flags
		end

	clear_all
			-- Clear all flags.
		do
			flags := 0
		ensure
			empty: is_empty
		end

	set_from_names (a_names: ITERABLE [READABLE_STRING_GENERAL])
			-- Set flags from collection of names.
		require
			all_valid: across a_names as ic all is_valid_flag_name (ic) end
		do
			clear_all
			across a_names as ic loop
				set_flag (flag_for_name (ic))
			end
		end

feature -- Iteration

	do_set_flags (a_action: PROCEDURE [INTEGER, STRING_32])
			-- Apply `a_action` to each set (flag, name) pair.
		require
			action_exists: a_action /= Void
		local
			i: INTEGER
			l_flag: INTEGER
		do
			from
				i := 1
			until
				i > all_flag_values.count
			loop
				l_flag := all_flag_values [i]
				if has_flag (l_flag) then
					a_action.call ([l_flag, name_for_flag (l_flag)])
				end
				i := i + 1
			end
		end

invariant
	flags_non_negative: flags >= 0

end
