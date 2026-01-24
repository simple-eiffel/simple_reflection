# S02: CLASS CATALOG - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Class Overview

| Class | Type | Purpose |
|-------|------|---------|
| SIMPLE_REFLECTED_OBJECT | Effective | Object wrapper |
| SIMPLE_TYPE_INFO | Effective | Type metadata |
| SIMPLE_TYPE_REGISTRY | Effective | Type cache |
| SIMPLE_FIELD_INFO | Effective | Field metadata |
| SIMPLE_FEATURE_INFO | Effective | Feature metadata |
| SIMPLE_ENUMERATION | Deferred | Enum base |
| SIMPLE_FLAGS | Deferred | Flags base |
| SIMPLE_OBJECT_GRAPH_WALKER | Effective | Graph traversal |
| SIMPLE_OBJECT_VISITOR | Deferred | Visitor interface |

## 2. Class Details

### 2.1 SIMPLE_REFLECTED_OBJECT
**Purpose**: Wraps any object for reflective access.
- Field value get/set
- Field iteration
- Type info access

### 2.2 SIMPLE_TYPE_INFO
**Purpose**: Cached metadata about a type.
- Type name and ID
- Field collection
- Feature collection
- Type conformance checking

### 2.3 SIMPLE_TYPE_REGISTRY
**Purpose**: Global cache of type info.
- Lookup by type, type ID, name
- Lazy creation of type info

### 2.4 SIMPLE_FIELD_INFO
**Purpose**: Metadata about a field.
- Name, type ID, index
- Value get/set
- Reference/expanded classification

### 2.5 SIMPLE_FEATURE_INFO
**Purpose**: Metadata about a feature.
- Name, arguments, result type
- Classification (procedure/function/attribute)
- Export status

### 2.6 SIMPLE_ENUMERATION (Deferred)
**Purpose**: Base for type-safe enumerations.
- Value and name mapping
- Iteration
- Validation

### 2.7 SIMPLE_FLAGS (Deferred)
**Purpose**: Base for bit flag enumerations.
- Flag set/clear/toggle
- Combination handling
- Name conversion

### 2.8 SIMPLE_OBJECT_GRAPH_WALKER
**Purpose**: Traverses object graphs.
- Visitor pattern
- Depth limiting
- Cycle detection

### 2.9 SIMPLE_OBJECT_VISITOR (Deferred)
**Purpose**: Callback interface for graph walking.
- on_object callback
- on_reference callback
