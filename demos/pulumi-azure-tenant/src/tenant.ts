import * as pulumi from "@pulumi/pulumi";
import * as azure from "@pulumi/azure-native";
import { tenantName, location, resourceGroupName } from "./config";

export function createTenant() {
    try {
        const resourceGroup = new azure.resources.ResourceGroup(resourceGroupName, {
            location: location,
        });

        const tenant = new azure.azureactivedirectory.Tenant("tenant", {
            displayName: tenantName,
            initialDomainName: pulumi.interpolate`${tenantName.toLowerCase().replace(/[^a-z0-9]/g, '')}-${pulumi.getStack()}`,
            resourceGroupName: resourceGroup.name,
            sku: {
                name: "Standard",
            },
        });

        return {
            tenantId: tenant.tenantId,
            domain: tenant.initialDomainName,
        };
    } catch (error) {
        pulumi.log.error(`Failed to create tenant: ${error.message}`);
        throw error;
    }
}
