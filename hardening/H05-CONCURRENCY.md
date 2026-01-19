# H05: Probe Concurrency - simple_reflection

## Date: 2026-01-19

---

## CONCURRENCY MODE

**ECF Setting:** `concurrency support="scoop"`

---

## DOMAIN CONCURRENT USE CASES

1. **Type registry access from multiple threads**
   - Multiple processors request type_info simultaneously
   - Registry cache is shared resource

2. **Walker visiting same object graph from multiple processors**
   - Rare but possible in concurrent systems

---

## TECHNICAL FINDINGS

### Finding 1: SIMPLE_TYPE_REGISTRY.cache not SCOOP-safe
**Pattern:** Shared mutable state
**Location:** simple_type_registry.e:143
**Risk:**
- cache is HASH_TABLE, not separate
- Two SCOOP regions calling type_info_for simultaneously could race
- One might read while other writes → undefined behavior

### Finding 2: Once function type_registry in SIMPLE_REFLECTED_OBJECT
**Pattern:** Once function returns non-separate
**Location:** simple_reflected_object.e:98-103
**Risk:**
- `once` returns shared SIMPLE_TYPE_REGISTRY
- In SCOOP, once functions return separate by default on first call region
- Subsequent regions get same instance without synchronization

---

## DOMAIN CONCURRENCY FINDINGS

### Finding 1: Registry concurrent modification
**Scenario:** Two processors call type_info_for with different types simultaneously
**Conflict:** HASH_TABLE.put not atomic
**Contract gap:** No precondition requiring exclusive access
**Code gap:** No separate argument or lock

---

## CONTRACT-CONCURRENCY MALFORMATION

- Precondition `type_exists: a_type /= Void` assumes non-concurrent call context
- No SCOOP wait condition on cache access

---

## CODE-CONCURRENCY MALFORMATION

- `cache.put (Result, a_type.type_id)` modifies shared state without synchronization
- `type_info_by_name` iterates `cache.current_keys` which could change during iteration

---

## CONCURRENCY RISK SCORE: **MEDIUM**

The library uses SCOOP mode but doesn't have explicit SCOOP-safe patterns. In practice:
- Type registration typically happens at startup (single-threaded)
- Runtime access is read-mostly after initial population
- Real-world impact low unless heavy concurrent type registration

---

## RECOMMENDATIONS

For Phase 2, consider:
1. Make registry a separate object
2. Use SCOOP-safe iteration patterns
3. Document thread-safety guarantees in specs

---

## VERIFICATION CHECKPOINT

- Concurrency mode: SCOOP
- Technical findings: 2
- Domain findings: 1
- Risk score: MEDIUM
- hardening/H05-CONCURRENCY.md: CREATED
