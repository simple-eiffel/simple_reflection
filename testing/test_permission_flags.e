note
	description: "Example flags for testing"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_PERMISSION_FLAGS

inherit
	SIMPLE_FLAGS

create
	make

feature {NONE} -- Initialization

	make
			-- Create with no flags set
		do
			flags := 0
		ensure
			empty: is_empty
		end

feature -- Constants

	read_flag: INTEGER = 1
	write_flag: INTEGER = 2
	execute_flag: INTEGER = 4
	delete_flag: INTEGER = 8

feature -- All Flags

	all_flag_values: ARRAYED_LIST [INTEGER]
			-- All individual flag values
		do
			create Result.make_from_array (<<read_flag, write_flag, execute_flag, delete_flag>>)
		end

feature -- Conversion

	name_for_flag (a_flag: INTEGER): STRING_32
			-- Name corresponding to individual `a_flag`
		do
			inspect a_flag
			when read_flag then Result := {STRING_32} "read"
			when write_flag then Result := {STRING_32} "write"
			when execute_flag then Result := {STRING_32} "execute"
			when delete_flag then Result := {STRING_32} "delete"
			else
				Result := {STRING_32} "unknown"
			end
		end

	flag_for_name (a_name: READABLE_STRING_GENERAL): INTEGER
			-- Flag value corresponding to `a_name`
		do
			if a_name.same_string ("read") then
				Result := read_flag
			elseif a_name.same_string ("write") then
				Result := write_flag
			elseif a_name.same_string ("execute") then
				Result := execute_flag
			elseif a_name.same_string ("delete") then
				Result := delete_flag
			end
		end

end
