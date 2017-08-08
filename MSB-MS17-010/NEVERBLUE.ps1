# Set Admin Privalages
Set-ExecutionPolicy Unrestricted 
$WINDOWS = (Get-CimInstance Win32_OperatingSystem)
$WIN_VER = $WINDOWS.Version
$WIN_CAP = $WINDOWS.Caption
$WIN_SP = $WINDOWS.ServicePackMajorVersion
$WIN_ARC = $WINDOWS.OSArchitecture

if($WIN_VER -eq 6.2 -and $WIN_ARC -eq 86){
    Write-Host "Windows 8 - 32bit Version Detected!"
    $from = "http://download.windowsupdate.com/c/msdownload/update/software/secu/2017/05/windows8-rt-kb4012598-x86_a0f1c953a24dd042acc540c59b339f55fb18f594.msu"
    $to="C:\temp\"
    Copy-Item $from $to -Recurse -Force

    $updates = @(Get-ChildItem –Path $to -Filter '*.msu')
    if ($updates.Count -ge 1) {
    $updates | % {
        Write-Host "Processing update $($_.Name)."
        & wusa $_.FullName /quiet /norestart
    }
    } else {
        Write-Host 'No updates found.'
    }
} elseif ($WIN_VER -eq 6.2 -and $WIN_ARC -eq 64) {
    if($WIN_CAP -eq "Windows Server 2012"){
        Write-Host "Windows Server 2012 - 64bit Version Detected!"
        $from = "http://download.windowsupdate.com/c/msdownload/update/software/secu/2017/02/windows8-rt-kb4012214-x64_b14951d29cb4fd880948f5204d54721e64c9942b.msu"
        $to="C:\temp\"
        Copy-Item $from $to -Recurse -Force

        $updates = @(Get-ChildItem –Path $to -Filter '*.msu')
        if ($updates.Count -ge 1) {
        $updates | % {
            Write-Host "Processing update $($_.Name)."
            & wusa $_.FullName /quiet /norestart
        }
        } else {
            Write-Host 'No updates found.'
        }
        $from = "http://download.windowsupdate.com/d/msdownload/update/software/secu/2017/03/windows8-rt-kb4012217-x64_96635071602f71b4fb2f1a202e99a5e21870bc93.msu"
        $to="C:\temp\"
        Copy-Item $from $to -Recurse -Force

        $updates = @(Get-ChildItem –Path $to -Filter '*.msu')
        if ($updates.Count -ge 1) {
        $updates | % {
            Write-Host "Processing update $($_.Name)."
            & wusa $_.FullName /quiet /norestart
        }
        } else {
            Write-Host 'No updates found.'
        }
    } else {
        Write-Host "Windows 8 - 64bit Version Detected!"
        $from = "http://download.windowsupdate.com/c/msdownload/update/software/secu/2017/05/windows8-rt-kb4012598-x64_f05841d2e94197c2dca4457f1b895e8f632b7f8e.msu"
        $to="C:\temp\"
        Copy-Item $from $to -Recurse -Force

        $updates = @(Get-ChildItem –Path $to -Filter '*.msu')
        if ($updates.Count -ge 1) {
        $updates | % {
            Write-Host "Processing update $($_.Name)."
            & wusa $_.FullName /quiet /norestart
        }
        } else {
            Write-Host 'No updates found.'
        }
    }
}

# disable SMBv1 over SMB Configuration
Set-SmbServerConfiguration -EnableSMB1Protocol $false
# disable SMBv1 over Registry
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 -Force

# Disable SMBv1 on SMB Client
sc.exe config lanmanworkstation depend= bowser/mrxsmb20/nsi
sc.exe config mrxsmb10 start= disabled

# Remove Windows Feature
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol

# Set SMB to Use Encrypted Shares
Set-SmbServerConfiguration -EncryptData $true
# Enforce Encrypted SMB Access Only
Set-SmbServerConfiguration –RejectUnencryptedAccess $false

# Disable TCP Port 445
New-NetFirewallRule -DisplayName DontWCry -Direction Outbound -Action Block -protcol tcp -RemotePort 445
# Block TCP Port 139
New-NetFirewallRule -DisplayName DontWCry -Direction Outbound -Action Block -protcol tcp -RemotePort 139

# Force Restart Computer
Restart-Computer -Force


  