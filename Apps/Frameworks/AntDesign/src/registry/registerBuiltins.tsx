import { withComponentFeatures } from 'universal-dashboard';
import { AntdButton } from '../components/AntdButton';
import { AntdDocs } from '../components/AntdDocs';
import { AntdText } from '../components/AntdText';
import { AntdTypography } from '../components/AntdTypography';
import { registerComponent, type RegisteredDashboardComponent } from './components';

let isRegistered = false;

function wrapWithFeatures(component: RegisteredDashboardComponent): RegisteredDashboardComponent {
  return withComponentFeatures(component) as RegisteredDashboardComponent;
}

export function registerBuiltins() {
  if (isRegistered) {
    return;
  }

  registerComponent('antd-button', wrapWithFeatures(AntdButton as RegisteredDashboardComponent));
  registerComponent('antd-docs', wrapWithFeatures(AntdDocs as RegisteredDashboardComponent));
  registerComponent('antd-text', wrapWithFeatures(AntdText as RegisteredDashboardComponent));
  registerComponent('antd-typography', wrapWithFeatures(AntdTypography as RegisteredDashboardComponent));
  isRegistered = true;
}
