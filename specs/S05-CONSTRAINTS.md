# S05: CONSTRAINTS - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Technical Constraints

### 1.1 Platform Constraints
- **EiffelStudio**: Requires EiffelStudio 25.02 or compatible
- **Platform**: Cross-platform (uses INTERNAL)

### 1.2 Runtime Constraints
- Type IDs are runtime-specific (not persistent)
- Field indices can change between compilations
- Reflection requires system finalization info

## 2. Design Constraints

### 2.1 Enumeration Constraints
- Must inherit SIMPLE_ENUMERATION
- Must implement all_values (deferred)
- Must implement name_for_value (deferred)
- Must implement value_for_name (deferred)

### 2.2 Flags Constraints
- Must inherit SIMPLE_FLAGS
- All flag values must be powers of 2
- Must implement all_flag_values (deferred)
- Must implement name_for_flag (deferred)
- Must implement flag_for_name (deferred)

### 2.3 Visitor Constraints
- Must inherit SIMPLE_OBJECT_VISITOR
- Must implement on_object (deferred)
- Must implement on_reference (deferred)

## 3. Performance Constraints

### 3.1 Caching
- Type info cached on first access
- Cache grows with types used
- No automatic cleanup

### 3.2 Graph Walking
- Depth limited by max_depth (0 = unlimited)
- Memory grows with visited objects
- Cycle detection via hash set

## 4. Safety Constraints

### 4.1 Type Safety
- set_value handles type mismatches
- Expanded types require special handling
- Void safety maintained

### 4.2 Object Identity
- Current implementation uses state-based hash
- Not true object identity
- May have collisions for identical state
