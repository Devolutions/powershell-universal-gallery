@{
    DashboardScript = Join-Path $HarnessScriptRoot 'dashboard.ps1'
    EndpointRoot = Join-Path $HarnessScriptRoot '..\Harness\sample\endpoints'
    StaticAssets = @(
        @{
            RequestPath = '/frameworks/ant-design'
            Path = (Join-Path $HarnessScriptRoot 'dist')
        }
    )
    Shell = @{
        Title = 'PSU Framework Harness - Ant Design'
        MountId = 'root'
        Scripts = @('/frameworks/ant-design/assets/antdesign-framework.js')
        Styles = @('/frameworks/ant-design/assets/antdesign-framework.css')
    }
}