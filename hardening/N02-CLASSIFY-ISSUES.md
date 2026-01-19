# N02: Classify Naming Issues - simple_reflection

## Date: 2026-01-19

---

## STEP 1: CRITICAL BLOCKERS

**CRITICAL BLOCKERS: NONE**

No VOIT(2) conflicts, no TUPLE label conflicts, no local/attribute shadows.

---

## STEP 2: GROUP BY RENAME SCOPE

### SCOPE ANALYSIS

**1. CLASS RENAMES: NONE NEEDED**

**2. PUBLIC FEATURE RENAMES: NONE NEEDED**

**3. PRIVATE FEATURE RENAMES: NONE NEEDED**

**4. LOCAL/ARGUMENT RENAMES: NONE NEEDED**

**5. CURSOR RENAMES: 3 (Optional)**

All cursor renames are optional - `ic` is acceptable.

| Location | Current | Suggested | Risk |
|----------|---------|-----------|------|
| simple_enumeration.e:32 | `ic` | `ic_value` | MINIMAL |
| simple_flags.e:22 | `ic` | `ic_flag` | MINIMAL |
| simple_flags.e:192,195 | `ic` | `ic_name` | MINIMAL |

**6. MAGIC NUMBER CONSTANTS: 5 (Optional)**

All magic numbers are collection capacities - naming is optional.

| Location | Number | Suggested Constant | Risk |
|----------|--------|-------------------|------|
| simple_type_info.e:175 | 10 | Default_field_capacity | MINIMAL |
| simple_type_info.e:176 | 10 | Default_feature_capacity | MINIMAL |
| simple_type_info.e:177 | 2 | Default_creation_capacity | MINIMAL |
| simple_type_registry.e:18 | 100 | Default_cache_capacity | MINIMAL |
| simple_object_graph_walker.e:18 | 100 | Default_visited_capacity | MINIMAL |
| simple_object_graph_walker.e:112 | 100000 | Hash_range | LOW |

---

## STEP 3: IDENTIFY RENAME CHAINS

**RENAME CHAINS: NONE**

No dependencies between renames.

---

## STEP 4: RECOMMENDED FIX ORDER

### OPTION A: Full Cleanup (All 8 violations)

Phase 1: CURSOR NAMES (3 changes)
- simple_enumeration.e: `ic` → `ic_value`
- simple_flags.e: `ic` → `ic_flag` / `ic_name`
CHECKPOINT: Compile

Phase 2: MAGIC NUMBER CONSTANTS (5 changes)
- Add constants to classes
CHECKPOINT: Compile

### OPTION B: Minimal Cleanup (0 changes)

All violations are LOW priority. The codebase is clean and functional.
No changes strictly required.

---

## STEP 5: RECOMMENDATION

**RECOMMENDATION: OPTION B - No Changes Required**

Rationale:
1. All 8 violations are LOW severity
2. `ic` cursor naming is acceptable per Eiffel convention
3. Magic numbers are standard collection capacities
4. No compile errors, no semantic issues
5. Time better spent on other priorities

**Alternative:** If strict compliance desired, apply OPTION A.

---

## PRIORITY SUMMARY

| Priority | Count | Compile Impact |
|----------|-------|----------------|
| Critical | 0 | N/A |
| Class Renames | 0 | N/A |
| Public Features | 0 | N/A |
| Private Features | 0 | N/A |
| Arguments | 0 | N/A |
| Locals/Cursors | 3 | None (optional) |
| Magic Numbers | 5 | None (optional) |
| Contract Tags | 0 | N/A |
| Clause Labels | 0 | N/A |

---

## VERIFICATION CHECKPOINT

- Critical violations: 0
- Optional fixes: 8
- Recommendation: No changes required
- hardening/N02-CLASSIFY-ISSUES.md: CREATED
