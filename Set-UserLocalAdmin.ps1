# Check for Admin rights, if not Admin, spawn new elevated PowerShell shell
param([switch]$Elevated)

function CheckAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((CheckAdmin) -eq $false) {
    if ($elevated) {
    # could not elevate, quit
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

# Variables
$DomainGroup = "Domain Users" # Domain group added previously to local admins, that the primary user is a member of
$AdminGroup = "Administrators" # Local Administrator group
$Domain = "contoso" # NetBIOS Name such as CONTOSO
$Computer = $env:computername # Current computer
$User = $env:username # Current user

# If the user is not the local admin, add them to the administrators group, and remove the domain group from the administrators group
if ($env:username -notlike "Administrator") {
    # Create session
    $de = [ADSI]"WinNT://$Computer/$AdminGroup,group"

    # Add user to local admins
    try {
        $de.psbase.Invoke("Add",([ADSI]"WinNT://$Domain/$User").path)
        Write-Host "Added" $User "to local Administrators group"
    }
    catch {
        Write-Host $User "is already member of local Administrators group"
    }

    # Remove old admin group from local admins
    try {
        $de.psbase.Invoke("Remove",([ADSI]"WinNT://$Domain/$DomainGroup").path)
        Write-Host "Removed Domain Users from local Administrators group"
    }
    catch {
        Write-Host "Domain Users is not in the local Administrators group"
    }

    # Remove script for current user
    Remove-Item "C:\Users\$User\Set-UserLocalAdmin.ps1"
    Remove-Item "C:\Users\$User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Set-UserLocalAdmin.lnk"

    # Remove script for all future users
    Remove-Item "C:\Users\Default\Set-UserLocalAdmin.ps1"
    Remove-Item "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Set-UserLocalAdmin.lnk"
    
}
else {
    Write-Host "User is Administrator, not adding to local Administrators group"
}

# Close the leftover command window
Stop-Process -Id $PID