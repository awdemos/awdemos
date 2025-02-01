To create a new Azure tenant using Pulumi with TypeScript, you can follow these steps:

## Setting Up the Project

1. Create a new directory for your Pulumi project:

```bash
mkdir pulumi-azure-tenant && cd pulumi-azure-tenant
```

2. Initialize a new Pulumi project using the Azure TypeScript template:

```bash
pulumi new azure-typescript
```

## Writing the Code

Create or modify the `index.ts` file in your project directory with the following code:

```typescript
import * as pulumi from "@pulumi/pulumi";
import * as azure from "@pulumi/azure-native";

const tenantConfiguration = new azure.portal.TenantConfiguration("tenantConfiguration", {
    configurationName: "default",
    properties: {
        enforcePrivateMarkdownStorage: true,
    },
});

const b2cTenant = new azure.azureactivedirectory.B2CTenant("b2cTenant", {
    countryCode: "US",
    displayName: "YourTenantName",
    location: "United States",
    resourceGroupName: "YourResourceGroupName",
    resourceName: "yourtenant.onmicrosoft.com",
    sku: {
        name: azure.azureactivedirectory.B2CResourceSKUName.Standard,
        tier: azure.azureactivedirectory.B2CResourceSKUTier.A0,
    },
});

export const tenantId = b2cTenant.tenantId;
```

## Deploying the Infrastructure

1. Configure your Azure credentials:

```bash
pulumi config set azure-native:clientId <Your_Client_ID>
pulumi config set azure-native:clientSecret <Your_Client_Secret> --secret
pulumi config set azure-native:tenantId <Your_Tenant_ID>
pulumi config set azure-native:subscriptionId <Your_Subscription_ID>
```

2. Deploy your infrastructure:

```bash
pulumi up
```

3. Review the proposed changes and confirm the deployment.

## Monitoring the Deployment

To watch the progress of your Pulumi deployment:

1. Use the Pulumi Console:
   - Log in to the [Pulumi Console](https://app.pulumi.com/)
   - Navigate to your project and stack
   - Watch the live updates of your deployment

2. Use the CLI:
   - The `pulumi up` command will show real-time updates in your terminal
   - For more detailed logs, use the `--verbose` flag:
     ```bash
     pulumi up --verbose
     ```

3. Check Azure Portal:
   - Log in to the [Azure Portal](https://portal.azure.com/)
   - Navigate to your resource group
   - Monitor the creation of your new tenant and related resources

Remember to clean up your resources when you're done by running `pulumi destroy` to avoid unnecessary costs[5][15]. 
MIT License

Citations:
[1] https://tryzero.com/blog/deploying-azure-functions-with-pulumi-and-zero
[2] https://blog.nashtechglobal.com/hands-on-provisioning-an-azure-kubernetes-service-aks-with-pulumi/
[3] https://adorahack.com/how-to-define-your-infrastructure-with-typescript-pulumi
[4] https://www.pulumi.com/tutorials/creating-resources-azure/
[5] https://www.linkedin.com/pulse/getting-started-pulumi-azure-beginners-guide-anil-mahadev-bazyc
[6] https://www.pulumi.com/registry/packages/azure-native/api-docs/portal/gettenantconfiguration/
[7] https://github.com/pulumi/pulumi-azuread/issues/983
[8] https://spacelift.io/blog/azure-infrastructure-as-code
[9] https://www.pulumi.com/registry/packages/azure/installation-configuration/
[10] https://github.com/TechWatching/pulumi-azure-workshop
[11] https://github.com/pulumi/pulumi-azuread
[12] https://drunkcoding.net/posts/az-01-pulumi-setup-developer-account/
[13] https://www.pulumi.com/docs/iac/using-pulumi/continuous-delivery/azure-devops/
[14] https://www.lekman.com/blog/2021/02/poc-to-deploy-pulumi/
[15] https://www.linkedin.com/pulse/getting-started-pulumi-azure-beginners-guide-anil-mahadev-bazyc
[16] https://tjaddison.com/blog/2021/10/deploy-an-azure-ad-protected-app-service-website-with-pulumi/
[17] https://techwatching.dev/posts/azure-ready-github-repository/
[18] https://www.pulumi.com/registry/packages/azure-native/api-docs/portal/tenantconfiguration/
[19] https://www.pulumi.com/registry/packages/azure-native/installation-configuration/
[20] https://www.twingate.com/docs/pulumi-azure
[21] https://www.pulumi.com/registry/packages/azure-native/api-docs/azureactivedirectory/b2ctenant/
[22] https://github.com/pulumi/pulumi-azure/blob/master/sdk/nodejs/role/assignment.ts
[23] https://adorahack.com/how-to-define-your-infrastructure-with-typescript-pulumi
