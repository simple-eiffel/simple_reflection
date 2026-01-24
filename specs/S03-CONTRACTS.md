# S03: CONTRACTS - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. SIMPLE_REFLECTED_OBJECT Contracts

```eiffel
-- make
require
    object_exists: a_object /= Void
ensure
    target_set: target = a_object
    type_info_set: type_info /= Void

-- field_value
require
    has_field: type_info.has_field (a_name)
ensure
    consistent_with_field: attached type_info.field_by_name (a_name) as l_f implies
        Result = l_f.value (target)

invariant
    target_exists: target /= Void
    type_info_exists: type_info /= Void
```

## 2. SIMPLE_TYPE_INFO Contracts

```eiffel
-- make
require
    type_exists: a_type /= Void
ensure
    type_id_set: type_id = a_type.type_id

-- field_by_name
ensure
    found_implies_name_matches: attached Result implies
        Result.name.same_string_general (a_name)

-- has_field
ensure
    definition: Result = (field_by_name (a_name) /= Void)

invariant
    valid_type_id: internal_type_id > 0
    fields_exist: fields /= Void
    features_exist: features /= Void
```

## 3. SIMPLE_FIELD_INFO Contracts

```eiffel
-- make
require
    name_not_empty: not a_name.is_empty
    positive_index: a_index > 0
    valid_owner: a_owner_type_id > 0
ensure
    name_set: name = a_name
    index_set: index = a_index

-- value
require
    object_exists: a_object /= Void

-- set_value
require
    object_exists: a_object /= Void

invariant
    name_not_empty: not name.is_empty
    positive_index: index > 0
```

## 4. SIMPLE_ENUMERATION Contracts

```eiffel
-- name
require
    is_valid: is_valid_value (value)
ensure
    not_empty: not Result.is_empty

-- all_values
ensure
    not_empty: not Result.is_empty
    all_valid: across Result as ic all is_valid_value (ic) end

-- set_value
require
    valid: is_valid_value (a_value)
ensure
    value_set: value = a_value

invariant
    value_is_valid: is_valid_value (value)
```

## 5. SIMPLE_FLAGS Contracts

```eiffel
-- has_flag
require
    valid_flag: is_valid_flag (a_flag)
ensure
    definition: Result = ((flags.bit_and (a_flag)) /= 0)

-- set_flag
require
    valid_flag: is_valid_flag (a_flag)
ensure
    flag_set: has_flag (a_flag)

-- toggle_flag
ensure
    toggled: has_flag (a_flag) = not old has_flag (a_flag)

invariant
    flags_non_negative: flags >= 0
```

## 6. SIMPLE_OBJECT_GRAPH_WALKER Contracts

```eiffel
-- walk
require
    root_exists: a_root /= Void
    visitor_exists: a_visitor /= Void
ensure
    at_least_root_visited: visited_count >= 1

-- set_max_depth
require
    non_negative: a_depth >= 0
ensure
    depth_set: max_depth = a_depth

invariant
    visited_exists: visited /= Void
    max_depth_non_negative: max_depth >= 0
```

## 7. SIMPLE_OBJECT_VISITOR Contracts

```eiffel
-- on_object (deferred)
require
    object_exists: a_object /= Void
    non_negative_depth: a_depth >= 0

-- on_reference (deferred)
require
    from_exists: a_from /= Void
    to_exists: a_to /= Void
    name_not_empty: not a_field_name.is_empty
```
