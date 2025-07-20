New-UDPage -Name "Contacts" -Icon (New-UDIcon -Icon 'Users' -Style @{ marginRight = "10px"}) -Content {
    New-CRMNewContactButton
    New-CRMContactTable
} -AutoInclude