# demos/pulumi-azure-tenant — KNOWLEDGE BASE

## OVERVIEW

Multi-tenant Azure AD B2C infrastructure provisioned with Pulumi TypeScript. Tenant isolation, app registrations, and identity policies as code.

## STRUCTURE

```
pulumi-azure-tenant/
├── src/
│   ├── config.ts    # Environment configuration
│   ├── index.ts     # Stack exports
│   └── tenant.ts    # Tenant resource definitions
├── index.ts         # Entry point
├── Pulumi.yaml      # Project config
├── Pulumi.dev.yaml  # Dev stack config
├── package.json     # TypeScript deps
└── tsconfig.json    # TS compiler config
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Tenant resources | `src/tenant.ts` | B2C tenant, app registrations |
| Config logic | `src/config.ts` | Environment-specific values |
| Stack exports | `src/index.ts` | Output references |
| Entry point | `index.ts` | Program bootstrap |

## CONVENTIONS

- **Pulumi TypeScript** — strongly-typed infrastructure
- **Modular resources** — `tenant.ts` isolates domain logic from entry point
- **Stack configs** — `Pulumi.dev.yaml` for per-environment overrides

## ANTI-PATTERNS

- Do NOT hardcode secrets in `Pulumi.dev.yaml` — use Pulumi config secrets or env vars
- Avoid monolithic `index.ts` — keep resource definitions in `src/`
