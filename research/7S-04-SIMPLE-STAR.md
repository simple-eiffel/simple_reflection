# 7S-04: SIMPLE-STAR - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Ecosystem Integration

### 1.1 Dependencies
| Library | Purpose |
|---------|---------|
| (none) | Standalone library |

Uses only EiffelBase classes.

### 1.2 Dependents
Libraries that may use simple_reflection:
- simple_json (object serialization)
- simple_xml (object marshalling)
- Testing frameworks (object inspection)

## 2. Simple Ecosystem Patterns

### 2.1 Naming
- Classes: SIMPLE_* prefix for main classes
- Deferred classes: SIMPLE_ENUMERATION, SIMPLE_FLAGS
- Visitor: SIMPLE_OBJECT_VISITOR

### 2.2 Structure
```
simple_reflection/
  src/
    simple_reflected_object.e
    simple_type_info.e
    simple_type_registry.e
    simple_field_info.e
    simple_feature_info.e
    simple_enumeration.e
    simple_flags.e
    simple_object_graph_walker.e
    simple_object_visitor.e
  testing/
    lib_tests.e
    test_app.e
    adversarial_tests.e
    test_*.e (test helpers)
  simple_reflection.ecf
```

## 3. Reuse Opportunities

### 3.1 SIMPLE_ENUMERATION Pattern
Reusable for any typed enumeration need:
- Status codes
- State machines
- Configuration options

### 3.2 SIMPLE_FLAGS Pattern
Reusable for any bit flag need:
- Permission systems
- Feature toggles
- Option combinations
