<h1 align="center">simple_reflection</h1>

<p align="center">
  <a href="https://simple-eiffel.github.io/simple_reflection/">Documentation</a> |
  <a href="https://github.com/simple-eiffel/simple_reflection">GitHub</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Eiffel-25.02-purple.svg" alt="Eiffel 25.02">
  <img src="https://img.shields.io/badge/DBC-Contracts-green.svg" alt="Design by Contract">
</p>

Runtime reflection and type introspection library for Eiffel.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Production Ready** - v1.0.0
- 36 tests passing (20 basic + 16 adversarial)
- Type metadata caching
- Field introspection and access
- Type-safe enumerations and flags
- Object graph walking

## Overview

SIMPLE_REFLECTION provides runtime introspection for Eiffel applications:

- **Type introspection** - Query type metadata at runtime
- **Field access** - Read/write object fields by name
- **Enumeration support** - Type-safe enumerations with iteration
- **Object graph** - Walk object references with visitor pattern

## Quick Start

### Type Introspection

```eiffel
local
    info: SIMPLE_TYPE_INFO
    registry: SIMPLE_TYPE_REGISTRY
do
    create registry.make

    -- Get type info (cached)
    info := registry.type_info_for ({ARRAYED_LIST [STRING]})

    -- Query metadata
    print (info.name)        -- "ARRAYED_LIST [STRING]"
    print (info.base_name)   -- "ARRAYED_LIST"
    print (info.field_count) -- number of fields
end
```

### Reflected Object Access

```eiffel
local
    reflected: SIMPLE_REFLECTED_OBJECT
    customer: CUSTOMER
do
    create customer.make ("John", "john@example.com")
    create reflected.make (customer)

    -- Access field by name
    if attached reflected.field_value ("email") as l_email then
        print (l_email.out)
    end

    -- Set field by name
    reflected.set_field_value ("name", "Jane")
end
```

### Type-Safe Enumeration

```eiffel
class STATUS inherit SIMPLE_ENUMERATION
feature
    pending: INTEGER = 1
    active: INTEGER = 2
    completed: INTEGER = 3

    all_values: ARRAYED_LIST [INTEGER]
        once
            create Result.make_from_array (<<pending, active, completed>>)
        end

    name_for_value (v: INTEGER): STRING_32
        do
            inspect v
            when pending then Result := "pending"
            when active then Result := "active"
            when completed then Result := "completed"
            end
        end

    value_for_name (n: READABLE_STRING_GENERAL): INTEGER
        do
            if n.same_string ("pending") then Result := pending
            elseif n.same_string ("active") then Result := active
            elseif n.same_string ("completed") then Result := completed
            end
        end
end

-- Usage
my_status: STATUS
my_status.set_from_name ("active")
print (my_status.value)  -- 2
```

### Object Graph Walking

```eiffel
class STRING_FINDER inherit SIMPLE_OBJECT_VISITOR
feature
    strings: ARRAYED_LIST [STRING_GENERAL]

    on_object (obj: ANY; depth: INTEGER)
        do
            if attached {STRING_GENERAL} obj as l_str then
                strings.extend (l_str)
            end
        end

    on_reference (from_obj: ANY; field: STRING_32; to_obj: ANY)
        do -- optional
        end
end

-- Walk an object graph
walker: SIMPLE_OBJECT_GRAPH_WALKER
finder: STRING_FINDER
walker.walk (my_root_object, finder)
-- finder.strings now contains all strings
```

## Classes

| Class | Purpose |
|-------|---------|
| SIMPLE_TYPE_INFO | Type metadata container |
| SIMPLE_TYPE_REGISTRY | Global type info cache |
| SIMPLE_FIELD_INFO | Field metadata and access |
| SIMPLE_FEATURE_INFO | Feature metadata |
| SIMPLE_REFLECTED_OBJECT | Reflective object wrapper |
| SIMPLE_ENUMERATION | Type-safe enumeration base |
| SIMPLE_FLAGS | Bit flag enumeration base |
| SIMPLE_OBJECT_VISITOR | Graph walker callback interface |
| SIMPLE_OBJECT_GRAPH_WALKER | Object graph traversal |

## Installation

1. Set the ecosystem environment variable:
```
SIMPLE_EIFFEL=D:\prod
```

2. Add to ECF:
```xml
<library name="simple_reflection" location="$SIMPLE_EIFFEL/simple_reflection/simple_reflection.ecf"/>
```

## Dependencies

- EiffelBase (base)
- simple_factory

## Design Principles

- **Safety first** - Strong contracts on all operations
- **Caching** - Type information cached for performance
- **String agnostic** - Works with READABLE_STRING_GENERAL
- **SCOOP compatible** - Thread-safe design

## Known Limitations

1. **Bare ANY reflection** - Cannot reflect on objects created as bare ANY
2. **Creation procedures** - Detection deferred to Phase 2
3. **Generic decomposition** - Cannot query generic parameters

## License

MIT License - see [LICENSE](LICENSE) file.

---

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.
