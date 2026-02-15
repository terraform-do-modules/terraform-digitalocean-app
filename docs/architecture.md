# Architecture Guidance

This module targets production App Platform deployments where app spec, domains, and alerting are managed as code.

## Recommended Production Pattern

1. Keep app spec in version-controlled `tfvars` files.
2. Use managed domains with explicit ownership and DNS automation.
3. Define alert policies for CPU, memory, and deployment health.
4. Separate staging and production apps by workspace/environment.

## Operational Checklist

- Enable CI checks before every release.
- Validate example plans in `_examples/` against current provider versions.
- Keep module and provider version constraints aligned in `versions.tf`.
