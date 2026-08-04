import * as pulumi from "@pulumi/pulumi";

process.env.PULUMI_CONFIG = JSON.stringify({
  "project:tenantName": "testtenant",
  "project:location": "eastus",
});

pulumi.runtime.setMocks({
  newResource: (args: pulumi.runtime.MockResourceArgs): { id: string; state: Record<string, unknown> } => {
    const state: Record<string, unknown> = { ...args.inputs };
    if (args.type === "azure-native:azureactivedirectory:B2CTenant") {
      state.tenantId = "00000000-0000-0000-0000-000000000000";
      state.name = "mytenant-dev";
    }
    return {
      id: `${args.name}_id`,
      state,
    };
  },
  call: (args: pulumi.runtime.MockCallArgs): Record<string, unknown> => {
    return args.inputs;
  },
});
