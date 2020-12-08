# 2020-12-08 Jason Lester
# Based on script found on Internet a few years ago

# This script temporarily disables Internet access during the MDT task sequence
# that you use to generate a custom WIM install file that can have specific
# settings that you want.  You can also generate a new one ever so often to
# roll updates into the custom WIM.  The script prevents Windows Store Apps
# from updating in the background, which breaks the Generalize phase of
# Sysprep.
#
# This needs to be the first step under the State Restore section of your task sequence.
# Set it as a "Run PowerShell Script" step and point it to your MDT script root like:
# %SCRIPTROOT%\Internet-Access.ps1
#
# To turn Internet access back on, add another step right before the Imaging section and
# pass it the -Disable option like:
# %SCRIPTROOT%\Internet-Access.ps1 
# with -Disable in the Paremeters box.
# 
# Update the subnets as needed below

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