# Excessive Runspace Usage Health Check

This health check monitors the number of runspaces that are being used by PowerShell Universal. If the number of runspaces exceeds a certain threshold, the health check will return unhealthy.

## Configuration

Control the threshold for the number of runspaces by setting the `PSUExcessiveRunspaceCount` variable. The default value is 50.

```powershell
$PSUExcessiveRunspaceCount = 50
```