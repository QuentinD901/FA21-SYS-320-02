# Stroyline: Login to a remote SSH Server

# Clears Screen
cls

# Invoke new connection
New-SSHSession -ComputerName '100.64.10.161' -Credential (Get-Credential)


# Run commands on remote server
while ($true) { 
  
  # Add a prompt 
  $the_cmd = Read-Host -Prompt "Please Enter a Command"
  
  # Run command on remote server
  (Invoke-SSHCommand -index 0 $the_cmd).Output
}
