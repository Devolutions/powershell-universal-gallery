import 'antd/dist/reset.css';
import './app/app.css';
import ReactDOM from 'react-dom/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { App } from './app/App';
import { getRuntimeMetadata } from './config/runtime';
import { ensureUniversalDashboardGlobal } from './registry/components';
import { registerBuiltins } from './registry/registerBuiltins';
import { useRuntimeStore } from './state/runtimeStore';

const queryClient = new QueryClient();

ensureUniversalDashboardGlobal();
registerBuiltins();
useRuntimeStore.getState().initializeShell(getRuntimeMetadata());

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <QueryClientProvider client={queryClient}>
    <App />
  </QueryClientProvider>,
);
