# S07: SPEC SUMMARY - simple_reflection

**BACKWASH DOCUMENT** - Generated: 2026-01-23
**Status**: Reverse-engineered from existing implementation

## 1. Library Overview

**Name**: simple_reflection
**Purpose**: Simplified reflection API with enums, flags, and graph walking
**Status**: Production ready

## 2. Quick Reference

### 2.1 Object Reflection
```eiffel
-- Wrap an object
reflected := create {SIMPLE_REFLECTED_OBJECT}.make (my_object)

-- Access fields
name := reflected.field_value ("name")
reflected.set_field_value ("count", 42)

-- Iterate fields
reflected.do_all_fields (agent process_field)
```

### 2.2 Type Information
```eiffel
-- Get type info
registry := create {SIMPLE_TYPE_REGISTRY}.make
info := registry.type_info_for ({MY_CLASS})

-- Inspect type
print (info.name)
print (info.field_count)
across info.fields as f loop
    print (f.item.name)
end
```

### 2.3 Enumerations
```eiffel
class MY_STATUS inherit SIMPLE_ENUMERATION
feature
    all_values: ARRAYED_LIST [INTEGER]
        do create Result.make_from_array (<<1, 2, 3>>) end
    name_for_value (v: INTEGER): STRING_32
        do inspect v when 1 then Result := "Active" ... end end
    value_for_name (n): INTEGER
        do ... end
```

### 2.4 Flags
```eiffel
class MY_PERMISSIONS inherit SIMPLE_FLAGS
feature
    all_flag_values: ARRAYED_LIST [INTEGER]
        do create Result.make_from_array (<<1, 2, 4, 8>>) end
    -- Implement name_for_flag, flag_for_name
```

### 2.5 Graph Walking
```eiffel
walker := create {SIMPLE_OBJECT_GRAPH_WALKER}.make
walker.set_max_depth (5)
walker.walk (root_object, my_visitor)
```

## 3. Key Specifications

| Aspect | Specification |
|--------|---------------|
| Classes | 9 |
| Dependencies | None (EiffelBase only) |
| Thread Safety | Depends on usage |
| Void Safe | Yes |

## 4. Warnings

1. **Type IDs are runtime-specific** - Don't persist
2. **Field indices can change** - Don't hardcode
3. **Not true object identity** - Walker may have hash collisions
4. **Security considerations** - Reflection bypasses encapsulation
