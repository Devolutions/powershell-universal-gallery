# Ant Design Dashboard Framework

This folder scaffolds an alternate PowerShell Universal dashboard framework that keeps the PSU transport and descriptor contract while rendering with Ant Design.

## Design choices

- React, TypeScript, Vite, SignalR, Zustand, Zod, and TanStack Query provide the client runtime foundation.
- `withComponentFeatures` is imported from the published `universal-dashboard` npm package instead of being reimplemented locally.
- Static assets are built into `dist` and exposed through `.universal/publishedFolders.ps1` at `/frameworks/ant-design`.

## Build

```powershell
npm install
npm run build
```

## Module helpers

Importing the PowerShell module exposes:

- `Get-PSUAntDesignFrameworkAssetBasePath`
- `Get-PSUAntDesignFrameworkEntryPoint`
- `New-UDAntDesignText`
- `New-UDAntDesignButton`
- `New-AntDesignDemo`
- `New-AntDesignDemoApp`

The second helper returns deterministic asset paths for the compiled entrypoint.
`New-AntDesignDemo` returns a small set of framework descriptors for smoke testing and demos. `New-AntDesignDemoApp` wraps that content in `New-UDApp` for PSU-hosted use.

## Scope of the scaffold

The current scaffold includes:

- strict TypeScript and Vite build configuration
- a published-folder module layout for PSU
- descriptor schemas and runtime state store
- dashboard bootstrap over `/api/internal/dashboard`
- SignalR connection scaffolding for `/dashboardhub`
- a global component registry plus initial Ant Design components wrapped by `withComponentFeatures`

## Demo usage

```powershell
Import-Module .\Devolutions.PowerShellUniversal.Frameworks.AntDesign.psd1

New-AntDesignDemo
```

Inside PowerShell Universal, you can use:

```powershell
New-AntDesignDemoApp
```

The runtime message handlers beyond bootstrap and connection status are left as the next slice of implementation work.
