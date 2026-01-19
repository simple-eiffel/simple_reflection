note
	description: "Visitor interface for object graph walking"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_OBJECT_VISITOR

feature -- Callbacks

	on_object (a_object: ANY; a_depth: INTEGER)
			-- Called when visiting `a_object` at `a_depth`.
		require
			object_exists: a_object /= Void
			non_negative_depth: a_depth >= 0
		deferred
		end

	on_reference (a_from: ANY; a_field_name: STRING_32; a_to: ANY)
			-- Called for reference from `a_from`.`a_field_name` to `a_to`.
		require
			from_exists: a_from /= Void
			to_exists: a_to /= Void
			name_not_empty: not a_field_name.is_empty
		deferred
		end

end
