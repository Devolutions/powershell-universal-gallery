import { withComponentFeatures } from 'universal-dashboard';
import { AntdButton } from '../components/AntdButton';
import { AntdCheckbox } from '../components/AntdCheckbox';
import { AntdCol } from '../components/AntdCol';
import { AntdDocs } from '../components/AntdDocs';
import { AntdInput } from '../components/AntdInput';
import {
  AntdLayout,
  AntdLayoutContent,
  AntdLayoutFooter,
  AntdLayoutHeader,
  AntdLayoutSider,
} from '../components/AntdLayout';
import { AntdRate } from '../components/AntdRate';
import { AntdRow } from '../components/AntdRow';
import { AntdText } from '../components/AntdText';
import { AntdSwitch } from '../components/AntdSwitch';
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
  registerComponent('antd-checkbox', wrapWithFeatures(AntdCheckbox as RegisteredDashboardComponent));
  registerComponent('antd-col', wrapWithFeatures(AntdCol as RegisteredDashboardComponent));
  registerComponent('antd-docs', wrapWithFeatures(AntdDocs as RegisteredDashboardComponent));
  registerComponent('antd-input', wrapWithFeatures(AntdInput as RegisteredDashboardComponent));
  registerComponent('antd-layout', wrapWithFeatures(AntdLayout as RegisteredDashboardComponent));
  registerComponent('antd-layout-content', wrapWithFeatures(AntdLayoutContent as RegisteredDashboardComponent));
  registerComponent('antd-layout-footer', wrapWithFeatures(AntdLayoutFooter as RegisteredDashboardComponent));
  registerComponent('antd-layout-header', wrapWithFeatures(AntdLayoutHeader as RegisteredDashboardComponent));
  registerComponent('antd-layout-sider', wrapWithFeatures(AntdLayoutSider as RegisteredDashboardComponent));
  registerComponent('antd-rate', wrapWithFeatures(AntdRate as RegisteredDashboardComponent));
  registerComponent('antd-row', wrapWithFeatures(AntdRow as RegisteredDashboardComponent));
  registerComponent('antd-switch', wrapWithFeatures(AntdSwitch as RegisteredDashboardComponent));
  registerComponent('antd-text', wrapWithFeatures(AntdText as RegisteredDashboardComponent));
  registerComponent('antd-typography', wrapWithFeatures(AntdTypography as RegisteredDashboardComponent));
  isRegistered = true;
}
