mdt_scripts

These are various useful scripts for imaging using Microsoft
Windows MDT.

Internet-Access.ps1 = Temporarily blocks access to all
subnets except yours so that Windows will not update
store apps in the background and prevent sysprep
from generalizing the image properly.

pdq_deploy.ps1 = Uses PDQ Deploy to push out a set
group of packages at the end of the imaging process.  This
script depends on psexec.exe being available on your MDT
server's \scripts directory of the deployment share.
