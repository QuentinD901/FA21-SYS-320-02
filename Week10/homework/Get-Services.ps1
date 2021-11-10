#Storyline: List Services depending on Status

function select_svc { 

  cls

  # Initialize array + hold status of svc
  $arrSvc = @('all', 'stopped', 'running')

  # Prints options to Screen
  $arrSvc  
  echo "" 

  # Prompt user for the status to view or quit
  $readSvc = read-host -Prompt "Please enter a status from the list above or 'q' to quit the program"

  # Check if user wants to quit
  if ($readSvc -match "^[qQ]$") {
    
    # Stop and Close Script
    break
    
  }

  svc_check -svcToSearch $readSvc

} # end select_svc

function svc_check() {
  
  # String the user types in within the select_svc function
  Param([string]$svcToSearch)

  # Search the array for the exact hashtable string
  if ($arrSvc -match $readSvc) {
    
    Write-Host -BackgroundColor Green -ForegroundColor White "Please Wait, it may take a few minutes to retrieve the services"
    sleep 2

    # Call the function to view the svc
    view_svc -svcToSearch $svcToSearch

  } else {
      Write-Host -BackgroundColor red -ForegroundColor White "The service status specified does not exist."
      Sleep 2
      select_svc
  }
} # ends svc_check()

function view_svc() {

  cls

  # Get the Services
  if ($readSvc -eq 'all') {
    
    Get-Service | Where {$_.status –eq 'running' -OR $_.status –eq 'stopped'}

  }ElseIf ($readSvc -eq 'running') {

    Get-Service | Where {$_.status –eq 'running'}
     
  }ElseIf ($readSvc -eq 'stopped'){

    Get-Service | Where {$_.status –eq 'stopped'}  
  }else { 
    select_svc
  }
    
  # Pause screen and wait funtil user is ready 
  Read-Host -Prompt "Press enter when you are done."

  # Go back to select_svc
  select_svc

} # ends view_svc()
select_svc