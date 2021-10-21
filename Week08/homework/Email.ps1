# Storyline: Send an Email

# Email Body
$msg = "Top of the mornin'"

# Write to Screen
Write-Host -BackgroundColor Red -ForegroundColor White $msg

# From Address
$fmail = "quentin.degiorgio@mymail.champlain.edu"

# Reciever Address
$remail = "deployer@csi-web"

# Send Email
Send-MailMessage -From $fmail -To $remail -Subject "Greetings" -Body $msg -SmtpServer 192.168.6.71