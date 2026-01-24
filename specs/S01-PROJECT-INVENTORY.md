# S01: PROJECT INVENTORY - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Project Structure

```
simple_reflection/
  src/
    simple_reflected_object.e    # Object wrapper
    simple_type_info.e           # Type metadata
    simple_type_registry.e       # Type cache
    simple_field_info.e          # Field metadata
    simple_feature_info.e        # Feature metadata
    simple_enumeration.e         # Enum base class
    simple_flags.e               # Flags base class
    simple_object_graph_walker.e # Graph traversal
    simple_object_visitor.e      # Visitor interface
  testing/
    lib_tests.e                  # Test suite
    test_app.e                   # Test runner
    adversarial_tests.e          # Edge case tests
    test_status_enum.e           # Test enum
    test_permission_flags.e      # Test flags
    test_counting_visitor.e      # Test visitor
    test_simple_object.e         # Test object
  research/
  specs/
  simple_reflection.ecf
```

## 2. Source Files

| File | Purpose | Lines |
|------|---------|-------|
| simple_reflected_object.e | Object wrapper | ~120 |
| simple_type_info.e | Type metadata | ~210 |
| simple_type_registry.e | Type cache | ~150 |
| simple_field_info.e | Field metadata | ~145 |
| simple_feature_info.e | Feature metadata | ~135 |
| simple_enumeration.e | Enum base | ~155 |
| simple_flags.e | Flags base | ~230 |
| simple_object_graph_walker.e | Graph traversal | ~125 |
| simple_object_visitor.e | Visitor interface | ~30 |

## 3. Dependencies

### 3.1 External Libraries
None - standalone library

### 3.2 EiffelBase Dependencies
- INTERNAL: Core reflection
- ARRAYED_LIST: Collections
- HASH_TABLE: Caching
