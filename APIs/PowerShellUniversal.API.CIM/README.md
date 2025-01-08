# CIM API

The CIM API is a RESTful API that allows you to interact with CIM (WMI). This provides endpoints to query namespaces, classes, and instances. You can also create, update, and delete instances as well as execute methods.

## Endpoints 

### GET /cim/namespace

This endpoint returns a list of namespaces that are available on the system. You can provide an optional `namespace` query parameter to get nested namespaces. This endpoint queries the `root` namespace by default.

```powershell
Invoke-RestMethod -Uri http://localhost:5000/cim/namespace?namespace=root
```

### GET /cim/class

This endpoint returns a list of classes in a namespace. You can provide an optional `namespace` query parameter to specify the namespace to query. This endpoint queries the `root` namespace by default. 

```powershell
Invoke-RestMethod -Uri http://localhost:5000/cim/class?namespace=root
```

### GET /cim/instance/{className}

This endpoint returns a list of instances of a class. You can provide an optional `namespace` query parameter to specify the namespace to query. This endpoint queries the `root` namespace by default. You can also provide a `filter` query parameter to filter the results. Use standard WQL syntax for the filter. Consider encoding with `[Uri]::EscapeDataString` for the filter. Finally, you can provide a `property` query parameter to specify the properties to return. 

```powershell
$filter = [Uri]::EscapeDataString('Name="powershell.exe"')
Invoke-RestMethod -Uri "http://localhost:5000/cim/instance/Win32_Process?namespace=root&filter=$filter&property=Name,ProcessId"
```

### POST /cim/instance/{className}

This endpoint creates an instance of a class. You can provide an optional `namespace` query parameter to specify the namespace to query. This endpoint queries the `root` namespace by default. You must provide a JSON body with the properties of the instance. 

```powershell
$body = @{
    CommandLine = 'powershell.exe'
}

Invoke-RestMethod -Uri "http://localhost:5000/cim/instance/Win32_Process?namespace=root" -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```

### PUT /cim/instance/{className}

This endpoint updates an instance of a class. You can provide an optional `namespace` query parameter to specify the namespace to query. This endpoint queries the `root` namespace by default. You must provide a JSON body with the properties of the instance. A filter is required to specify the instance to update. 

```powershell
$filter = [Uri]::EscapeDataString('Name="testvar"')
$body = @{
    VariableValue = 'test'
}
 
Invoke-RestMethod -Uri "http://localhost:5000/cim/instance/Win32_Environment?namespace=root&filter=$filter" -Method Put -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```

### DELETE /cim/instance/{className}

This endpoint deletes an instance of a class. You can provide an optional `namespace` query parameter to specify the namespace to query. This endpoint queries the `root` namespace by default. A filter is required to specify the instance to delete. 

```powershell
$filter = [Uri]::EscapeDataString('Name="testvar"')
Invoke-RestMethod -Uri "http://localhost:5000/cim/instance/Win32_Environment?namespace=root&filter=$filter" -Method Delete
```

### PUT /cim/method/{className}/{methodName}

This endpoint executes a method on a class. You can provide an optional `namespace` query parameter to specify the namespace to query. This endpoint queries the `root` namespace by default. You must provide a JSON body with the parameters of the method. To execute a static method on a class, not filter is required. If you are executing an instance method, you must provide a filter to specify the instance to execute the method on. 

```powershell
$Filter = [Uri]::EscapeDataString('Name="powershell.exe"')
Invoke-RestMethod -Uri "http://localhost:5000/cim/method/Win32_Process/Terminate?namespace=root&filter=$filter" -Method PUT -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```
