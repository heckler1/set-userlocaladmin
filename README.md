This script adds the first user to login to a machine to the built in Administrators group. It assumes that the new user already has admin rights in the form of the Domain Users (or any other domain group that the primary user is in) group being part of the Administrators group. 

The script is designed to be used on a prepared machine where either an MDT task sequence, or manual prep of the reference image has done the following:
1) Add Domain Users (or any other domain group that the primary user is in) to the local Administrator group
2) Copy the script to the `C:\Users\Default` directory
3) Copy or create a shortcut to the script in `C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`.

The shortcut should have the target `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File C:\Users\%username%\Set-UserLocalAdmin.ps1`

The script performs the following steps:

1) The script adds the current user directly to the local Administrator group.
2) The script removes the domain group from the local Administrator group.
3) It deletes itself from the current profile as well as the Default profile.