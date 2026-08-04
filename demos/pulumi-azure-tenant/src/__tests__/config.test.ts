import { location, resourceGroupName, tenantName } from "../config";

describe("config defaults", () => {
  it("exports default config values", () => {
    expect(tenantName).toBe("testtenant");
    expect(location).toBe("eastus");
    expect(resourceGroupName).toBe("myResourceGroup");
  });
});
