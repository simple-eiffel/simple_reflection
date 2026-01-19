note
	description: "Cached metadata about a type"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_TYPE_INFO

create
	make,
	make_from_type_id

feature {NONE} -- Initialization

	make (a_type: TYPE [detachable ANY])
			-- Initialize from type object.
		require
			type_exists: a_type /= Void
		do
			internal_type_id := a_type.type_id
			compute_metadata
		ensure
			type_id_set: type_id = a_type.type_id
		end

	make_from_type_id (a_type_id: INTEGER)
			-- Initialize from type ID.
		require
			valid_type_id: a_type_id > 0
		do
			internal_type_id := a_type_id
			compute_metadata
		ensure
			type_id_set: type_id = a_type_id
		end

feature -- Access

	type_id: INTEGER
			-- Runtime type identifier
		do
			Result := internal_type_id
		ensure
			definition: Result = internal_type_id
		end

	name: STRING_32
			-- Fully qualified type name
		local
			l_internal: INTERNAL
		do
			create l_internal
			Result := l_internal.type_name_of_type (internal_type_id).to_string_32
		ensure
			not_empty: not Result.is_empty
		end

	base_name: STRING_32
			-- Type name without generics
		local
			l_bracket: INTEGER
		do
			Result := name.twin
			l_bracket := Result.index_of ('[', 1)
			if l_bracket > 0 then
				Result.keep_head (l_bracket - 1)
			end
		ensure
			no_brackets: not Result.has ('[')
		end

feature -- Fields

	field_count: INTEGER
			-- Number of fields in this type
		do
			Result := fields.count
		ensure
			definition: Result = fields.count
		end

	fields: ARRAYED_LIST [SIMPLE_FIELD_INFO]
			-- All fields of this type

	field_by_name (a_name: READABLE_STRING_GENERAL): detachable SIMPLE_FIELD_INFO
			-- Field with `a_name`, or Void if not found.
		local
			l_cursor: INTEGER
		do
			from
				l_cursor := 1
			until
				l_cursor > fields.count or Result /= Void
			loop
				if fields [l_cursor].name.same_string_general (a_name) then
					Result := fields [l_cursor]
				end
				l_cursor := l_cursor + 1
			end
		ensure
			found_implies_name_matches: attached Result implies Result.name.same_string_general (a_name)
		end

	has_field (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Does type have field named `a_name`?
		do
			Result := field_by_name (a_name) /= Void
		ensure
			definition: Result = (field_by_name (a_name) /= Void)
		end

feature -- Features

	feature_count: INTEGER
			-- Number of exported features
		do
			Result := features.count
		ensure
			definition: Result = features.count
		end

	features: ARRAYED_LIST [SIMPLE_FEATURE_INFO]
			-- Exported features of this type

feature -- Type Relationships

	conforms_to_type (a_other_type_id: INTEGER): BOOLEAN
			-- Does this type conform to type with `a_other_type_id`?
		local
			l_internal: INTERNAL
		do
			create l_internal
			Result := l_internal.type_conforms_to (internal_type_id, a_other_type_id)
		end

feature -- Creation

	creation_procedures: ARRAYED_LIST [STRING_32]
			-- Names of creation procedures

	has_default_create: BOOLEAN
			-- Does type have `default_create` as creation procedure?
		local
			l_cursor: INTEGER
		do
			from
				l_cursor := 1
			until
				l_cursor > creation_procedures.count or Result
			loop
				if creation_procedures [l_cursor].same_string ("default_create") then
					Result := True
				end
				l_cursor := l_cursor + 1
			end
		end

feature {SIMPLE_TYPE_REGISTRY} -- Implementation Access

	internal_type_id: INTEGER
			-- The underlying type ID

feature {NONE} -- Implementation

	compute_metadata
			-- Compute and cache all metadata.
		local
			l_internal: INTERNAL
			l_count: INTEGER
			l_field: SIMPLE_FIELD_INFO
			i: INTEGER
		do
			create l_internal
			create fields.make (10)
			create features.make (10)
			create creation_procedures.make (2)

			-- Get field info
			l_count := l_internal.field_count_of_type (internal_type_id)
			from
				i := 1
			until
				i > l_count
			loop
				create l_field.make (
					l_internal.field_name_of_type (i, internal_type_id).to_string_32,
					l_internal.field_static_type_of_type (i, internal_type_id),
					i,
					internal_type_id
				)
				l_field.set_expanded (l_internal.field_type_of_type (i, internal_type_id) = l_internal.expanded_type)
				fields.extend (l_field)
				i := i + 1
			end

			-- Note: creation procedure detection deferred to Phase 2
		ensure
			fields_exist: fields /= Void
			features_exist: features /= Void
			creation_exist: creation_procedures /= Void
		end

invariant
	valid_type_id: internal_type_id > 0
	fields_exist: fields /= Void
	features_exist: features /= Void
	creation_exist: creation_procedures /= Void

end
