# StroyLine: Use the WMIobject cmdlet

#Get-WmiObject -Class Win32_service | select Name, PathName, ProcessId

#Get-WmiObject -list | where { $_.Name -ilike "Win32_[n-z]* "} | Sort-Object

#Get-WmiObject -list Win32_Account | Get-Member

Get-WmiObject -Class Win32_NetworkAdapterConfiguration | select IPAddress, DefaultIPGateway, DNSServerSearchOrder, DHCPServer | Sort-Object 