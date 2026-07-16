
[https://docs.hackerone.com/en/articles/8368965-vdp-vs-bbp#gatsby-focus-wrapper](https://docs.hackerone.com/en/articles/8368965-vdp-vs-bbp#gatsby-focus-wrapper)

[https://www.hacker101.com/resources/articles/code_of_conduct](https://www.hacker101.com/resources/articles/code_of_conduct)

[https://hackerone.com/bug-bounty-programs](https://hackerone.com/bug-bounty-programs)

## Tips

* Target VDPs before Bug Bounties
* Break down complet concepts into manageable pieces and fill the gaps of knowledge

## HackingHub

[https://app.hackinghub.io/hubs](https://app.hackinghub.io/hubs)

[https://hackerone.com/hacktivity/](https://hackerone.com/hacktivity/)

[https://www.nahamsec.com/posts](https://www.nahamsec.com/posts)

[https://samcurry.net/](https://samcurry.net/)

## Code of Conduct
[https://www.hacker101.com/resources/articles/code_of_conduct](https://www.hacker101.com/resources/articles/code_of_conduct)
## Writing a Good Report
[Common Weaknesses Enumeration (CWE)](https://cwe.mitre.org/)

[Common Vulnerability Scoring System (CVSS)](https://www.first.org/cvss/)

[CVSS Base Metrics](https://www.first.org/cvss/specification-document#Base-Metrics)

|||
|---|---|
|`Vulnerability Title`|Including vulnerability type, affected domain/parameter/endpoint, impact etc.|
|`CWE & CVSS score`|For communicating the characteristics and severity of the vulnerability.|
|`Vulnerability Description`|Better understanding of the vulnerability cause.|
|`Proof of Concept (POC)`|Steps to reproduce exploiting the identified vulnerability clearly and concisely.|
|`Impact`|Elaborate more on what an attacker can achieve by fully exploiting the vulnerability. Business impact and maximum damage should be included in the impact statement.|
|`Remediation`|Optional in bug bounty programs, but good to have.|

### Examples
|||
|---|---|
|`Title:`|Cisco ASA Software IKEv1 and IKEv2 Buffer Overflow Vulnerability (CVE-2016-1287)|
|`CVSS 3.1 Score:`|9.8 (Critical)|
|`Attack Vector:`|Network - The Cisco ASA device was exposed to the internet since it was used to facilitate connections to the internal network through VPN.|
|`Attack Complexity:`|Low - All the attacker has to do is execute the available exploit against the device|
|`Privileges Required:`|None - The attack could be executed from an unauthenticated/unauthorized perspective|
|`User Interaction:`|None - No user interaction is required|
|`Scope:`|Unchanged - Although you can use the exploited device as a pivot, you cannot affect other components by exploiting the buffer overflow vulnerability.|
|`Confidentiality:`|High - Successful exploitation of the vulnerability results in unrestricted access in the form of a reverse shell. Attackers have total control over what information is obtained.|
|`Integrity:`|High - Successful exploitation of the vulnerability results in unrestricted access in the form of a reverse shell. Attackers can modify all or critical data on the vulnerable component.|
|`Availability:`|High - Successful exploitation of the vulnerability results in unrestricted access in the form of a reverse shell. Attackers can deny the service to users by powering the device off|

|||
|---|---|
|`Title:`|Stored XSS in an admin panel (Malicious Admin -> Admin)|
|`CVSS 3.1 Score:`|5.5 (Medium)|
|`Attack Vector:`|Network - The attack can be mounted over the internet.|
|`Attack Complexity:`|Low - All the attacker (malicious admin) has to do is specify the XSS payload that is eventually stored in the database.|
|`Privileges Required:`|High - Only someone with admin-level privileges can access the admin panel.|
|`User Interaction:`|None - Other admins will be affected simply by browsing a specific (but regularly visited) page within the admin panel.|
|`Scope:`|Changed - Since the vulnerable component is the webserver and the impacted component is the browser|
|`Confidentiality:`|Low - Access to DOM was possible|
|`Integrity:`|Low - Through XSS, we can slightly affect the integrity of an application|
|`Availability:`|None - We cannot deny the service through XSS|

### Good Report Examples
- [SSRF in Exchange leads to ROOT access in all instances](https://hackerone.com/reports/341876)
- [Remote Code Execution in Slack desktop apps + bonus](https://hackerone.com/reports/783877)
- [Full name of other accounts exposed through NR API Explorer (another workaround of #476958)](https://hackerone.com/reports/520518)
- [A staff member with no permissions can edit Store Customer Email](https://hackerone.com/reports/980511)
- [XSS while logging in using Google](https://hackerone.com/reports/691611)
- [Cross-site Scripting (XSS) on HackerOne careers page](https://hackerone.com/reports/474656)
## Interacting with Organizations/BBP Hosts
- Wait after submitting the bug a reasonable time (check SLAs, do not spam).
- If triage team of that company does not reply, you can contact [Mediation](https://docs.hackerone.com/hackers/hacker-mediation.html).
- If there is disagreement about the severity of the bug, explain it with CVSS and bug bounty policy. Use Mediation as last resort.
## Example: Reporting a Vulnerability
`Title`
`CWE`
`CVSS 3.1 Score`
`Description`
`Impact`
`POC`
`CVSS Score Breakdown`

## Best Tools

#### NMap - [nmap.org](https://nmap.org/)

#### Masscan - [github.com/robertdavidgraham/masscan](https://github.com/robertdavidgraham/masscan)

**subfinder (Subdomains)**

```bash
subfinder -d domain.com -silent -all
subfinder -d domain.com -silent -all | httpx
```

#### Naabu - [github.com/projectdiscovery/naabu](https://github.com/projectdiscovery/naabu)

#### Burp Suite - [portswigger.net/burp](https://portswigger.net/burp)

#### wapiti [https://github.com/wapiti-scanner/wapiti](https://github.com/wapiti-scanner/wapiti)

#### Caido - [caido.io](https://caido.io/)

#### Waymore - [github.com/xnl-h4ck3r/waymore](https://github.com/xnl-h4ck3r/waymore)

#### Waybackurls - [github.com/tomnomnom/waybackurls](https://github.com/tomnomnom/waybackurls)

#### GetallUrl - [github.com/lc/gau](https://github.com/lc/gau)

#### anew - [github.com/tomnomnom/anew](https://github.com/tomnomnom/anew)

#### JSLinkFinder - [github.com/GerbenJavado/LinkFinder](https://github.com/GerbenJavado/LinkFinder)

#### SourceMapper - [github.com/denandz/sourcemapper](https://github.com/denandz/sourcemapper)
