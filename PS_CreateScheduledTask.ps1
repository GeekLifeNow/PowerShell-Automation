#============================================================================================#
# This script does the following:                                                            #
#                                                                                            #
# 1. Prompts for the password for the "user_account" account                                 #
# 2. Sets up a scheduled task that runs YourScript.ps1 in \\SERVER\SHARE                     #
# 3. Sets the task to run at 00:00:00 daily and repeat every 20 min for 24 hrs               #
# 4. Runs as domain user: "user_account" without logon and with highest privileges           #
#============================================================================================#

$STName = "Some Task"
$STDescription = "A task that will live in infamy!"
$STAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File \\SERVER\SHARE\YourScript.ps1"
$STTrigger = New-ScheduledTaskTrigger -Daily -At 12am
$STSettings = New-ScheduledTaskSettingsSet
$STUserName = "user_account"

# This section harvests the password for "user_account". You can remove the -UserName parameter if you want to have user input a specific username.

$STCredentials = Get-Credential -UserName $STUserName -Message "Enter password"
$STPassword = $STCredentials.GetNetworkCredential().Password

# This section actually sets up the scheduled task. It then sleeps before editing the trigger details that follow.

Register-ScheduledTask -TaskName $STName -Description $STDescription -Action $STAction -Trigger $STTrigger -User $STUserName -Password $STPassword -RunLevel Highest -Settings $STSettings
Start-Sleep -Seconds 3

# This section sets the repeat interval/duration after the task is created. Has to be set as a separate command when using the New-ScheduledTaskTrigger -Daily parameter

$STModify = Get-ScheduledTask -TaskName $STName
$STModify.Triggers.repetition.Duration = 'P1D'
$STModify.Triggers.repetition.Interval = 'PT20M'
$STModify | Set-ScheduledTask -User $STUserName -Password $STPassword