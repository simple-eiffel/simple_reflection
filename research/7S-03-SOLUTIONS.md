# 7S-03: SOLUTIONS - simple_reflection


**Date**: 2026-01-23

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Existing Solutions Evaluated

### 1.1 Raw INTERNAL Class
- **Pros**: Full access to Eiffel internals
- **Cons**: Complex API, no caching, type IDs exposed
- **Decision**: Wrap with simpler API

### 1.2 REFLECTED_OBJECT (EiffelBase)
- **Pros**: Built-in reflective wrapper
- **Cons**: Limited features
- **Decision**: Create SIMPLE_REFLECTED_OBJECT with additional features

## 2. Chosen Approach

### 2.1 Architecture
Multi-class design with clear responsibilities:
- SIMPLE_TYPE_REGISTRY: Caching and lookup
- SIMPLE_TYPE_INFO: Type metadata
- SIMPLE_FIELD_INFO: Field metadata and access
- SIMPLE_FEATURE_INFO: Feature metadata
- SIMPLE_REFLECTED_OBJECT: Object wrapper
- SIMPLE_ENUMERATION: Base for enums
- SIMPLE_FLAGS: Base for bit flags
- SIMPLE_OBJECT_GRAPH_WALKER: Graph traversal
- SIMPLE_OBJECT_VISITOR: Visitor interface

### 2.2 Key Design Decisions

1. **Caching**: Type info computed once, cached in registry
2. **Layered API**: From high-level (REFLECTED_OBJECT) to low-level (TYPE_INFO)
3. **Deferred enumerations**: SIMPLE_ENUMERATION and SIMPLE_FLAGS are deferred
4. **Visitor pattern**: Separates traversal from processing

### 2.3 Bug Fixes in Implementation
- BUG-001: Object ID collision fixed in SIMPLE_OBJECT_GRAPH_WALKER
- BUG-002: INTEGER_64 handler added to SIMPLE_FIELD_INFO.set_value
