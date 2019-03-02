<#
-----------------------------------------------------------------------------------------------------------------------
This simple script restart any given service on a remote Windows server.

You will need to allow PowerShell scripts to run on your local machine:

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6
-----------------------------------------------------------------------------------------------------------------------
#>

Write-Host "Connecting to DocMover Service on GPWFS007..."

# Getting the service on the remote service and setting it to the variable $Service.
$Service = Get-Service -ComputerName RemoteServer -Name "MyFlakyService"

# Restart the service and get verbose output to make sure it indeed does restart.
Restart-Service -InputObject $Service -Verbose
Write-Host "Refreshing service status..."

# This will refresh the $Service variable and go and get the status of the service to ensure that it is running.
$Service.Refresh
Start-Sleep -s 1
$Service

# This keeps the terminal open and prompts the user to close by pressing Enter.
Read-Host -Prompt "Press Enter to exit..."