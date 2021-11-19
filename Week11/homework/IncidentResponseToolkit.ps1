#Storyline: Incident Response Toolkit

#Notes: Started assignment late (not doing again lol). Want to go back and Assign integers to options, so you can type an int or full name of options. 

# Defines where to store CSVs and other Files
function my_Path() {
  cls
  $myPath = read-host -Prompt "Please enter a directory to save the CSVs to (Parent Dir will hold Zip)"
  select_Menu
}

function select_Menu() {
  
  cls

  # Initialize array + hold items
  $arrMenu = @('Create CSV', 'Create Checksums/Zips')

  # Prints options to Screen
  echo "Options"
  echo "-------"
  $arrMenu | Sort-Object 
  echo "" 

  # Prompt user for the status to view or quit
  $readMenu = read-host -Prompt "Please select a menu from the list above or 'q' to quit the program"
  echo ""

  # Check if user wants to quit
  if ($readMenu -match "^[qQ]$") {
    
    # Stop and Close Script
    break
    
  }

  menu_check -menuToSearch $readMenu

}

function menu_check() {
  
  # String the user types in within the select_svc function
  Param([string]$menuToSearch)

  # Search the array for the exact hashtable string
    # Call the function to create the CSV
  if ($readMenu -eq 'Create CSV') {     
    Write-Host -BackgroundColor Green -ForegroundColor White "Please Wait, While Your Request is Processed"
    sleep 2
    
    select_Inc
    
  }ElseIf ($readMenu -eq 'Create Checksums/Zips') {
    Write-Host -BackgroundColor Green -ForegroundColor White "Please Wait, While Your Request is Processed"
    sleep 2

    select_Check     

  }else {
    Write-Host -BackgroundColor red -ForegroundColor White "The Specified Menu Does NOT Exist."
    Sleep 2
    select_Menu
  }
} # ends menu_check()


function select_Inc() { 

  cls

  # Initialize array + hold items
  $arrInc = @('Processes', 'Services', 'TCP Sockets', 'User Accounts', 'Network Adapter', 'Security Events', 'Admins', 'LoggedIn Users', 'Password File Hash', 'All')

  # Prints options to Screen
  echo "Options"
  echo "-------"
  $arrInc | Sort-Object
  echo "" 

  # Prompt user for the status to view or quit
  $readInc = read-host -Prompt "Please enter an option from the list above, 'm' to the Main Menu or 'q' to quit the program"
  echo ""

  # Check if user wants to quit or go back
  if ($readInc -match "^[qQ]$") {
    
    # Stop and Close Script
    break
    
  }Elseif ($readInc -match "^[mM]$") {
    select_Menu
  }

  inc_check -incToSearch $readInc

} # end select_Inc

function select_Check() { 

  cls

  # Initialize array + hold items
  $arrCheck = @('Create CSV Checksums', 'Zip CSVs', 'All')

  # Prints options to Screen
  echo "Options"
  echo "-------"
  $arrCheck | Sort-Object
  echo "" 

  # Prompt user for the status to view or quit
  $readCheck = read-host -Prompt "Please enter an option from the list above, 'm' to the Main Menu or 'q' to quit the program"
  echo ""

  # Check if user wants to quit or go back
  if ($readCheck -match "^[qQ]$") {
    
    # Stop and Close Script
    break
    
  }Elseif ($readCheck -match "^[mM]$") {
    select_Menu
  }

  check_check -checkToSearch $readCheck

} # end select_Inc

function inc_check() {
  
  # String the user types in within the select_svc function
  Param([string]$incToSearch)

  # Search the array for the exact hashtable string
  if ($arrInc -match $readInc) {
    
    Write-Host -BackgroundColor Green -ForegroundColor White "Please Wait, While Your Request is Processed"
    sleep 2

    # Call the function to create the CSV
    view_Inc -incToSearch $incToSearch

  } else {
      Write-Host -BackgroundColor red -ForegroundColor White "The Specified Option Does NOT Exist."
      Sleep 2
      select_Inc
  }
} # ends inc_check()

