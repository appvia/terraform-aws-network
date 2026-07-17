# Route53 Profiles Association Tests Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align Route53 profile selection with the approved behaviour matrix and cover it with plan-only Terraform tests.

**Architecture:** Keep association gated on `local.route53_profile_id` via the existing `aws_route53_profile_association.route53_profile` count. Fix selection in `locals.tf` so an explicit ID is only accepted under discovery when it appears in `data.aws_route53profiles_profiles.current.profiles`. Validate all seven cases with mocked AWS provider plan tests in `tests/route53_profiles.tftest.hcl`.

**Tech Stack:** Terraform test framework (`.tftest.hcl`), `mock_provider` / `mock_data` / `override_data`, AWS provider data source `aws_route53profiles_profiles`.

## Global Constraints

- Plan-only tests (`command = plan`); no real AWS apply.
- Behaviour must match `docs/superpowers/specs/2026-07-17-route53-profiles-tests-design.md` (option A).
- Variable name is `route53_profile_id`; data source type is `aws_route53profiles_profiles`.
- Follow existing test style in `tests/module.tftest.hcl`.
- Do not expand scope to examples, docs beyond the plan, or unrelated module behaviour.

## File Structure

| File | Responsibility |
|------|----------------|
| `locals.tf` | Compute `local.route53_profiles` and `local.route53_profile_id` |
| `data.tf` | Declare `data.aws_route53profiles_profiles.current` (already present; do not rename) |
| `main.tf` | Create `aws_route53_profile_association.route53_profile` when local ID is non-null (already present) |
| `outputs.tf` | Export `output.route53_profile_id` (already present) |
| `tests/route53_profiles.tftest.hcl` | Seven plan runs covering cases a–e, f1, f2 |

---

### Task 1: Add failing Route53 profile plan tests

**Files:**
- Create: `tests/route53_profiles.tftest.hcl`
- Modify: (none yet)
- Test: `tests/route53_profiles.tftest.hcl`

**Interfaces:**
- Consumes: `variable.route53_profile_id`, `variable.enable_route53_profiles_rules`, `data.aws_route53profiles_profiles.current`, `resource.aws_route53_profile_association.route53_profile`, `output.route53_profile_id`
- Produces: Seven named runs (`a`, `b`, `c`, `d`, `e`, `f1`, `f2`) asserting association presence/absence

- [ ] **Step 1: Create the test file with shared mocks and all seven runs**

Create `tests/route53_profiles.tftest.hcl` with this exact content:

