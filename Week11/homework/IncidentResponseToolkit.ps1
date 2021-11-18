#Storyline: Incident Response Toolkit

# Defines where to store CSVs 
function my_Path() {
  cls
  $myPath = read-host -Prompt "Please enter a directory to save the CSVs to"
  select_Inc
}

function select_Inc { 

  cls

  # Initialize array + hold items
  $arrInc = @('Processes', 'Services', 'TCP Sockets', 'User Accounts', 'Network Adapter', 'Security Events', 'Admins', 'LoggedIn Users', 'Password File Hash', 'Create CSV Checksums', 'Zip CSVs')

  # Prints options to Screen
  $arrInc | Sort-Object
  echo "" 

  # Prompt user for the status to view or quit
  $readInc = read-host -Prompt "Please enter an option from the list above or 'q' to quit the program"

  # Check if user wants to quit
  if ($readInc -match "^[qQ]$") {
    
    # Stop and Close Script
    break
    
  }

  inc_check -incToSearch $readInc

} # end select_Inc

function inc_check() {
  
  # String the user types in within the select_svc function
  Param([string]$incToSearch)

  # Search the array for the exact hashtable string
  if ($arrInc -match $readInc) {
    
    Write-Host -BackgroundColor Green -ForegroundColor White "Please Wait, while your CSV is being generated"
    sleep 2

    # Call the function to create the CSV
    view_Inc -incToSearch $incToSearch

  } else {
      Write-Host -BackgroundColor red -ForegroundColor White "The specified option does not exist."
      Sleep 2
      select_Inc
  }
} # ends inc_check()

function view_Inc() {

  cls

  # Create CSVs

  if ($readInc -eq 'Processes') {
    
    Get-Process | Select-Object ProcessName, Path, ID | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'Services') {

    Get-WmiObject win32_service | Select Name, DisplayName, PathName | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation
     
  }ElseIf ($readInc -eq 'TCP Sockets'){

    Get-NetTCPConnection | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation  

  }ElseIf ($readInc -eq 'User Accounts'){

    Get-WmiObject win32_UserAccount | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'Network Adapter'){

    Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'Security Events'){

    Get-EventLog -LogName Security -Newest 20 | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'Admins'){

    Get-LocalGroupMember Administrators | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'LoggedIn Users'){

    (Get-WmiObject -ClassName Win32_ComputerSystem).Username | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'Password File Hash'){

    Get-FileHash "C:\Users\Quentin DeGiorgio\Desktop\Champlain\SYS-320\passwords.txt" -Algorithm MD5 | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'Create CSV Checksums'){
    
    Get-ChildItem -path $myPath -Recurse -Force | Get-FileHash -Algorithm MD5 | Sort-Object -Property 'Path' | Export-Csv "$myPath\csvChecksums.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'Zip CSVs'){
  
    Compress-Archive -path $myPath  -DestinationPath "$myPath\..\IncidentCSVs"
    Get-FileHash "$myPath\..\IncidentCSVs" -Algorithm MD5 | Out-File -FilePath "$myPath\..\IncidentCSVsChecksum.txt"

  }else { 
    select_Inc
  }
  
  # Prompt letting user know of success
  Write-Host -BackgroundColor Green -ForegroundColor White "CSV has been created!"
  sleep 2

  # Go back to select_Inc
  select_Inc

} #Ends view Inc
my_Path