@{
    DashboardScript = Join-Path $HarnessScriptRoot 'dashboard.ps1'
    EndpointRoot = Join-Path $HarnessScriptRoot 'endpoints'
    StaticAssets = @(
        @{
            RequestPath = '/frameworks/ant-design'
            Path = (Join-Path $HarnessScriptRoot '..\..\AntDesign\dist')
        }
    )
    Shell = @{
        Title = 'PSU Framework Harness'
        MountId = 'root'
        Scripts = @('/frameworks/ant-design/assets/antdesign-framework.js')
        Styles = @('/frameworks/ant-design/assets/antdesign-framework.css')
    }
}
