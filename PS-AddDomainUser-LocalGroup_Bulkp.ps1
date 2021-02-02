#******************************************************************************#
# This script will take a listing of PC/Server names fed via a .txt file       #
# and add your desired Active Directory user to any local security             #
# group on that PC/Server.                                                     #
#                                                                              #
# Check out more: https://github.com/GeekLifeNow                               #
#                 https://geeklifenow.com                                      #
#******************************************************************************# 

$Domain = "geeklifenow.com"
$ServerNames = Get-Content -Path C:\HostGroups\YourHosts.txt
# LocalGroup is the name of a local group on the the PC/Server
$LocalGroup = "Hyper-V Administrators"
# DomainUser is the name of the Active Directory user to add
$DomainUser = "din.djarin"

# Work through the .txt file of host names and add DomainGroup to LocalGroup
foreach ($ServerName in $ServerNames) {
    ([ADSI]"WinNT://$ServerName/$LocalGroup,group").add(([ADSI]"WinNT://$Domain/$DomainGroup").path)
    Write-Host "$DomainUser has been added to $LocalGroup on $ServerName!"
}
