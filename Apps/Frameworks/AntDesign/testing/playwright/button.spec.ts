import { test, expect } from './harnessFixture';

test('renders the button component documentation from comment-based help', async ({ page, harness }) => {
  await harness.gotoShell(page);

  await page.getByRole('menuitem', { name: 'Button' }).click();

  await expect(page).toHaveURL(/#\/components\/button/);
  await expect(page.getByRole('heading', { name: 'Button' })).toBeVisible();
  await expect(
    page.getByText(
      'Creates an antd-button descriptor that maps the PowerShell command surface to the core Ant Design Button TypeScript definition used by the client runtime.',
    ),
  ).toBeVisible();
  await expect(page.getByText("New-UDAntDesignButton -Text 'Primary action' -Type primary")).toBeVisible();
  await expect(page.getByText('Creates a primary button that renders an Ant Design icon.')).toBeVisible();
});

test('shows live previews for the documented button examples', async ({ page, harness }) => {
  await harness.gotoShell(page);

  await page.getByRole('menuitem', { name: 'Button' }).click();

  await expect(page.getByRole('button', { name: 'Primary action' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'Delete account' })).toHaveClass(/ant-btn-dangerous/);
  await expect(page.getByRole('link', { name: 'Open Ant Design' })).toHaveAttribute(
    'href',
    'https://ant.design/components/button/',
  );
  await expect(page.getByRole('button', { name: 'Loading' }).locator('.ant-btn-loading-icon')).toBeVisible();
  await expect(page.getByRole('button', { name: 'DownloadOutlined Download' })).toBeVisible();
});