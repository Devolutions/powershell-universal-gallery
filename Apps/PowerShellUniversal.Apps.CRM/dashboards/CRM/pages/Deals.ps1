New-UDPage -Url "/deals" -Name "Deals" -Content {
    'Hello, world!'
} -AutoInclude -Icon (New-UDIcon -Icon 'DollarSign' -Style @{ marginRight = "18px"})