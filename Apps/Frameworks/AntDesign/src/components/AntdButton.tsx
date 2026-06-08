import { Button } from 'antd';
import type { ReactNode } from 'react';
import { renderDescriptorContent } from '../registry/renderDescriptor';
import type { DescriptorContent } from '../types/dashboard';

type AntdButtonProps = {
  content?: DescriptorContent;
  id?: string;
  onClick?: (data: { value: unknown }) => void;
  render?: (component: DescriptorContent) => ReactNode;
  text?: string;
  value?: unknown;
};

export function AntdButton({ content, id, onClick, render, text, value }: AntdButtonProps) {
  return (
    <Button id={id} type="primary" size="large" onClick={() => onClick?.({ value })}>
      {text ?? renderDescriptorContent(content, render)}
    </Button>
  );
}
