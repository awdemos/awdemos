jest.mock("@pulumi/eks", () => ({
  Cluster: class MockCluster {
    kubeconfig = Promise.resolve("mock-kubeconfig");
  },
}));

import { execSync } from "node:child_process";
import { kubeconfig } from "../index";

describe("AWS EKS TypeScript program", () => {
  it("type-checks without errors", () => {
    expect(() => {
      execSync("npx tsc --noEmit", { stdio: "pipe" });
    }).not.toThrow();
  });

  it("exports a kubeconfig", () => {
    expect(kubeconfig).toBeDefined();
  });
});
