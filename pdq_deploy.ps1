# pdq_deploy.ps1
# Script to connect newly imaged computer to PDQ Deploy and pull down standard applications
# 2020-12-08 Jason Lester
# Based on script provided by PDQ.Com

# Temporarily turn off firewall on workstation being imaged
netsh advfirewall set allprofiles state off 2>&1

# Make sure computer name is registered in AD DNS
ipconfig /registerdns 2>&1

# Run a PowerShell command remotely on PDQ server to flush DNS so it gets the latest entry for workstation being imaged
# Modify the server name, domain, user, and password appropriately.
psexec.exe \\PDQ-Server.(domain) -h -u (domain)\(user) -p (password) -accepteula ipconfig /flushdns 2>&1

# Run a PowerShell command remotely on PDQ server to push all apps in the "MDT Packages" group to the workstation being imaged
# Modify the server name, domain, user, and password appropriately.  Make sure you update the package name to match your environment.
psexec.exe \\PDQ-Server.(domain) -h -u (domain)\(user) -p (password) -accepteula "c:\program files (x86)\Admin Arsenal\PDQ Deploy\pdqdeploy.exe" Deploy -Package "MDT Packages" -Targets $env:COMPUTERNAME 2>&1

# This loop pauses the script until the PDQ Deploy Runner service is finished.  This prevents MDT from continuing until all apps have finished installing.
start-sleep 120
while (test-path "C:\Windows\AdminArsenal\PDQDeployRunner\service-1.lock"){
	start-sleep 30
}