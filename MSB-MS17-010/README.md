# MSB-MS17-010

Part of the Collection of CVEs
- CVE-2017-0143
- CVE-2017-0144
- CVE-2017-0145
- CVE-2017-0146
- CVE-2017-0147
- CVE-2017-0148

This bug was present in the May 2017 Cyprtographic Virus Attacks known as 'WannaCry' officially coined as WannaCrypt0r or WannaCrypt. 

## Description
 >  Uses information disclosure to determine if MS17-010 has been patched or not. Specifically, it connects to the IPC$ tree and attempts a transaction on FID 0. If the status returned is "STATUS_INSUFF_SERVER_RESOURCES", the machine does not have the MS17-010 patch. If the machine is missing the MS17-010 patch, the module will check for an existing DoublePulsar (ring 0 shellcode/malware) infection. This module does not require valid SMB credentials in default server configurations. It can log on as the user "\" and connect to IPC$.

## Analysis
This vulnerability seemed to affect SMBv1, SMB was update to v2 in Windows Vista and Windows Server 2008 Systems then v2.1 in Windows 8 and Windows Server 2012. Hence showing that systems still on SMBv1 are vulnerable

## Description of Script
The Powershell Script looks at disabling SMBv1, SMBv2 and SMBv3 is critical to some Windows Services, it does not disable these. Also as MS17-010 was patched up for SMBv1 Devices as shown  in `KB4012598`. 

We disable the user of SMBv1 through:
- SMB Configuration
- SMB Registry Settings
- Disabling use of SMBv1 by the SMB Client
- Removing the Windows Feature which allows the use of SMB
- Block TCP Port 445

WARNING! This Script does not necessarily block the Cryptovirus being installed. Users are recommended to be vigilant and conduct regular back ups.

## Additional Security Measures (USERS ON XP, VISTA, 8 ARE HIGHLY RECOMMENDED TO READ THIS)
Users on the following Machines are recommended to access http://www.catalog.update.microsoft.com/Search.aspx?q=KB4012598 to download the relevant patch that affects `MSB-MS17-010`.


