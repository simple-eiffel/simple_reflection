# S04: FEATURE SPECS - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. SIMPLE_REFLECTED_OBJECT Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | `(a_object: ANY)` | Create wrapper |
| target | `: ANY` | Wrapped object |
| type_info | `: SIMPLE_TYPE_INFO` | Type metadata |
| field_value | `(a_name): detachable ANY` | Get field value |
| set_field_value | `(a_name, a_value)` | Set field value |
| field_names | `: ARRAYED_LIST [STRING_32]` | All field names |
| do_all_fields | `(a_action)` | Iterate fields |

## 2. SIMPLE_TYPE_INFO Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | `(a_type: TYPE)` | Create from type |
| make_from_type_id | `(a_type_id: INTEGER)` | Create from ID |
| type_id | `: INTEGER` | Type identifier |
| name | `: STRING_32` | Full type name |
| base_name | `: STRING_32` | Name without generics |
| field_count | `: INTEGER` | Number of fields |
| fields | `: ARRAYED_LIST [SIMPLE_FIELD_INFO]` | Field list |
| field_by_name | `(a_name): detachable SIMPLE_FIELD_INFO` | Lookup field |
| has_field | `(a_name): BOOLEAN` | Check field exists |
| features | `: ARRAYED_LIST [SIMPLE_FEATURE_INFO]` | Feature list |
| conforms_to_type | `(a_other_type_id): BOOLEAN` | Conformance |
| creation_procedures | `: ARRAYED_LIST [STRING_32]` | Creation procs |
| has_default_create | `: BOOLEAN` | Has default_create? |

## 3. SIMPLE_TYPE_REGISTRY Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | | Create registry |
| type_info_for | `(a_type): SIMPLE_TYPE_INFO` | Get/create by type |
| type_info_for_type_id | `(a_type_id): SIMPLE_TYPE_INFO` | Get/create by ID |
| type_info_for_object | `(a_object): SIMPLE_TYPE_INFO` | Get for object |
| type_info_by_name | `(a_name): detachable SIMPLE_TYPE_INFO` | Find by name |
| has_type | `(a_type): BOOLEAN` | Check cached |
| cached_count | `: INTEGER` | Cache size |
| clear_cache | | Clear all |

## 4. SIMPLE_FIELD_INFO Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | `(a_name, a_type_id, a_index, a_owner_type_id)` | Create |
| name | `: STRING_32` | Field name |
| field_type_id | `: INTEGER` | Type of field |
| index | `: INTEGER` | Field index |
| owner_type_id | `: INTEGER` | Declaring type |
| is_reference | `: BOOLEAN` | Reference field? |
| is_expanded | `: BOOLEAN` | Expanded field? |
| is_attached | `: BOOLEAN` | Attached? |
| value | `(a_object): detachable ANY` | Get value |
| set_value | `(a_object, a_value)` | Set value |

## 5. SIMPLE_ENUMERATION Features (Deferred)

| Feature | Signature | Description |
|---------|-----------|-------------|
| value | `: INTEGER` | Current value |
| name | `: STRING_32` | Current name |
| all_values | `: ARRAYED_LIST [INTEGER]` | All values |
| all_names | `: ARRAYED_LIST [STRING_32]` | All names |
| is_valid_value | `(a_value): BOOLEAN` | Validate |
| name_for_value | `(a_value): STRING_32` | Value to name |
| value_for_name | `(a_name): INTEGER` | Name to value |
| set_value | `(a_value)` | Set by value |
| set_from_name | `(a_name)` | Set by name |
| do_all | `(a_action)` | Iterate all |

## 6. SIMPLE_FLAGS Features (Deferred)

| Feature | Signature | Description |
|---------|-----------|-------------|
| flags | `: INTEGER` | Current flags |
| all_flag_values | `: ARRAYED_LIST [INTEGER]` | All flags |
| all_flag_names | `: ARRAYED_LIST [STRING_32]` | All names |
| has_flag | `(a_flag): BOOLEAN` | Check flag |
| is_valid_flag | `(a_flag): BOOLEAN` | Validate |
| is_empty | `: BOOLEAN` | No flags? |
| name_for_flag | `(a_flag): STRING_32` | Flag to name |
| flag_for_name | `(a_name): INTEGER` | Name to flag |
| to_names | `: ARRAYED_LIST [STRING_32]` | Set flag names |
| set_flag | `(a_flag)` | Set flag |
| clear_flag | `(a_flag)` | Clear flag |
| toggle_flag | `(a_flag)` | Toggle flag |
| set_flags | `(a_flags)` | Set all |
| clear_all | | Clear all |
| set_from_names | `(a_names)` | Set from names |
| do_set_flags | `(a_action)` | Iterate set |

## 7. SIMPLE_OBJECT_GRAPH_WALKER Features

| Feature | Signature | Description |
|---------|-----------|-------------|
| make | | Create walker |
| walk | `(a_root, a_visitor)` | Walk graph |
| max_depth | `: INTEGER` | Depth limit |
| set_max_depth | `(a_depth)` | Set limit |
| visited_count | `: INTEGER` | Nodes visited |
