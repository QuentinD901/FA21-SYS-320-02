# StroyLine: Use Get-Process and Get-Service

#Get-Process | Select-Object Status, ProcessName, Path, ID | Export-Csv -Path "C:\Users\Quentin DeGiorgio\Desktop\Champlain\SYS-320\W9\myProcesses.csv" -NoTypeInformation

#Get-Process | Get-Member 

#Get-Service | where { $_.Status -eq "Stopped" }

#List running Processes and output to file
Get-Process | Select-Object ProcessName, Path, ID | Export-Csv -Path  "C:\Users\Quentin DeGiorgio\Desktop\Champlain\SYS-320\W9\myRunningProcesses.csv" -NoTypeInformation

#List running Services and output to file
Get-Service | where { $_.Status -eq "Running" } | Select Name, DisplayName | Export-Csv -Path  "C:\Users\Quentin DeGiorgio\Desktop\Champlain\SYS-320\W9\myRunningServices.csv" -NoTypeInformation