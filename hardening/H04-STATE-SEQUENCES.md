# H04: Probe State Sequences - simple_reflection

## Date: 2026-01-19

---

## CLASS: SIMPLE_OBJECT_GRAPH_WALKER

### DOMAIN STATE MACHINE

**States:**
- IDLE: After make, before walk
- WALKING: During walk (recursive)
- COMPLETE: After walk finishes

**Valid transitions:**
- IDLE → WALKING via walk()
- WALKING → WALKING via walk_object() recursive
- WALKING → COMPLETE via walk() return

**Invalid transitions:**
- COMPLETE → WALKING without wipe_out (would accumulate visited)

### SEQUENCE PROBES

**Sequence 1: Double walk without clear**
- Type: DOMAIN_VALID
- Operations: walk(obj1) → walk(obj2)
- Expected: Second walk starts fresh
- Code behavior: `visited.wipe_out` called at start of walk - CORRECT

**Sequence 2: Walk interrupted (hypothetical)**
- Type: TECHNICAL
- Operations: walk() → exception during walk_object → retry
- Expected: Partial state cleaned up
- Code behavior: visited may contain partial data - ACCEPTABLE (not safety issue)

---

## CLASS: SIMPLE_TYPE_REGISTRY

### DOMAIN STATE MACHINE

**States:**
- EMPTY: After make, cache.is_empty
- POPULATED: cache.count > 0

**Valid transitions:**
- EMPTY → POPULATED via type_info_for
- POPULATED → POPULATED via type_info_for (add more)
- POPULATED → EMPTY via clear_cache

### SEQUENCE PROBES

**Sequence 1: Clear and repopulate**
- Type: DOMAIN_VALID
- Operations: type_info_for(STRING) → clear_cache → type_info_for(STRING)
- Expected: New instance created after clear
- Verified in: test_registry_after_clear - PASS

---

## CLASS: SIMPLE_REFLECTED_OBJECT

### DOMAIN STATE MACHINE

**States:**
- CREATED: After make, target and type_info set

**Valid transitions:**
- None - immutable target reference

### SEQUENCE PROBES

**Sequence 1: Modify via reflection**
- Type: DOMAIN_VALID
- Operations: make(obj) → set_field_value(name, val) → field_value(name)
- Expected: Value modified
- Verified in: test_field_set_verify_mutation - PASS

---

## SUMMARY

| Class | States | Sequences Probed | Issues |
|-------|--------|------------------|--------|
| SIMPLE_OBJECT_GRAPH_WALKER | 3 | 2 | 0 |
| SIMPLE_TYPE_REGISTRY | 2 | 1 | 0 |
| SIMPLE_REFLECTED_OBJECT | 1 | 1 | 0 |

**No state machine bugs found.**

---

## VERIFICATION CHECKPOINT

- Classes analyzed: 3
- State machines extracted: 3
- Sequences probed: 4
- State bugs found: 0
- hardening/H04-STATE-SEQUENCES.md: CREATED
