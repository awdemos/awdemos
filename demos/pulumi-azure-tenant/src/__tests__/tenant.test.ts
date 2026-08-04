import {
  createTenant,
  sanitizeDomainName,
  validateTenantName,
} from "../tenant";

describe("tenant helpers", () => {
  it("sanitizes domain names to lowercase alphanumeric", () => {
    expect(sanitizeDomainName("My Tenant")).toBe("mytenant");
    expect(sanitizeDomainName("tenant-123_test")).toBe("tenant123test");
  });

  it("accepts valid tenant names", () => {
    expect(() => validateTenantName("mytenant")).not.toThrow();
    expect(() => validateTenantName("my-tenant_123")).not.toThrow();
  });

  it("rejects empty tenant names", () => {
    expect(() => validateTenantName("")).toThrow(/required and must be non-empty/);
    expect(() => validateTenantName("   ")).toThrow(/required and must be non-empty/);
  });

  it("rejects invalid tenant names", () => {
    expect(() => validateTenantName("my tenant")).toThrow(/must start with alphanumeric/);
    expect(() => validateTenantName("-tenant")).toThrow(/must start with alphanumeric/);
  });
});

describe("createTenant", () => {
  it("returns tenant outputs", () => {
    const result = createTenant();
    expect(result.tenantId).toBeDefined();
    expect(result.name).toBeDefined();
  });
});
