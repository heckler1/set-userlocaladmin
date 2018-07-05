# Set-UserLocalAdmin
This script adds the first user to login to a new Windows installation to the built-in Administrators group. It assumes that the new user already has admin rights in the form of the Domain Users (or any other domain group that the primary user is in) group being part of the Administrators group. 

## Prep
The script is designed to be used on a prepared machine where either an MDT task sequence or manual prep of the reference image has performed the following operations:

1) Add Domain Users (or any other domain group that the primary user is in) to the local Administrator group

2) Copy the script to the `C:\Users\Default` directory

3) Copy or create a shortcut to the script in `C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\`.


If you are manually creating the shortcut, it should have the target: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File C:\Users\%username%\Set-UserLocalAdmin.ps1`

## Use
The Set-UserLocalAdmin script performs the following operations:

1) It adds the current user directly to the local Administrator group.

2) It removes the domain group from the local Administrator group.

3) It deletes itself from the current profile as well as the Default profile.
