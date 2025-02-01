import * as pulumi from "@pulumi/pulumi";

const config = new pulumi.Config();

export const tenantName = config.require("tenantName");
export const location = config.get("location") || "eastus";
export const resourceGroupName = config.get("resourceGroupName") || "myResourceGroup";
