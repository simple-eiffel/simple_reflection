# 7S-01: SCOPE - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Problem Domain

### 1.1 What Problem Does This Library Solve?
SIMPLE_REFLECTION provides a simplified, cached wrapper around Eiffel's INTERNAL reflection capabilities. It makes runtime type inspection and field manipulation more accessible with type-safe enumerations, bit flags, and object graph walking.

### 1.2 Who Needs This?
- Developers needing runtime type inspection
- Serialization/deserialization frameworks
- Object mapping utilities
- Debugging and diagnostic tools
- Dynamic configuration systems

### 1.3 What Exists Already?
- EiffelBase INTERNAL class (low-level, complex API)
- No built-in enumeration or flags support

## 2. Scope Definition

### 2.1 IN Scope
- Type metadata caching (SIMPLE_TYPE_INFO)
- Field information and access (SIMPLE_FIELD_INFO)
- Feature metadata (SIMPLE_FEATURE_INFO)
- Reflective object wrapper (SIMPLE_REFLECTED_OBJECT)
- Type registry (SIMPLE_TYPE_REGISTRY)
- Type-safe enumerations (SIMPLE_ENUMERATION)
- Bit flag enumerations (SIMPLE_FLAGS)
- Object graph walking (SIMPLE_OBJECT_GRAPH_WALKER, SIMPLE_OBJECT_VISITOR)

### 2.2 OUT of Scope
- Runtime code generation
- Proxy creation
- Aspect-oriented programming
- Method invocation via reflection

## 3. Success Criteria

- Simplified API compared to raw INTERNAL
- Proper caching of type metadata
- Type-safe field access
- Object graph traversal works correctly
- Enumeration/flags provide type safety
