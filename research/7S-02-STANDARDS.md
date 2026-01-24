# 7S-02: STANDARDS - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Applicable Standards

### 1.1 Eiffel Reflection System
- Based on INTERNAL class from EiffelBase
- Type IDs are runtime-specific
- Field indices are 1-based

### 1.2 Enumeration Patterns
- Type-safe enumeration pattern (SIMPLE_ENUMERATION)
- Bit flags pattern (SIMPLE_FLAGS)
- Value-name bidirectional mapping

## 2. Eiffel Standards

### 2.1 Design by Contract
- Comprehensive contracts on all public features
- Postconditions ensure model consistency
- Class invariants maintain valid state

### 2.2 Void Safety
- Full void safety compliance
- Detachable for optional values
- Proper attached checks

### 2.3 MML (Mathematical Model Library)
- SIMPLE_REGEX_MATCH_LIST uses MML_SEQUENCE for model contracts
- Ensures specification correctness

## 3. Design Patterns

### 3.1 Registry Pattern (SIMPLE_TYPE_REGISTRY)
- Singleton-like caching
- Lazy type info creation
- Key-based lookup

### 3.2 Visitor Pattern (SIMPLE_OBJECT_VISITOR)
- Object graph traversal
- Callback-based processing
- Depth tracking

### 3.3 Wrapper Pattern (SIMPLE_REFLECTED_OBJECT)
- Wraps ANY object
- Provides field access
- Type info integration
