import * as pulumi from "@pulumi/pulumi";

pulumi.runtime.setMocks({
  newResource: (args: pulumi.runtime.MockResourceArgs): { id: string; state: Record<string, unknown> } => {
    return {
      id: `${args.name}_id`,
      state: {
        ...args.inputs,
        kubeConfigs: [{ value: "mock-kubeconfig" }],
      },
    };
  },
  call: (args: pulumi.runtime.MockCallArgs): Record<string, unknown> => {
    return args.inputs;
  },
});