```hcl
mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = [
        "eu-west-1a",
        "eu-west-1b",
        "eu-west-1c"
      ]
    }
  }

  mock_data "aws_route53_resolver_rules" {
    defaults = {
      resolver_rule_ids = [
        "rslvr-rr-1234567890",
      ]
    }
  }

  mock_data "aws_region" {
    defaults = {
      region = "eu-west-1"
    }
  }

  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "1234567890"
    }
  }

  mock_data "aws_route53profiles_profiles" {
    defaults = {
      profiles = []
    }
  }
}

run "a_no_profile_discovery_disabled" {
  command = plan

  variables {
    name                           = "test-vpc"
    private_subnet_netmask         = 24
    enable_route53_profiles_rules  = false
    route53_profile_id             = null
    enable_route53_resolver_rules  = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53_profile_association.route53_profile) == 0
    error_message = "Case a: expected no route53 profile association"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case a: expected route53_profile_id output to be null"
  }
}

run "b_explicit_profile_discovery_disabled" {
  command = plan

  variables {
    name                           = "test-vpc"
    private_subnet_netmask         = 24
    enable_route53_profiles_rules  = false
    route53_profile_id             = "rp-explicit"
    enable_route53_resolver_rules  = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53_profile_association.route53_profile) == 1
    error_message = "Case b: expected route53 profile association"
  }

  assert {
    condition     = aws_route53_profile_association.route53_profile[0].profile_id == "rp-explicit"
    error_message = "Case b: association profile_id should be rp-explicit"
  }

  assert {
    condition     = output.route53_profile_id == "rp-explicit"
    error_message = "Case b: expected route53_profile_id output to be rp-explicit"
  }
}

run "c_discovery_enabled_no_profiles" {
  command = plan

  variables {
    name                           = "test-vpc"
    private_subnet_netmask         = 24
    enable_route53_profiles_rules  = true
    route53_profile_id             = null
    enable_route53_resolver_rules  = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53_profile_association.route53_profile) == 0
    error_message = "Case c: expected no association when no profiles discovered"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case c: expected route53_profile_id output to be null"
  }
}

run "d_discovery_enabled_one_profile" {
  command = plan

  override_data {
    target = data.aws_route53profiles_profiles.current
    values = {
      profiles = [
        {
          id           = "rp-one"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-one"
          name         = "one"
          share_status = "SHARED_WITH_ME"
        }
      ]
    }
  }

  variables {
    name                           = "test-vpc"
    private_subnet_netmask         = 24
    enable_route53_profiles_rules  = true
    route53_profile_id             = null
    enable_route53_resolver_rules  = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53_profile_association.route53_profile) == 1
    error_message = "Case d: expected association when exactly one profile is discovered"
  }

  assert {
    condition     = aws_route53_profile_association.route53_profile[0].profile_id == "rp-one"
    error_message = "Case d: association profile_id should be rp-one"
  }

  assert {
    condition     = output.route53_profile_id == "rp-one"
    error_message = "Case d: expected route53_profile_id output to be rp-one"
  }
}

run "e_discovery_enabled_multiple_profiles" {
  command = plan

  override_data {
    target = data.aws_route53profiles_profiles.current
    values = {
      profiles = [
        {
          id           = "rp-a"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-a"
          name         = "a"
          share_status = "SHARED_WITH_ME"
        },
        {
          id           = "rp-b"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-b"
          name         = "b"
          share_status = "SHARED_WITH_ME"
        }
      ]
    }
  }

  variables {
    name                           = "test-vpc"
    private_subnet_netmask         = 24
    enable_route53_profiles_rules  = true
    route53_profile_id             = null
    enable_route53_resolver_rules  = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53_profile_association.route53_profile) == 0
    error_message = "Case e: expected no association when multiple profiles are discovered"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case e: expected route53_profile_id output to be null"
  }
}

run "f1_explicit_profile_found_among_multiple" {
  command = plan

  override_data {
    target = data.aws_route53profiles_profiles.current
    values = {
      profiles = [
        {
          id           = "rp-a"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-a"
          name         = "a"
          share_status = "SHARED_WITH_ME"
        },
        {
          id           = "rp-b"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-b"
          name         = "b"
          share_status = "SHARED_WITH_ME"
        }
      ]
    }
  }

  variables {
    name                           = "test-vpc"
    private_subnet_netmask         = 24
    enable_route53_profiles_rules  = true
    route53_profile_id             = "rp-a"
    enable_route53_resolver_rules  = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53_profile_association.route53_profile) == 1
    error_message = "Case f1: expected association when explicit profile exists in discovered list"
  }

  assert {
    condition     = aws_route53_profile_association.route53_profile[0].profile_id == "rp-a"
    error_message = "Case f1: association profile_id should be rp-a"
  }

  assert {
    condition     = output.route53_profile_id == "rp-a"
    error_message = "Case f1: expected route53_profile_id output to be rp-a"
  }
}

run "f2_explicit_profile_not_found_among_multiple" {
  command = plan

  override_data {
    target = data.aws_route53profiles_profiles.current
    values = {
      profiles = [
        {
          id           = "rp-a"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-a"
          name         = "a"
          share_status = "SHARED_WITH_ME"
        },
        {
          id           = "rp-b"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-b"
          name         = "b"
          share_status = "SHARED_WITH_ME"
        }
      ]
    }
  }

  variables {
    name                           = "test-vpc"
    private_subnet_netmask         = 24
    enable_route53_profiles_rules  = true
    route53_profile_id             = "rp-missing"
    enable_route53_resolver_rules  = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53_profile_association.route53_profile) == 0
    error_message = "Case f2: expected no association when explicit profile is not in discovered list"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case f2: expected route53_profile_id output to be null"
  }
}
```

- [ ] **Step 2: Run the new tests and confirm they fail before the locals fix**

Run:

```bash
terraform test -filter=tests/route53_profiles.tftest.hcl
```

Expected: failure. Acceptable failure modes before Task 2:

- Reference to wrong data source address `data.aws_route53_profiles_profiles.current` in `locals.tf` (does not match `data.tf`)
- Run `f2_explicit_profile_not_found_among_multiple` fails because current locals always trust `var.route53_profile_id` when set

Do not proceed to commit this task alone if the suite already fully passes — that would mean the locals fix landed out of order; still continue to Task 2 to ensure the exact selection logic from the spec is present.

- [ ] **Step 3: Commit the failing tests**

```bash
git add tests/route53_profiles.tftest.hcl
git commit -m "$(cat <<'EOF'
test: add route53 profile association plan coverage

EOF
)"
```

---

### Task 2: Fix Route53 profile selection locals

