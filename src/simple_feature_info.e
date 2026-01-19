note
	description: "Metadata about a feature (routine or attribute)"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_FEATURE_INFO

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING_32)
			-- Create feature info with `a_name`.
		require
			name_not_empty: not a_name.is_empty
		do
			name := a_name
			create arguments.make (0)
		ensure
			name_set: name = a_name
			arguments_empty: arguments.is_empty
		end

feature -- Access

	name: STRING_32
			-- Feature name

	result_type_id: INTEGER
			-- Return type ID (0 for procedures)

	argument_count: INTEGER
			-- Number of arguments
		do
			Result := arguments.count
		ensure
			definition: Result = arguments.count
		end

	arguments: ARRAYED_LIST [TUPLE [arg_name: STRING_32; arg_type_id: INTEGER]]
			-- Argument names and type IDs

feature -- Modification

	set_result_type_id (a_type_id: INTEGER)
			-- Set result type ID.
		do
			result_type_id := a_type_id
		ensure
			result_type_set: result_type_id = a_type_id
		end

	add_argument (a_name: STRING_32; a_type_id: INTEGER)
			-- Add an argument.
		require
			name_not_empty: not a_name.is_empty
		do
			arguments.extend ([a_name, a_type_id])
		ensure
			argument_added: arguments.count = old arguments.count + 1
		end

feature -- Classification

	is_procedure: BOOLEAN
			-- Is this a procedure (no return value)?
		do
			Result := result_type_id = 0
		ensure
			definition: Result = (result_type_id = 0)
		end

	is_function: BOOLEAN
			-- Is this a function?
		do
			Result := result_type_id /= 0
		ensure
			definition: Result = (result_type_id /= 0)
		end

	is_attribute: BOOLEAN
			-- Is this an attribute?

	is_once: BOOLEAN
			-- Is this a once feature?

	is_deferred: BOOLEAN
			-- Is this deferred?

	set_is_attribute (a_value: BOOLEAN)
			-- Set attribute flag.
		do
			is_attribute := a_value
		ensure
			attribute_set: is_attribute = a_value
		end

	set_is_once (a_value: BOOLEAN)
			-- Set once flag.
		do
			is_once := a_value
		ensure
			once_set: is_once = a_value
		end

	set_is_deferred (a_value: BOOLEAN)
			-- Set deferred flag.
		do
			is_deferred := a_value
		ensure
			deferred_set: is_deferred = a_value
		end

feature -- Export Status

	is_exported: BOOLEAN
			-- Is this exported to ANY?

	set_is_exported (a_value: BOOLEAN)
			-- Set export flag.
		do
			is_exported := a_value
		ensure
			exported_set: is_exported = a_value
		end

invariant
	name_not_empty: not name.is_empty
	arguments_exist: arguments /= Void

end
