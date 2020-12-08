## Creates the disable option used by the script
param (
   [Parameter(Mandatory=$False,Position=0)]
   [Switch]$Disable
)
 
## If the Disable command line option is not added, the script adds a Firewall Rule to block traffic on ports 80 (http) and 443 (https).
If (!$Disable)
{
   # Change the subnets to match where your WSUS server is located.  You're disallowing all subnets EXCEPT yours.
   Write-Output "Adding internet block"
   New-NetFirewallRule -DisplayName "Block Outgoing 1" -Enabled True -Direction Outbound -Profile Any -Action Block -Protocol TCP -RemotePort 80,443 -RemoteAddress "1.0.0.0-169.254.0.0"
   New-NetFirewallRule -DisplayName "Block Outgoing 2" -Enabled True -Direction Outbound -Profile Any -Action Block -Protocol TCP -RemotePort 80,443 -RemoteAddress "169.254.1.0-255.255.255.255"
}
 
## If the Disable command line option is added, the script removes the Firewall Rule created above.
If ($Disable)
{
   Write-Output "Removing internet block"
   Get-NetFirewallRule -DisplayName "Block Outgoing 1" | Remove-NetFirewallRule
   Get-NetFirewallRule -DisplayName "Block Outgoing 2" | Remove-NetFirewallRule
}