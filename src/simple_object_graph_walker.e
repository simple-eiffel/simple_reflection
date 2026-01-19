note
	description: "Walk object graph via reflection"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_OBJECT_GRAPH_WALKER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize walker.
		do
			create visited.make (100)
		ensure
			visited_empty: visited.is_empty
			max_depth_zero: max_depth = 0
		end

feature -- Walking

	walk (a_root: ANY; a_visitor: SIMPLE_OBJECT_VISITOR)
			-- Walk object graph starting at `a_root`.
		require
			root_exists: a_root /= Void
			visitor_exists: a_visitor /= Void
		do
			visited.wipe_out
			walk_object (a_root, a_visitor, 0)
		ensure
			at_least_root_visited: visited_count >= 1
		end

feature -- Configuration

	max_depth: INTEGER
			-- Maximum traversal depth (0 = unlimited)

	set_max_depth (a_depth: INTEGER)
			-- Set maximum depth.
		require
			non_negative: a_depth >= 0
		do
			max_depth := a_depth
		ensure
			depth_set: max_depth = a_depth
		end

feature -- Statistics

	visited_count: INTEGER
			-- Number of objects visited in last walk
		do
			Result := visited.count
		ensure
			definition: Result = visited.count
		end

feature {NONE} -- Implementation

	visited: HASH_TABLE [BOOLEAN, INTEGER]
			-- Object IDs already visited

	walk_object (a_object: ANY; a_visitor: SIMPLE_OBJECT_VISITOR; a_depth: INTEGER)
			-- Walk single object and its references.
		local
			l_reflected: SIMPLE_REFLECTED_OBJECT
			l_id: INTEGER
			i: INTEGER
			l_field: SIMPLE_FIELD_INFO
		do
			l_id := object_id (a_object)
			if not visited.has (l_id) then
				visited.put (True, l_id)
				a_visitor.on_object (a_object, a_depth)

				if max_depth = 0 or else a_depth < max_depth then
					create l_reflected.make (a_object)
					from
						i := 1
					until
						i > l_reflected.type_info.fields.count
					loop
						l_field := l_reflected.type_info.fields [i]
						if l_field.is_reference then
							if attached l_field.value (a_object) as l_ref then
								a_visitor.on_reference (a_object, l_field.name, l_ref)
								walk_object (l_ref, a_visitor, a_depth + 1)
							end
						end
						i := i + 1
					end
				end
			end
		end

	object_id (a_object: ANY): INTEGER
			-- Unique ID for `a_object`.
			-- FIX for BUG-001: Previous algorithm used class name hash (generator)
			-- which was identical for all objects of same type.
			-- Now uses `out` string hash which varies per instance state.
			-- NOTE: This is still not true object identity - objects with
			-- identical state may still collide. For true identity, use
			-- IDENTIFIED inheritance pattern in Phase 2.
		local
			l_internal: INTERNAL
		do
			create l_internal
			-- out.hash_code varies per object instance/state
			Result := l_internal.dynamic_type (a_object) * 100000 + (a_object.out.hash_code \\ 100000)
		end

invariant
	visited_exists: visited /= Void
	max_depth_non_negative: max_depth >= 0

end
