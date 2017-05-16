# Set Admin Privalages
Set-ExecutionPolicy Unrestricted 

# disable SMBv1 over SMB Configuration
Set-SmbServerConfiguration -EnableSMB1Protocol $false
# disable SMBv1 over Registry
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 -Force

# Disable SMBv1 on SMB Client
sc.exe config lanmanworkstation depend= bowser/mrxsmb20/nsi
sc.exe config mrxsmb10 start= disabled

# Remove Windows Feature
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol

# Disable TCP Port 445
New-NetFirewallRule -DisplayName DontWCry -Direction Outbound -Action Block -protcol tcp -RemotePort 445

# Force Restart Computer
Restart-Computer -Force