note
	description: "Example enumeration for testing"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_STATUS_ENUM

inherit
	SIMPLE_ENUMERATION

create
	make

feature {NONE} -- Initialization

	make
			-- Create with default value
		do
			value := pending
		ensure
			default_pending: value = pending
		end

feature -- Constants

	pending: INTEGER = 1
	active: INTEGER = 2
	completed: INTEGER = 3
	cancelled: INTEGER = 4

feature -- All Values

	all_values: ARRAYED_LIST [INTEGER]
			-- All valid enumeration values
		do
			create Result.make_from_array (<<pending, active, completed, cancelled>>)
		end

feature -- Conversion

	name_for_value (a_value: INTEGER): STRING_32
			-- Name corresponding to `a_value`
		do
			inspect a_value
			when pending then Result := {STRING_32} "pending"
			when active then Result := {STRING_32} "active"
			when completed then Result := {STRING_32} "completed"
			when cancelled then Result := {STRING_32} "cancelled"
			else
				Result := {STRING_32} "unknown"
			end
		end

	value_for_name (a_name: READABLE_STRING_GENERAL): INTEGER
			-- Value corresponding to `a_name`
		do
			if a_name.same_string ("pending") then
				Result := pending
			elseif a_name.same_string ("active") then
				Result := active
			elseif a_name.same_string ("completed") then
				Result := completed
			elseif a_name.same_string ("cancelled") then
				Result := cancelled
			end
		end

end