function check_check() {
  
  # String the user types in within the select_svc function
  Param([string]$checkToSearch)

  # Search the array for the exact hashtable string
  if ($arrCheck -match $readCheck) {
    
    Write-Host -BackgroundColor Green -ForegroundColor White "Please Wait, While Your Request is Processed"
    sleep 2

    # Call the function to create the CSV
    view_Check -checkToSearch $checkToSearch

  } else {
      Write-Host -BackgroundColor red -ForegroundColor White "The Specified Option Does NOT Exist."
      Sleep 2
      select_Inc
  }
} # ends check_check()

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

    Get-FileHash "D:\Champlain\Classes\2021FA\SYS320\passwords.txt" -Algorithm MD5 | Export-Csv -Path  "$myPath\$readInc.csv" -NoTypeInformation

  }ElseIf ($readInc -eq 'All'){

    Get-Process | Select-Object ProcessName, Path, ID | Export-Csv -Path  "$myPath\Processes.csv" -NoTypeInformation
    Get-WmiObject win32_service | Select Name, DisplayName, PathName | Export-Csv -Path  "$myPath\Services.csv" -NoTypeInformation
    Get-NetTCPConnection | Export-Csv -Path  "$myPath\$TCP Sockets.csv" -NoTypeInformation 
    Get-WmiObject win32_UserAccount | Export-Csv -Path  "$myPath\User Accounts.csv" -NoTypeInformation
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Export-Csv -Path  "$myPath\Network Adapter.csv" -NoTypeInformation
    Get-EventLog -LogName Security -Newest 20 | Export-Csv -Path  "$myPath\Security Events.csv" -NoTypeInformation
    Get-LocalGroupMember Administrators | Export-Csv -Path  "$myPath\Admins.csv" -NoTypeInformation
    (Get-WmiObject -ClassName Win32_ComputerSystem).Username | Export-Csv -Path  "$myPath\LoggedIn Users.csv" -NoTypeInformation
    Get-FileHash "D:\Champlain\Classes\2021FA\SYS320\passwords.txt" -Algorithm MD5 | Export-Csv -Path  "$myPath\Password File Hash.csv" -NoTypeInformation  

  }else { 
    select_Inc
  }
  
  # Prompt letting user know of success
  Write-Host -BackgroundColor Green -ForegroundColor White "SUCESSFULLY CREATED!"
  sleep 2

  # Go back to select_Inc
  select_Inc

} #Ends view Inc

function view_Check() {

  cls

  # Create Zips/Files

  If ($readCheck -eq 'Create CSV Checksums'){
    
    Get-ChildItem -path $myPath -Recurse -Force | Get-FileHash -Algorithm MD5 -ErrorAction SilentlyContinue | Sort-Object -Property 'Path' | Export-Csv "$myPath\csvChecksums.csv" -NoTypeInformation 

  }ElseIf ($readCheck -eq 'Zip CSVs'){
  
    Compress-Archive -path $myPath  -DestinationPath "$myPath\..\IncidentCSVs"
    Get-FileHash "$myPath\..\IncidentCSVs.zip" -Algorithm MD5 -ErrorAction SilentlyContinue | Out-File -FilePath "$myPath\..\IncidentCSVsChecksum.txt" -ErrorAction SilentlyContinue

  }ElseIf ($readCheck -eq 'All'){

    Get-ChildItem -path $myPath -Recurse -Force | Get-FileHash -Algorithm MD5 -ErrorAction SilentlyContinue | Sort-Object -Property 'Path' | Export-Csv "$myPath\csvChecksums.csv" -NoTypeInformation 
    Compress-Archive -path $myPath  -DestinationPath "$myPath\..\IncidentCSVs"
    Get-FileHash "$myPath\..\IncidentCSVs.zip" -Algorithm MD5 -ErrorAction SilentlyContinue | Out-File -FilePath "$myPath\..\IncidentCSVsChecksum.txt" -ErrorAction SilentlyContinue
      
  }else { 
    select_Check
   }
  
  #Go back to select_Check
  select_Check
}

my_Path