**Files:**
- Modify: `locals.tf` (the `route53_profiles` / `route53_profile_id` locals at the end of the file)
- Test: `tests/route53_profiles.tftest.hcl`

**Interfaces:**
- Consumes: `var.enable_route53_profiles_rules`, `var.route53_profile_id`, `data.aws_route53profiles_profiles.current.profiles`
- Produces: `local.route53_profiles` (list of profile IDs), `local.route53_profile_id` (string or null)

- [ ] **Step 1: Replace the Route53 profile locals with the approved selection logic**

In `locals.tf`, replace the existing Route53 profile locals (currently referencing `data.aws_route53_profiles_profiles` and selecting an explicit ID without membership checks) with:

```hcl
  ## A list of route53 profiles to associate with the VPC
  route53_profiles = var.enable_route53_profiles_rules ? [for profile in data.aws_route53profiles_profiles.current.profiles : profile.id] : []
  ## Explicit ID when discovery is off; when discovery is on, only if present in discovered profiles; otherwise auto-select when exactly one profile exists
  route53_profile_id = (
    var.route53_profile_id != null
    ? (
      !var.enable_route53_profiles_rules
      ? var.route53_profile_id
      : contains(local.route53_profiles, var.route53_profile_id)
      ? var.route53_profile_id
      : null
    )
    : length(local.route53_profiles) == 1
    ? local.route53_profiles[0]
    : null
  )
```

Do not change `main.tf` association resource or `data.tf` data source declarations in this task unless a typo still prevents the address `data.aws_route53profiles_profiles.current` from resolving.

- [ ] **Step 2: Re-run the Route53 profile tests and confirm all seven pass**

Run:

```bash
terraform test -filter=tests/route53_profiles.tftest.hcl
```

Expected: all runs in `tests/route53_profiles.tftest.hcl` pass (`a` through `f2`).

If `override_data` fails to populate nested `profiles` (known Terraform mocking limitation with some list/nested attributes), fall back by moving each non-empty profiles fixture into a run-scoped approach that works with this Terraform version — prefer keeping `override_data` first; only if it silently returns empty lists, switch those runs to a file-level pattern using separate mock defaults is not available per-run, so document the observed error and use `mock_data` defaults plus splitting into additional test files only as a last resort. The success criterion remains: all seven behaviours asserted and green.

- [ ] **Step 3: Run the existing module plan test to catch regressions**

Run:

```bash
terraform test -filter=tests/module.tftest.hcl
```

Expected: existing `basic` run still passes.

- [ ] **Step 4: Commit the locals fix**

```bash
git add locals.tf
git commit -m "$(cat <<'EOF'
fix: select route53 profile only when discovery rules allow

EOF
)"
```

---

### Task 3: Final verification

**Files:**
- Modify: none (verification only)
- Test: `tests/route53_profiles.tftest.hcl`, `tests/module.tftest.hcl`

**Interfaces:**
- Consumes: outputs of Tasks 1–2
- Produces: confirmation that the full filtered suite is green

- [ ] **Step 1: Run both filtered test files together**

Run:

```bash
terraform test -filter=tests/route53_profiles.tftest.hcl -filter=tests/module.tftest.hcl
```

Expected: all runs pass.

- [ ] **Step 2: Confirm working tree only contains intentional leftover WIP (if any)**

Run:

```bash
git status
```

Expected: Route53 test file and locals fix committed. If `data.tf` / `main.tf` / `outputs.tf` / `variables.tf` still show unstaged feature WIP from before this plan, leave them untouched unless they are required for the tests to compile; do not drive-by refactor.

---

## Spec coverage checklist

| Spec requirement | Task |
|------------------|------|
| Case a — no inputs → no association | Task 1 run `a` |
| Case b — explicit ID, discovery off → associate | Task 1 run `b` |
| Case c — discovery on, zero profiles → no association | Task 1 run `c` |
| Case d — discovery on, one profile → associate | Task 1 run `d` |
| Case e — discovery on, multiple → no association | Task 1 run `e` |
| Case f1 — explicit ID found among multiple → associate | Task 1 run `f1` |
| Case f2 — explicit ID missing among multiple → no association (option A) | Task 1 run `f2` + Task 2 locals |
| Fix data source / variable references | Task 2 |
| Plan-only mocked tests | Task 1 |
| Association resource remains count-gated | unchanged `main.tf`; asserted in Task 1 |

## Self-review notes

- No TBD/placeholder steps; full test file and locals snippet included.
- Names consistent: `route53_profile_id`, `aws_route53profiles_profiles`, association resource `aws_route53_profile_association.route53_profile`.
- TDD order preserved: failing tests first, then locals fix, then verify.
