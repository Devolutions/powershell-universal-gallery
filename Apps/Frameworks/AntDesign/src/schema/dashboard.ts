import { z } from 'zod';
import type { DashboardBootstrap, DashboardDescriptor, EndpointDescriptor } from '../types/dashboard';

export const endpointDescriptorSchema = z
  .object({
    name: z.string(),
    javaScript: z.string().optional(),
    websocket: z.boolean().optional(),
    accept: z.string().optional(),
    contentType: z.string().optional(),
  })
  .catchall(z.unknown()) satisfies z.ZodType<EndpointDescriptor>;

export const dashboardDescriptorSchema = z
  .object({
    type: z.string(),
    id: z.string().optional(),
    content: z.unknown().optional(),
    isPlugin: z.boolean().optional(),
    assetId: z.string().optional(),
  })
  .catchall(z.unknown());

export const dashboardBootstrapSchema = z.object({
  dashboard: dashboardDescriptorSchema,
  sessionId: z.string(),
  pageId: z.string(),
  authType: z.string().optional(),
  roles: z.array(z.string()).optional(),
  user: z.string().optional(),
  idleTimeout: z.number().optional(),
  dashboardName: z.string().optional(),
  developerLicense: z.boolean().optional(),
});

export function parseDashboardBootstrap(payload: unknown): DashboardBootstrap {
  return dashboardBootstrapSchema.parse(payload) as DashboardBootstrap;
}
