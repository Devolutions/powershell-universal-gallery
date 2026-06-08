import { useEffect } from 'react';
import { createDashboardHubConnection } from '../../transport/dashboardTransport';
import { useRuntimeStore } from '../../state/runtimeStore';

export function useDashboardConnection() {
  const baseUrl = useRuntimeStore((state) => state.baseUrl);
  const dashboardId = useRuntimeStore((state) => state.dashboardId);
  const pageId = useRuntimeStore((state) => state.pageId);
  const sessionId = useRuntimeStore((state) => state.sessionId);
  const timezone = useRuntimeStore((state) => state.timezone);
  const setConnectionStatus = useRuntimeStore((state) => state.setConnectionStatus);

  useEffect(() => {
    if (!dashboardId || !pageId || !sessionId) {
      return;
    }

    const connection = createDashboardHubConnection({
      baseUrl,
      dashboardId,
      pageId,
      sessionId,
      timezone,
    });

    setConnectionStatus('connecting');

    connection.onreconnecting((error) => {
      setConnectionStatus('reconnecting', error?.message ?? null);
    });

    connection.onreconnected(() => {
      setConnectionStatus('connected');
    });

    connection.onclose((error) => {
      setConnectionStatus('disconnected', error?.message ?? null);
    });

    let isDisposed = false;

    void connection.start().then(
      () => {
        if (!isDisposed) {
          setConnectionStatus('connected');
        }
      },
      (error: unknown) => {
        if (!isDisposed) {
          const message = error instanceof Error ? error.message : 'SignalR connection failed.';
          setConnectionStatus('disconnected', message);
        }
      },
    );

    return () => {
      isDisposed = true;
      setConnectionStatus('disconnected');
      void connection.stop();
    };
  }, [baseUrl, dashboardId, pageId, sessionId, setConnectionStatus, timezone]);
}
