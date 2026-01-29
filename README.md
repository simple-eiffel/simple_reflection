<p align="center">
  <img src="docs/images/logo.svg" alt="simple_reflection logo" width="200">
</p>

<h1 align="center">simple_reflection</h1>

<p align="center">
  <a href="https://simple-eiffel.github.io/simple_reflection/">Documentation</a> •
  <a href="https://github.com/simple-eiffel/simple_reflection">GitHub</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Eiffel-25.02-purple.svg" alt="Eiffel 25.02">
  <img src="https://img.shields.io/badge/DBC-Contracts-green.svg" alt="Design by Contract">
</p>

**Runtime reflection and type introspection library for Eiffel** — Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

✅ **Production Ready** — v1.0.0
- 9 classes, ~80 features
- 44 tests passing
- Full Design by Contract coverage

## Overview

SIMPLE_REFLECTION provides runtime introspection capabilities for Eiffel applications, enabling inspection and manipulation of objects at runtime through a clean, contract-based API.

The library wraps Eiffel's INTERNAL class with a higher-level abstraction, providing type-safe access to object fields, type metadata caching for performance, and support for type-safe enumerations and flags.

Key use cases include serialization libraries, debugging tools, ORM implementations, and any scenario requiring dynamic object inspection without compile-time type knowledge.

## Quick Start

```eiffel
local
    registry: SIMPLE_TYPE_REGISTRY
    info: SIMPLE_TYPE_INFO
    reflected: SIMPLE_REFLECTED_OBJECT
    customer: CUSTOMER
do
    -- Type introspection with caching
    create registry.make
    info := registry.type_info_for ({CUSTOMER})
    print (info.name + ": " + info.field_count.out + " fields%N")

    -- Reflective field access
    create customer.make ("John", "john@example.com")
    create reflected.make (customer)
    if attached reflected.field_value ("email") as l_email then
        print ("Email: " + l_email.out + "%N")
    end
end
```

## API Reference

### SIMPLE_TYPE_REGISTRY

| Feature | Description |
|---------|-------------|
| `make` | Create empty registry |
| `type_info_for (a_type_id: INTEGER)` | Get cached type info for type ID |
| `has_type (a_type_id: INTEGER)` | Check if type is cached |
| `clear_cache` | Clear all cached type info |

### SIMPLE_TYPE_INFO

| Feature | Description |
|---------|-------------|
| `make_from_type_id (a_type_id: INTEGER)` | Create from runtime type ID |
| `name` | Full type name with generics |
| `base_name` | Type name without generics |
| `type_id` | Runtime type identifier |
| `fields` | List of field metadata |
| `field_count` | Number of fields |
| `has_field (a_name: READABLE_STRING_GENERAL)` | Check field exists |

### SIMPLE_REFLECTED_OBJECT

| Feature | Description |
|---------|-------------|
| `make (a_object: ANY)` | Wrap object for reflection |
| `type_info` | Get type metadata |
| `field_value (a_name: READABLE_STRING_GENERAL)` | Read field value |
| `set_field_value (a_name, a_value)` | Write field value |
| `field_names` | List all field names |

### SIMPLE_FIELD_INFO

| Feature | Description |
|---------|-------------|
| `name` | Field name |
| `type_id` | Field type ID |
| `index` | Field index in object |
| `value (a_object: ANY)` | Read field value |
| `set_value (a_object, a_value)` | Write field value |
| `is_reference` | True if reference type |

### SIMPLE_ENUMERATION

| Feature | Description |
|---------|-------------|
| `value` | Current enumeration value |
| `set_value (a_value: INTEGER)` | Set from integer |
| `set_from_name (a_name: READABLE_STRING_GENERAL)` | Set from string |
| `name` | Name of current value |
| `all_values` | List of valid values (deferred) |
| `is_valid_value (a_value: INTEGER)` | Validate value |

### SIMPLE_FLAGS

| Feature | Description |
|---------|-------------|
| `value` | Current flag bits |
| `has_flag (a_flag: INTEGER)` | Test single flag |
| `set_flag (a_flag: INTEGER)` | Enable flag |
| `clear_flag (a_flag: INTEGER)` | Disable flag |
| `toggle_flag (a_flag: INTEGER)` | Toggle flag |
| `to_names` | List of enabled flag names |

### SIMPLE_OBJECT_GRAPH_WALKER

| Feature | Description |
|---------|-------------|
| `make` | Create walker |
| `walk (a_root, a_visitor)` | Traverse object graph |
| `set_max_depth (a_depth: INTEGER)` | Limit traversal depth |
| `visited_count` | Number of objects visited |

## Features

- ✅ Type metadata introspection
- ✅ Field read/write by name
- ✅ Type info caching for performance
- ✅ Type-safe enumerations
- ✅ Bit flag support
- ✅ Object graph traversal
- ✅ Design by Contract throughout
- ✅ Void-safe
- ✅ SCOOP-compatible

## Installation

### Using as ECF Dependency

Add to your `.ecf` file:

```xml
<library name="simple_reflection" location="$SIMPLE_LIBS/simple_reflection/simple_reflection.ecf"/>
```

### Environment Setup

Set the `SIMPLE_LIBS` environment variable:
```bash
export SIMPLE_LIBS=/path/to/simple/libraries
```

## Dependencies

| Library | Purpose |
|---------|---------|
| EiffelBase | Core data structures |
| simple_factory | Factory pattern support |

## License

MIT License - see [LICENSE](LICENSE) file.

---

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.
