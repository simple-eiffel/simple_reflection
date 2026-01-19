note
	description: "Simple test object for reflection testing"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_SIMPLE_OBJECT

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_value: INTEGER)
			-- Create with initial values.
		require
			name_not_void: a_name /= Void
		do
			name := a_name.twin
			value := a_value
		ensure
			name_set: name.same_string (a_name)
			value_set: value = a_value
		end

feature -- Access

	name: STRING
			-- Name field

	value: INTEGER
			-- Value field

	big_value: INTEGER_64
			-- Large integer field for type testing

feature -- Setting

	set_name (a_name: STRING)
			-- Set `name`.
		require
			name_not_void: a_name /= Void
		do
			name := a_name.twin
		ensure
			name_set: name.same_string (a_name)
		end

	set_value (a_value: INTEGER)
			-- Set `value`.
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

	set_big_value (a_value: INTEGER_64)
			-- Set `big_value`.
		do
			big_value := a_value
		ensure
			value_set: big_value = a_value
		end

invariant
	name_not_void: name /= Void

end
