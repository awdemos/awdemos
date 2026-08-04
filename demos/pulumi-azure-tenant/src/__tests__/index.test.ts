import { tenantId, name } from "../index";

describe("pulumi-azure-tenant program", () => {
  it("exports tenant outputs", () => {
    expect(tenantId).toBeDefined();
    expect(name).toBeDefined();
  });
});
