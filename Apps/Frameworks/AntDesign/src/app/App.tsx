import { Alert, App as AntdApp, Layout, Spin, Typography } from 'antd';
import { ErrorBoundary } from 'react-error-boundary';
import { useEffect } from 'react';
import { useBootstrap } from '../features/bootstrap/useBootstrap';
import { useDashboardConnection } from '../features/transport/useDashboardConnection';
import { renderDescriptorNode } from '../registry/renderDescriptor';
import { useRuntimeStore } from '../state/runtimeStore';

function BootstrapStatus() {
  const bootstrapQuery = useBootstrap();
  const setBootstrap = useRuntimeStore((state) => state.setBootstrap);
  const descriptorTree = useRuntimeStore((state) => state.descriptorTree);
  const connectionStatus = useRuntimeStore((state) => state.connectionStatus);
  const transportError = useRuntimeStore((state) => state.transportError);

  useEffect(() => {
    if (bootstrapQuery.data) {
      setBootstrap(bootstrapQuery.data);
    }
  }, [bootstrapQuery.data, setBootstrap]);

  useDashboardConnection();

  if (bootstrapQuery.isLoading) {
    return (
      <div className="shell-state">
        <Spin size="large" />
        <Typography.Text>Bootstrapping dashboard contract...</Typography.Text>
      </div>
    );
  }

  if (bootstrapQuery.error) {
    return (
      <Alert
        type="error"
        message="Bootstrap failed"
        description={bootstrapQuery.error.message}
        showIcon
      />
    );
  }

  if (!descriptorTree) {
    return (
      <Alert
        type="warning"
        message="No descriptor tree"
        description="The bootstrap response completed but did not include a dashboard descriptor."
        showIcon
      />
    );
  }

  return (
    <Layout className="shell-layout">
      <Layout.Header className="shell-header">
        <div>
          <Typography.Title level={3}>PSU Ant Design Framework</Typography.Title>
          <Typography.Paragraph>
            Connection state: <strong>{connectionStatus}</strong>
          </Typography.Paragraph>
        </div>
        {transportError ? <Alert type="warning" message={transportError} banner /> : null}
      </Layout.Header>
      <Layout.Content className="shell-content">{renderDescriptorNode(descriptorTree)}</Layout.Content>
    </Layout>
  );
}

function ErrorFallback({ error }: { error: Error }) {
  return <Alert type="error" message="Framework render failed" description={error.message} showIcon />;
}

export function App() {
  return (
    <AntdApp>
      <ErrorBoundary FallbackComponent={ErrorFallback}>
        <BootstrapStatus />
      </ErrorBoundary>
    </AntdApp>
  );
}
