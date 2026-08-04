import { createTenant } from "./tenant";

const tenant = createTenant();

export const tenantId = tenant.tenantId;
export const name = tenant.name;
