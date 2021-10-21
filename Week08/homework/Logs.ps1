# Storyline: Review the Security Event Logs

# List all the Win Event Logs
Get-EventLog -list

# Prompt allowing user to select the Log
$readLog = Read-Host -Prompt "Please select a log to review from the above list"

# Prompt allowing user to provide a Search Phrase or Word(s)
$readPhrase = Read-Host -Prompt "Please provide a Word or Phrase to filter $readLog Logs"
 
# Directory Info
$myDir = "C:\Users\Quentin DeGiorgio\Desktop\Champlain\SYS-320\$readLog Logs.csv"

# Print the results
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$readPhrase*"} | Export-Csv -NoTypeInformation -Path $myDir
