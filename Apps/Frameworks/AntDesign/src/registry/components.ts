import type { ComponentType } from 'react';

export type RegisteredDashboardComponent = ComponentType<Record<string, unknown>>;

type UniversalDashboardGlobal = {
  register: (type: string, component: RegisteredDashboardComponent) => void;
};

declare global {
  interface Window {
    UniversalDashboard?: UniversalDashboardGlobal;
  }
}

const componentRegistry = new Map<string, RegisteredDashboardComponent>();

let globalInitialized = false;

export function registerComponent(type: string, component: RegisteredDashboardComponent) {
  componentRegistry.set(type, component);
}

export function getRegisteredComponent(type: string) {
  return componentRegistry.get(type);
}

export function ensureUniversalDashboardGlobal() {
  if (globalInitialized) {
    return;
  }

  const globalApi: UniversalDashboardGlobal = {
    register: (type, component) => {
      componentRegistry.set(type, component);
    },
  };

  window.UniversalDashboard = globalApi;
  globalInitialized = true;
}
