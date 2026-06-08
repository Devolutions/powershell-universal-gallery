import { defineConfig, devices } from '@playwright/test';
import path from 'node:path';

const harnessUrl = process.env.PSU_HARNESS_URL ?? 'http://127.0.0.1:5057';
const harnessProject = path.join(
  process.cwd(),
  '..',
  'Harness',
  'src',
  'PowerShellUniversal.Frameworks.Harness',
  'PowerShellUniversal.Frameworks.Harness.csproj',
);

export default defineConfig({
  testDir: './testing/playwright',
  fullyParallel: true,
  reporter: 'list',
  use: {
    baseURL: harnessUrl,
    trace: 'on-first-retry',
  },
  webServer: {
    command: `npm run build && dotnet run --project ${JSON.stringify(harnessProject)} --urls ${harnessUrl}`,
    cwd: process.cwd(),
    url: harnessUrl,
    reuseExistingServer: true,
    timeout: 180000,
  },
  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
      },
    },
  ],
});