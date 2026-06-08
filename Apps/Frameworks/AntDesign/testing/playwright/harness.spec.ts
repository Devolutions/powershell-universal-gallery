import { test, expect } from './harnessFixture';

test('applies setState and handles download messages through the harness', async ({ page, harness }) => {
  await harness.gotoShell(page);

  await expect(page.getByText('Harness ready')).toBeVisible();
  await expect(page.getByText(/Connection state:/)).toContainText('connected');

  await harness.sendMessage('setState', {
    componentId: 'root-text',
    state: {
      text: 'Updated from Playwright',
    },
  });

  await expect(page.getByText('Updated from Playwright')).toBeVisible();

  await harness.registerDownload('playwright-download', {
    fileName: 'playwright.txt',
    content: 'Playwright generated harness download.',
  });

  const downloadPromise = page.waitForEvent('download');
  await harness.sendMessage('download', {
    id: 'playwright-download',
    fileName: 'playwright.txt',
  });

  const download = await downloadPromise;
  expect(download.suggestedFilename()).toBe('playwright.txt');
});