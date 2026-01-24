# 7S-05: SECURITY - simple_reflection


**Date**: 2026-01-23

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Security Considerations

### 1.1 Reflection Risks
Reflection APIs can bypass normal access controls:
- Private fields become accessible
- Object state can be modified arbitrarily
- Type system constraints can be circumvented

### 1.2 Mitigations in Design
- Field access requires explicit type info
- No method invocation support (limits attack surface)
- Object graph walker has depth limits

## 2. Potential Security Issues

### 2.1 Information Disclosure
- Type names reveal implementation details
- Field values can expose sensitive data
- Object graphs can reveal system structure

### 2.2 State Manipulation
- set_field_value allows arbitrary modifications
- Can break object invariants
- Can inject malicious data

### 2.3 Denial of Service
- Object graph walking can be expensive
- Deep/cyclic graphs could cause issues
- Mitigated by max_depth setting

## 3. Recommendations

### 3.1 For Library Users
1. Limit reflection use to trusted code paths
2. Don't expose reflection APIs to user input
3. Validate data before setting via reflection
4. Use max_depth for graph walking

### 3.2 Security-Sensitive Contexts
- Avoid reflecting on security-critical objects
- Don't log reflected field values containing secrets
- Consider access control wrappers

## 4. Safe Usage Pattern

```eiffel
-- Good: Limited, validated use
if known_safe_type.conforms_to_type (target_type) then
    reflected := create {SIMPLE_REFLECTED_OBJECT}.make (object)
    -- Process known fields only
end

-- Bad: Unrestricted reflection on untrusted input
reflected := create {SIMPLE_REFLECTED_OBJECT}.make (untrusted_object)
reflected.set_field_value ("admin", True)  -- Security bypass!
```
