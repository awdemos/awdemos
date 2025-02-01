import * as pulumi from "@pulumi/pulumi";
import { createTenant } from "./tenant";

const tenant = createTenant();

export const tenantId = tenant.tenantId;
export const domain = tenant.domain;
