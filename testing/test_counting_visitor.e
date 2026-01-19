note
	description: "Test visitor that counts objects"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_COUNTING_VISITOR

inherit
	SIMPLE_OBJECT_VISITOR

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize counter
		do
			object_count := 0
			reference_count := 0
		ensure
			counts_zero: object_count = 0 and reference_count = 0
		end

feature -- Access

	object_count: INTEGER
			-- Number of objects visited

	reference_count: INTEGER
			-- Number of references visited

feature -- Callbacks

	on_object (a_object: ANY; a_depth: INTEGER)
			-- Called when visiting `a_object`
		do
			object_count := object_count + 1
		end

	on_reference (a_from: ANY; a_field_name: STRING_32; a_to: ANY)
			-- Called for reference from `a_from` to `a_to`
		do
			reference_count := reference_count + 1
		end

feature -- Reset

	reset
			-- Reset counters
		do
			object_count := 0
			reference_count := 0
		ensure
			counts_zero: object_count = 0 and reference_count = 0
		end

invariant
	object_count_non_negative: object_count >= 0
	reference_count_non_negative: reference_count >= 0

end
