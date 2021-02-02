#******************************************************************************#
# This script will take input of a PC/Server name                              #
# and add your desired Active Directory user to any local security             #
# group on that PC/Server.                                                     #
#                                                                              #
# Check out more: https://github.com/GeekLifeNow                               #
#                 https://geeklifenow.com                                      #
#******************************************************************************# 

$Domain = "geeklifenow.com"
$ServerName = Read-Host "Server"
# LocalGroup is the name of a local group on the the PC/Server
$LocalGroup = "Hyper-V Administrators"
# DomainUser is the name of the Active Directory user to add
$DomainUser = "din.djarin"
([ADSI]"WinNT://$ServerName/$LocalGroup,group").add(([ADSI]"WinNT://$Domain/$DomainUser").path)
Write-Host "$DomainUser has been added to $LocalGroup on $ServerName!"