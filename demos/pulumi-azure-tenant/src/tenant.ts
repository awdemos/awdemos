import * as pulumi from "@pulumi/pulumi";
import * as azure from "@pulumi/azure-native";
import { tenantName, location, resourceGroupName } from "./config";

export interface TenantResult {
  tenantId: pulumi.Output<string | undefined>;
  name: pulumi.Output<string>;
}

export function validateTenantName(name: string): void {
  if (!name || name.trim().length === 0) {
    throw new Error("tenantName config is required and must be non-empty");
  }
  if (!/^[a-zA-Z0-9][a-zA-Z0-9_-]*$/.test(name)) {
    throw new Error(
      "tenantName must start with alphanumeric and contain only alphanumerics, hyphens, and underscores",
    );
  }
}

export function sanitizeDomainName(name: string): string {
  return name.toLowerCase().replace(/[^a-z0-9]/g, "");
}

export function createTenant(): TenantResult {
  validateTenantName(tenantName);

  const resourceGroup = new azure.resources.ResourceGroup(resourceGroupName, {
    location: location,
  });

  const tenant = new azure.azureactivedirectory.B2CTenant("tenant", {
    displayName: tenantName,
    resourceGroupName: resourceGroup.name,
    location: "United States",
    countryCode: "US",
    sku: {
      name: "Standard",
      tier: "A0",
    },
  });

  return {
    tenantId: tenant.tenantId,
    name: tenant.name,
  };
}
