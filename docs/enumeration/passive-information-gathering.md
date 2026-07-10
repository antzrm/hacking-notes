# Passive Information Gathering
Passive Recon -> `without directly interacting` with the target. This relies on analysing publicly available information and resources, such as:

| Technique               | Description                                                                                                                     | Example                                                                                                                                           | Tools                                                                   | Risk of Detection                                                                                      |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `Search Engine Queries` | Utilising search engines to uncover information about the target, including websites, social media profiles, and news articles. | Searching Google for "`[Target Name] employees`" to find employee information or social media profiles.                                           | Google, DuckDuckGo, Bing, and specialised search engines (e.g., Shodan) | Very Low: Search engine queries are normal internet activity and unlikely to trigger alerts.           |
| `WHOIS Lookups`         | Querying WHOIS databases to retrieve domain registration details.                                                               | Performing a WHOIS lookup on a target domain to find the registrant's name, contact information, and name servers.                                | whois command-line tool, online WHOIS lookup services                   | Very Low: WHOIS queries are legitimate and do not raise suspicion.                                     |
| `DNS`                   | Analysing DNS records to identify subdomains, mail servers, and other infrastructure.                                           | Using `dig` to enumerate subdomains of a target domain.                                                                                           | dig, nslookup, host, dnsenum, fierce, dnsrecon                          | Very Low: DNS queries are essential for internet browsing and are not typically flagged as suspicious. |
| `Web Archive Analysis`  | Examining historical snapshots of the target's website to identify changes, vulnerabilities, or hidden information.             | Using the Wayback Machine to view past versions of a target website to see how it has changed over time.                                          | Wayback Machine                                                         | Very Low: Accessing archived versions of websites is a normal activity.                                |
| `Social Media Analysis` | Gathering information from social media platforms like LinkedIn, Twitter, or Facebook.                                          | Searching LinkedIn for employees of a target organisation to learn about their roles, responsibilities, and potential social engineering targets. | LinkedIn, Twitter, Facebook, specialised OSINT tools                    | Very Low: Accessing public social media profiles is not considered intrusive.                          |
| `Code Repositories`     | Analysing publicly accessible code repositories like GitHub for exposed credentials or vulnerabilities.                         | Searching GitHub for code snippets or repositories related to the target that might contain sensitive information or code vulnerabilities.        | GitHub, GitLab                                                          | Very Low: Code repositories are meant for public access, and searching them is not suspicious.         |


```bash
#WHOIS
whois domain.com
whois $IP
#Google Hacking
site: domain.com -filetype:php
https://www.exploit-db.com/google-hacking-database
#Netcraft
https://www.netcraft.com/
#Recon-ng
https://github.com/lanmaster53/recon-ng/wiki/Features#module-marketplace
#Open-Source Code
GitHub, GitLab and SourceForge
For bigger repositories, Gitrob or Gitleaks 
https://help.github.com/en/github/searching-for-information-on-github/searching-code
#Shodan
# NSLOOKUP
nslookup mail.domain.com
nslookup -type=TXT info.domain.com $IP

#Security Headers Scanner
https://securityheaders.com/
#SSL Server Test
https://www.ssllabs.com/ssltest/
#Pastebin
https://pastebin.com/
#Email Harvesting
theharvester -d domain.com -b google
#Password Dumps
https://haveibeenpwned.com/PwnedWebsites
#Social Media Tools
https://www.social-searcher.com/
https://digi.ninja/projects/twofi.php
https://github.com/initstring/linkedin2username
#Stack Overflow
https://stackoverflow.com/
#Information Gathering Frameworks
https://osintframework.com/
https://www.paterva.com/buy/maltego-clients.php
```

## OSINT

[osint.md](../misc/osint.md)

## Google Dorks / Google Fu

[https://www.blackhat.com/presentations/bh-europe-05/BH\_EU\_05-Long.pdf](https://www.blackhat.com/presentations/bh-europe-05/BH_EU_05-Long.pdf)

![](../assets/image (16).png)

For example, if a vulnerability came out with a WordPress plugin, I would find the filename of the plugin and use **inurl:file\_used\_by\_plugin.php** and see how many websites could be affected by this vulnerability. I would then build a list of websites that offer bug bounties or take part in programs like Synack and then check if any of those sites appear on the list.

Using **-site:website.com** will make sure that the website does not appear on your search results

before: and after: / after is good to search for newest and more advanced exploits

```sh
# Examples
intitile: # search page title
site: microsoft.com -site:www.microsoft.com
inurl:10000 webmin # port scanning
inurl:$PORT -intext:$PORT
filetype:inc intext:mysql_connect
filetype:sql + "IDENTIFIED BY" -cvs
```


[https://teddit.net/r/oscp/comments/nm4a36/dorks\_to\_aid\_enumeration\_exploitation/](https://teddit.net/r/oscp/comments/nm4a36/dorks_to_aid_enumeration_exploitation/)

[http://google.com/advanced\_search](http://google.com/advanced_search)

[Pentest-Tools google hacking page](https://pentest-tools.com/information-gathering/google-hacking)

[dork scanner](https://github.com/madhavmehndiratta/dorkScanner)

[Pagodo](https://awesomeopensource.com/project/opsdisk/pagodo)

[GoogleDorker](https://awesomeopensource.com/project/nerrorsec/GoogleDorker)

[refine your Google searches here](https://support.google.com/websearch/answer/2466433)

[https://yewtu.be/watch?v=lESeJ3EViCo](https://yewtu.be/watch?v=lESeJ3EViCo)
