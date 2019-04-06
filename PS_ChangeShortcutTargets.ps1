# Start Script
[string]$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

#--------------------------------------#
# This function writes to the log file #
#--------------------------------------#
function Write-Log {
    <#
    .SYNOPSIS
       Write to a log file with a date-time stamp
    .DESCRIPTION
       This function writes to a logfile. It defaults to the one stored in the logfile variable
    .EXAMPLE
       Write-Log -Text "This is the start of the script log"
    #>
    Param(
    [string]$Text,
    [string]$Path=$LogFile
    )
    If ($Path){
    If (!(Test-path $Path)){
    Add-Content $Path "$(Get-Date -Format G)   Current User: $env:Username" -Encoding UTF8
    Add-Content $Path "$(Get-Date -Format G)   Computer: $env:Computername" -Encoding UTF8
                Add-Content $Path "$(Get-Date -Format G)   Running script from folder: $ScriptPath"
                Add-Content $Path "$(Get-Date -Format G)   __________________________________________________"
    }
    If ($Text) {Add-Content $Path "$(Get-Date -Format G)   $Text" -Encoding UTF8}
    }Else{
    write-error "No Log file specified"
    Exit
    }
}

$LogFile = "C:\Path2Logfile\Log.txt"
$Computers = Get-Content -Path C:\Scripts\computers.csv
$Shell = New-Object -ComObject WScript.Shell
$NewTarget = "https://geeklifenow.com/"

foreach ($Computer in $Computers) {
    $Online = Test-Connection -BufferSize 16 -Count 2 -ComputerName $Computer -Quiet
    try {
        if ($Online -eq $true) {
            try {
                $ShortcutToChange = Get-ChildItem -Path \\$Computer\C$\Users\Public\Desktop -ErrorAction Stop | Where-Object { $_.Extension -eq ".url" -and $_.Name -like '*web*' }
            }
            catch {
                $ErrorMessage = $_.Exception.Message
                Write-Log -Text "WARNING: $Computer is online, but error getting to the Public\Desktop! Error: $ErrorMessage"
                Continue
            }
            if ($ShortcutToChange.Length -ne 0) {
                try {
                    $url = $shell.CreateShortcut($ShortcutToChange.FullName)
                    $url.TargetPath = $NewTarget
                    $url.Save()
                    Write-Log -Text "SUCCESS: $Computer's GeekLifeNow link was successfully modified!"
                }
                catch {
                    $ErrorMessage = $_.Exception.Message
                    Write-Log -Text "WARNING: Error saving new GeekLifeNow link: $ErrorMessage"                    
                }
            }
            else {
                Write-Log -Text "$Computer does NOT have a GeekLifeNow link. Nothing to see here..."
            }
        }
        else {
            Write-Log -Text "WARNING: $Computer is offline."
        }
        }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Log -Text "ERROR: Error connecting to $Computer : $ErrorMessage"
    }
}