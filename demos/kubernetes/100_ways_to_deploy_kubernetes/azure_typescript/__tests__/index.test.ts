import { execSync } from "node:child_process";
import { kubeconfig } from "../index";

describe("Azure AKS TypeScript program", () => {
  it("type-checks without errors", () => {
    expect(() => {
      execSync("npx tsc --noEmit", { stdio: "pipe" });
    }).not.toThrow();
  });

  it("exports a kubeconfig", () => {
    expect(kubeconfig).toBeDefined();
  });
});
