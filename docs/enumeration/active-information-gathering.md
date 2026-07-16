# Active Information Gathering
Active Recon -> `directly interacts with the target system` 

| Technique                | Description                                                                                   | Example                                                                                                                               | Tools                                                      | Risk of Detection                                                                                                  |
| ------------------------ | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `Port Scanning`          | Identifying open ports and services running on the target.                                    | Using Nmap to scan a web server for open ports like 80 (HTTP) and 443 (HTTPS).                                                        | Nmap, Masscan, Unicornscan                                 | High: Direct interaction with the target can trigger intrusion detection systems (IDS) and firewalls.              |
| `Vulnerability Scanning` | Probing the target for known vulnerabilities, such as outdated software or misconfigurations. | Running Nessus against a web application to check for SQL injection flaws or cross-site scripting (XSS) vulnerabilities.              | Nessus, OpenVAS, Nikto                                     | High: Vulnerability scanners send exploit payloads that security solutions can detect.                             |
| `Network Mapping`        | Mapping the target's network topology, including connected devices and their relationships.   | Using traceroute to determine the path packets take to reach the target server, revealing potential network hops and infrastructure.  | Traceroute, Nmap                                           | Medium to High: Excessive or unusual network traffic can raise suspicion.                                          |
| `Banner Grabbing`        | Retrieving information from banners displayed by services running on the target.              | Connecting to a web server on port 80 and examining the HTTP banner to identify the web server software and version.                  | Netcat, curl                                               | Low: Banner grabbing typically involves minimal interaction but can still be logged.                               |
| `OS Fingerprinting`      | Identifying the operating system running on the target.                                       | Using Nmap's OS detection capabilities (`-O`) to determine if the target is running Windows, Linux, or another OS.                    | Nmap, Xprobe2                                              | Low: OS fingerprinting is usually passive, but some advanced techniques can be detected.                           |
| `Service Enumeration`    | Determining the specific versions of services running on open ports.                          | Using Nmap's service version detection (`-sV`) to determine if a web server is running Apache 2.4.50 or Nginx 1.18.0.                 | Nmap                                                       | Low: Similar to banner grabbing, service enumeration can be logged but is less likely to trigger alerts.           |
| `Web Spidering`          | Crawling the target website to identify web pages, directories, and files.                    | Running a web crawler like Burp Suite Spider or OWASP ZAP Spider to map out the structure of a website and discover hidden resources. | Burp Suite Spider, OWASP ZAP Spider, Scrapy (customisable) | Low to Medium: Can be detected if the crawler's behaviour is not carefully configured to mimic legitimate traffic. |

## Nmap

```bash
# PORT SCANNING WITH NMAP
# Stealth / SYN scanning (by default, send SYN w/o completing TCP handshake so faster)
sudo nmap -sS 10.11.1.220
# TCP scanning (completes 3-way handshake so takes longer)
nmap -sT 10.11.1.220
# UDP scanning
sudo nmap -sU 10.11.1.115
# UDP + TCP
sudo nmap -sS -sU 10.11.1.115
# Network sweeping
nmap -sn 10.11.1.1-254
# Fast simple scan
nmap 10.11.1.111
# Nmap ultra fast
nmap 10.11.1.111 --max-retries 1 --min-rate 1000
# Get open ports
nmap -p - -Pn -n 10.10.10.10
# Comprehensive fast and accurate
nmap --top-ports 200 -sV -n --max-retries 2 -Pn --open -iL ips.txt -oA portscan_active
# Get sV from ports
nmap -pXX,XX,XX,XX,XX -Pn -sV -n 10.10.10.10
# Full complete slow scan with output
nmap -v -A -p- -Pn --script vuln -oA full 10.11.1.111
# Network filtering evasion
nmap --source-port 53 -p 5555 10.11.1.111
    # If work, set IPTABLES to bind this port
    iptables -t nat -A POSTROUTING -d 10.11.1.111 -p tcp -j SNAT --to :53
# Scan for UDP
nmap 10.11.1.111 -sU
nmap -sU -F -Pn -v -d -sC -sV --open --reason -T5 10.11.1.111
# FW evasion
nmap -f <IP>
nmap --mtu 24 <IP>
nmap --data-length 30 <IP>
nmap --source-port 53 <IP>
```

[nmap.md](ports/nmap.md)

## DNS / Subdomain enumeration


```bash
# SSL/TLS Certificates (Type domains to find associated subdomains)
http://crt.sh/
https://ui.ctsearch.entrust.com/ui/ctsearchui
https://github.com/aboul3la/Sublist3r
./sublist3r.py -d domain.com

# DNS Enumeration
host www.megacorpone.com
host -t mx megacorpone.com
host -t txt megacorpone.com
host -t ns megacorpone.com
# Forward Lookup Brute Force
for ip in $(cat list.txt); do host $ip.megacorpone.com; done
https://github.com/danielmiessler/SecLists
# Reverse Lookup Brute Force
for ip in $(seq  50 100); do host 38.100.193.$ip; done | grep -v "not found"
# DNS Zone Transfers
host -l <domain name> <dns server address>
host -l megacorpone.com ns2.megacorpone.com
dig axfr @DNS_SERVER_IP $DNS_NAME_SERVER
# Tools
dnsrecon -d megacorpone.com -t axfr
dnsenum zonetransfer.me
dnsrecon -r <IP_DNS>/24 -n <IP_DNS>   #DNS reverse of all of the addresses
# BE CAREFUL AND DIFFERENTIATE BETWEEN DOMAINS AND SUBDOMAINS, CHECK ALL NAME SERVERS


# USE WFUZZ TO FIND OUT SUBDOMAINS.
----------------------------------------------------------------
COMMAND ==>  wfuzz -c -w /usr/share/seclists//usr/share/seclists/Discovery/DNS --hc 404 --hw 617 -u website.com -H "HOST: FUZZ.website.com"

# USE filter to reach your actual subdomains like below command.
COMMAND  ==> wfuzz -c -w /usr/share/seclists//usr/share/seclists/Discovery/DNS --hc 404 --hw 7873 -u hnpsec.com -H "HOST: FUZZ.hnpsec.com"
```


[dns.md](53-DNS.md)
