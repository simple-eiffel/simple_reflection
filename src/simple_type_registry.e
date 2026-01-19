note
	description: "Global registry of type information (singleton)"
	author: "Simple Eiffel"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_TYPE_REGISTRY

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize registry.
		do
			create cache.make (100)
		ensure
			cache_empty: cache.is_empty
		end

feature -- Access

	type_info_for (a_type: TYPE [detachable ANY]): SIMPLE_TYPE_INFO
			-- Type info for `a_type`, creating if needed.
		require
			type_exists: a_type /= Void
		do
			if attached cache.item (a_type.type_id) as l_info then
				Result := l_info
			else
				create Result.make (a_type)
				cache.put (Result, a_type.type_id)
			end
		ensure
			cached: cache.has (a_type.type_id)
			result_exists: Result /= Void
		end

	type_info_for_type_id (a_type_id: INTEGER): SIMPLE_TYPE_INFO
			-- Type info for type with `a_type_id`, creating if needed.
		require
			valid_type_id: a_type_id > 0
		do
			if attached cache.item (a_type_id) as l_info then
				Result := l_info
			else
				create Result.make_from_type_id (a_type_id)
				cache.put (Result, a_type_id)
			end
		ensure
			cached: cache.has (a_type_id)
			result_exists: Result /= Void
		end

	type_info_for_object (a_object: ANY): SIMPLE_TYPE_INFO
			-- Type info for `a_object`'s dynamic type.
		require
			object_exists: a_object /= Void
		local
			l_internal: INTERNAL
		do
			create l_internal
			Result := type_info_for_type_id (l_internal.dynamic_type (a_object))
		ensure
			result_exists: Result /= Void
		end

	type_info_by_name (a_name: READABLE_STRING_GENERAL): detachable SIMPLE_TYPE_INFO
			-- Type info for type named `a_name`, or Void if not found in cache.
		require
			name_not_empty: not a_name.is_empty
		local
			l_cursor: INTEGER
			l_keys: ARRAY [INTEGER]
		do
			l_keys := cache.current_keys
			from
				l_cursor := l_keys.lower
			until
				l_cursor > l_keys.upper or Result /= Void
			loop
				if attached cache.item (l_keys [l_cursor]) as l_info then
					if l_info.name.same_string_general (a_name) then
						Result := l_info
					end
				end
				l_cursor := l_cursor + 1
			end
		ensure
			found_implies_name_matches: attached Result implies Result.name.same_string_general (a_name)
		end

feature -- Status Query

	has_type (a_type: TYPE [detachable ANY]): BOOLEAN
			-- Is `a_type` in cache?
		do
			Result := cache.has (a_type.type_id)
		ensure
			definition: Result = cache.has (a_type.type_id)
		end

	has_type_id (a_type_id: INTEGER): BOOLEAN
			-- Is type with `a_type_id` in cache?
		do
			Result := cache.has (a_type_id)
		ensure
			definition: Result = cache.has (a_type_id)
		end

	has_type_named (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Is a type named `a_name` in cache?
		do
			Result := type_info_by_name (a_name) /= Void
		ensure
			definition: Result = (type_info_by_name (a_name) /= Void)
		end

feature -- Measurement

	cached_count: INTEGER
			-- Number of cached type infos
		do
			Result := cache.count
		ensure
			definition: Result = cache.count
		end

feature -- Removal

	clear_cache
			-- Remove all cached type info.
		do
			cache.wipe_out
		ensure
			cache_empty: cache.is_empty
		end

feature {NONE} -- Implementation

	cache: HASH_TABLE [SIMPLE_TYPE_INFO, INTEGER]
			-- Type info cache keyed by type_id

invariant
	cache_exists: cache /= Void

end
