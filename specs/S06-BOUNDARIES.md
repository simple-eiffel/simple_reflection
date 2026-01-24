# S06: BOUNDARIES - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. API Boundaries

### 1.1 Public Interface
All classes provide public reflection capabilities:
- Type introspection
- Field access
- Enumeration/flags operations
- Graph traversal

### 1.2 Internal Features
| Class | Feature | Visibility |
|-------|---------|------------|
| SIMPLE_TYPE_INFO | internal_type_id | {SIMPLE_TYPE_REGISTRY} |
| SIMPLE_TYPE_INFO | compute_metadata | {NONE} |
| SIMPLE_TYPE_REGISTRY | cache | {NONE} |
| SIMPLE_OBJECT_GRAPH_WALKER | visited | {NONE} |
| SIMPLE_OBJECT_GRAPH_WALKER | walk_object | {NONE} |
| SIMPLE_OBJECT_GRAPH_WALKER | object_id | {NONE} |

## 2. Input Boundaries

### 2.1 Object Inputs
| Parameter | Constraint |
|-----------|------------|
| a_object | Not Void |
| a_type | Not Void |
| a_name | Not empty |
| a_type_id | > 0 |
| a_index | > 0 |

### 2.2 Enumeration/Flags Inputs
| Parameter | Constraint |
|-----------|------------|
| a_value | Must be valid (is_valid_value) |
| a_flag | Must be valid (is_valid_flag) |
| a_name | Must be valid (is_valid_name/is_valid_flag_name) |

### 2.3 Walker Inputs
| Parameter | Constraint |
|-----------|------------|
| a_root | Not Void |
| a_visitor | Not Void |
| a_depth | >= 0 |

## 3. Output Boundaries

### 3.1 Type Queries
| Feature | Output |
|---------|--------|
| type_id | > 0 |
| name | Not empty |
| field_count | >= 0 |
| fields | Not Void |

### 3.2 Field Access
| Feature | Output |
|---------|--------|
| value | Detachable (may be Void) |
| field_by_name | Detachable (may not exist) |

## 4. Extension Points

### 4.1 Deferred Classes
- SIMPLE_ENUMERATION: Inherit for custom enums
- SIMPLE_FLAGS: Inherit for custom flags
- SIMPLE_OBJECT_VISITOR: Inherit for custom traversal
