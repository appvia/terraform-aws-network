# Route53 Profiles Association — Test Design

## Goal

Validate Route53 Profile association behaviour for this module with Terraform plan tests, and align locals selection logic with the agreed rules (option A: when discovery is enabled, an explicit profile ID must appear in discovered profiles).

## Behaviour matrix

| Case | `route53_profile_id` | `enable_route53_profiles_rules` | Discovered profiles | Association | `local.route53_profile_id` |
|------|----------------------|---------------------------------|---------------------|-------------|----------------------------|
| a | `null` | `false` | (ignored) | none | `null` |
| b | set (`rp-explicit`) | `false` | (ignored) | yes | explicit ID |
| c | `null` | `true` | `[]` | none | `null` |
| d | `null` | `true` | one (`rp-one`) | yes | that ID |
| e | `null` | `true` | two or more | none | `null` |
| f1 | set (`rp-a`) | `true` | `[rp-a, rp-b]` | yes | `rp-a` |
| f2 | set (`rp-missing`) | `true` | `[rp-a, rp-b]` | none | `null` |

**Associated** means:

- `aws_route53_profile_association.route53_profile` has count `1`
- `local.route53_profile_id` / `output.route53_profile_id` is the expected non-null ID

**Not associated** means count `0` and output/local ID is `null`.

## Selection logic

```hcl
route53_profiles = var.enable_route53_profiles_rules ? [
  for profile in data.aws_route53profiles_profiles.current.profiles : profile.id
] : []

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

### Supporting fixes (required for compile correctness)

- Use `var.route53_profile_id` (not `var.route53_profile`) in locals.
- Reference `data.aws_route53profiles_profiles.current` (matches `data.tf` / AWS provider).

Resource association remains:

```hcl
resource "aws_route53_profile_association" "route53_profile" {
  count = local.route53_profile_id != null ? 1 : 0
  # ...
}
```

## Test approach

**File:** `tests/route53_profiles.tftest.hcl`

- Plan-only tests using `mock_provider "aws"`, consistent with `tests/module.tftest.hcl`.
- Shared base mocks: availability zones, region, caller identity, resolver rules, default empty `aws_route53profiles_profiles`.
- Seven `run` blocks (`a`–`e`, `f1`, `f2`) with minimal required module variables (`name`, `private_subnet_netmask`, `tags`, plus the profile inputs under test).
- Per-run mock overrides for the profiles list where the case needs non-empty / multi-profile data.
- Assertions on association count, association `profile_id`, and `output.route53_profile_id`.

### Out of scope

- Apply / integration tests against a real AWS account
- New examples
- Changes to unrelated module behaviour

## Implementation notes

1. Update `locals.tf` selection logic and data/variable references.
2. Add `tests/route53_profiles.tftest.hcl` covering the matrix above.
3. Run `terraform test` (or the repo’s usual test command) and confirm all seven runs pass.
