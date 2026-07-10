# OSINT

![](../assets/image (17).png)

![](../assets/image (141).png)

![](../assets/image (142).png)

[phonebook.cz](https://phonebook.cz/)

[Ahmia.fi](https://ahmia.fi/) is a search engine specifically for finding sites on the Tor Network, although the search engine itself is accessible on the “clearnet.” But you will need the [Tor Browser](https://www.torproject.org/download/) in order to open your Tor search results.

[Wayback Machine](https://archive.org/web/)

Check out OSINT tools on the security podcast "Privacy Security and OSINT" my Michael Bazzell and website check out [https://inteltechniques.com/blog/](https://inteltechniques.com/blog/) or [https://www.trustedsec.com/blog/upgrade-your-workflow-part-1-building-osint-checklists/](https://www.trustedsec.com/blog/upgrade-your-workflow-part-1-building-osint-checklists/) or [https://medium.com/@hunchly/bulk-extracting-exif-metadata-with-hunchly-and-exiftool-164d67c8d7e2](https://medium.com/@hunchly/bulk-extracting-exif-metadata-with-hunchly-and-exiftool-164d67c8d7e2) I know of Exiftool and imagemagick. I personally wouldn't use something that doesn't run locally. I like Hunchly but I don't think it's free.

## Basic Google Dorking
`site:example[.]com ext:log | ext:txt | ext:conf | ext:cnf | ext:ini | ext:env | ext:sh | ext:bak | ext:backup | ext:swp | ext:old | ext:~ | ext:git | ext:svn | ext:htpasswd | ext:htaccess | ext:json`


## Certificate Transparency Logs
> `Certificate Transparency` (`CT`) logs are public, append-only ledgers that record the issuance of SSL/TLS certificates. Whenever a Certificate Authority (CA) issues a new certificate, it must submit it to multiple CT logs. Independent organisations maintain these logs and are open for anyone to inspect.

Think of CT logs as a `global registry of certificates`. They provide a transparent and verifiable record of every SSL/TLS certificate issued for a website.

| Tool                                | Key Features                                                                                                     | Use Cases                                                                                                 | Pros                                              | Cons                                         |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------- | -------------------------------------------- |
| [crt.sh](https://crt.sh/)           | User-friendly web interface, simple search by domain, displays certificate details, SAN entries.                 | Quick and easy searches, identifying subdomains, checking certificate issuance history.                   | Free, easy to use, no registration required.      | Limited filtering and analysis options.      |
| [Censys](https://search.censys.io/) | Powerful search engine for internet-connected devices, advanced filtering by domain, IP, certificate attributes. | In-depth analysis of certificates, identifying misconfigurations, finding related certificates and hosts. | Extensive data and filtering options, API access. | Requires registration (free tier available). |

```sh
# find all 'dev' subdomains on `facebook.com` using `curl` and `jq`
curl -s "https://crt.sh/?q=facebook.com&output=json" | jq -r '.[] | select(.name_value | contains("dev")) | .name_value' | sort -u
```

## Fingerprinting

|Tool|Description|Features|
|---|---|---|
|`Wappalyzer`|Browser extension and online service for website technology profiling.|Identifies a wide range of web technologies, including CMSs, frameworks, analytics tools, and more.|
|`BuiltWith`|Web technology profiler that provides detailed reports on a website's technology stack.|Offers both free and paid plans with varying levels of detail.|
|`WhatWeb`|Command-line tool for website fingerprinting.|Uses a vast database of signatures to identify various web technologies.|
|`Nmap`|Versatile network scanner that can be used for various reconnaissance tasks, including service and OS fingerprinting.|Can be used with scripts (NSE) to perform more specialised fingerprinting.|
|`Netcraft`|Offers a range of web security services, including website fingerprinting and security reporting.|Provides detailed reports on a website's technology, hosting provider, and security posture.|
|`wafw00f`|Command-line tool specifically designed for identifying Web Application Firewalls (WAFs).|Helps determine if a WAF is present and, if so, its type and configuration.|
```sh
wafw00f inlanefreight.com
# -Tuning b flag tells `Nikto` to only run the Software Identification modules
nikto -h inlanefreight.com -Tuning b
```


## Well-Known URIs
> The `.well-known` standard, defined in [RFC 8615](https://datatracker.ietf.org/doc/html/rfc8615), serves as a standardized directory within a website's root domain. This designated location, typically accessible via the `/.well-known/` path on a web server, centralizes a website's critical metadata, including configuration files and information related to its services, protocols, and security mechanisms.

/.well-known/URI_SUFFIX

| URI Suffix                     | Description                                                                                           | Status      | Reference                                                                               |
| ------------------------------ | ----------------------------------------------------------------------------------------------------- | ----------- | --------------------------------------------------------------------------------------- |
| `security.txt`                 | Contains contact information for security researchers to report vulnerabilities.                      | Permanent   | RFC 9116                                                                                |
| `/.well-known/change-password` | Provides a standard URL for directing users to a password change page.                                | Provisional | https://w3c.github.io/webappsec-change-password-url/#the-change-password-well-known-uri |
| `openid-configuration`         | Defines configuration details for OpenID Connect, an identity layer on top of the OAuth 2.0 protocol. | Permanent   | http://openid.net/specs/openid-connect-discovery-1_0.html                               |
| `assetlinks.json`              | Used for verifying ownership of digital assets (e.g., apps) associated with a domain.                 | Permanent   | https://github.com/google/digitalassetlinks/blob/master/well-known/specification.md     |
| `mta-sts.txt`                  | Specifies the policy for SMTP MTA Strict Transport Security (MTA-STS) to enhance email security.      |             |                                                                                         |
## Crawlers
```sh
# Firs install Scrapy
pip3 install scrapy
# Then ReconSpider tool
wget -O ReconSpider.zip https://academy.hackthebox.com/storage/modules/144/ReconSpider.v1.2.zip
unzip ReconSpider.zip 
python3 ReconSpider.py http://inlanefreight.com
# After running ReconSpider.py, the data will be saved in a JSON file, results.json
```

## Search Engine Discovery

|Operator|Operator Description|Example|Example Description|
|:--|:--|:--|:--|
|`site:`|Limits results to a specific website or domain.|`site:example.com`|Find all publicly accessible pages on example.com.|
|`inurl:`|Finds pages with a specific term in the URL.|`inurl:login`|Search for login pages on any website.|
|`filetype:`|Searches for files of a particular type.|`filetype:pdf`|Find downloadable PDF documents.|
|`intitle:`|Finds pages with a specific term in the title.|`intitle:"confidential report"`|Look for documents titled "confidential report" or similar variations.|
|`intext:` or `inbody:`|Searches for a term within the body text of pages.|`intext:"password reset"`|Identify webpages containing the term “password reset”.|
|`cache:`|Displays the cached version of a webpage (if available).|`cache:example.com`|View the cached version of example.com to see its previous content.|
|`link:`|Finds pages that link to a specific webpage.|`link:example.com`|Identify websites linking to example.com.|
|`related:`|Finds websites related to a specific webpage.|`related:example.com`|Discover websites similar to example.com.|
|`info:`|Provides a summary of information about a webpage.|`info:example.com`|Get basic details about example.com, such as its title and description.|
|`define:`|Provides definitions of a word or phrase.|`define:phishing`|Get a definition of "phishing" from various sources.|
|`numrange:`|Searches for numbers within a specific range.|`site:example.com numrange:1000-2000`|Find pages on example.com containing numbers between 1000 and 2000.|
|`allintext:`|Finds pages containing all specified words in the body text.|`allintext:admin password reset`|Search for pages containing both "admin" and "password reset" in the body text.|
|`allinurl:`|Finds pages containing all specified words in the URL.|`allinurl:admin panel`|Look for pages with "admin" and "panel" in the URL.|
|`allintitle:`|Finds pages containing all specified words in the title.|`allintitle:confidential report 2023`|Search for pages with "confidential," "report," and "2023" in the title.|
|`AND`|Narrows results by requiring all terms to be present.|`site:example.com AND (inurl:admin OR inurl:login)`|Find admin or login pages specifically on example.com.|
|`OR`|Broadens results by including pages with any of the terms.|`"linux" OR "ubuntu" OR "debian"`|Search for webpages mentioning Linux, Ubuntu, or Debian.|
|`NOT`|Excludes results containing the specified term.|`site:bank.com NOT inurl:login`|Find pages on bank.com excluding login pages.|
|`*` (wildcard)|Represents any character or word.|`site:socialnetwork.com filetype:pdf user* manual`|Search for user manuals (user guide, user handbook) in PDF format on socialnetwork.com.|
|`..` (range search)|Finds results within a specified numerical range.|`site:ecommerce.com "price" 100..500`|Look for products priced between 100 and 500 on an e-commerce website.|
|`" "` (quotation marks)|Searches for exact phrases.|`"information security policy"`|Find documents mentioning the exact phrase "information security policy".|
|`-` (minus sign)|Excludes terms from the search results.|`site:news.com -inurl:sports`|Search for news articles on news.com excluding sports-related content.|
- Finding Login Pages:
    - `site:example.com inurl:login`
    - `site:example.com (inurl:login OR inurl:admin)`
- Identifying Exposed Files:
    - `site:example.com filetype:pdf`
    - `site:example.com (filetype:xls OR filetype:docx)`
- Uncovering Configuration Files:
    - `site:example.com inurl:config.php`
    - `site:example.com (ext:conf OR ext:cnf)` (searches for extensions commonly used for configuration files)
- Locating Database Backups:
    - `site:example.com inurl:backup`
    - `site:example.com filetype:sql`

## Web Archives

In the fast-paced digital world, websites come and go, leaving only fleeting traces of their existence behind. However, thanks to the [Internet Archive's Wayback Machine](https://web.archive.org/), we have a unique opportunity to revisit the past and explore the digital footprints of websites as they once were.

## Automating Recon
These frameworks aim to provide a complete suite of tools for web reconnaissance:

- [FinalRecon](https://github.com/thewhiteh4t/FinalRecon): A Python-based reconnaissance tool offering a range of modules for different tasks like SSL certificate checking, Whois information gathering, header analysis, and crawling. Its modular structure enables easy customisation for specific needs.
- [Recon-ng](https://github.com/lanmaster53/recon-ng): A powerful framework written in Python that offers a modular structure with various modules for different reconnaissance tasks. It can perform DNS enumeration, subdomain discovery, port scanning, web crawling, and even exploit known vulnerabilities.
- [theHarvester](https://github.com/laramies/theHarvester): Specifically designed for gathering email addresses, subdomains, hosts, employee names, open ports, and banners from different public sources like search engines, PGP key servers, and the SHODAN database. It is a command-line tool written in Python.
- [SpiderFoot](https://github.com/smicallef/spiderfoot): An open-source intelligence automation tool that integrates with various data sources to collect information about a target, including IP addresses, domain names, email addresses, and social media profiles. It can perform DNS lookups, web crawling, port scanning, and more.
- [OSINT Framework](https://osintframework.com/): A collection of various tools and resources for open-source intelligence gathering. It covers a wide range of information sources, including social media, search engines, public records, and more.
```shell-session
antz@htb[/htb]$ git clone https://github.com/thewhiteh4t/FinalRecon.git
antz@htb[/htb]$ cd FinalRecon
antz@htb[/htb]$ pip3 install -r requirements.txt
antz@htb[/htb]$ chmod +x ./finalrecon.py
antz@htb[/htb]$ ./finalrecon.py --help

antz@htb[/htb]$ ./finalrecon.py --headers --whois --url http://inlanefreight.com
./finalrecon.py --full --url $URL
```



## OWASP Amass

In-depth attack surface mapping and asset discovery

[https://github.com/owasp-amass/amass](https://github.com/owasp-amass/amass)

## Seeker 

Find exact location of a phone using phishing site like WhatsApp fake web.

[https://github.com/thewhiteh4t/seeker](https://github.com/thewhiteh4t/seeker)

## CTFR

Abusing Certificate Transparency logs for getting HTTPS websites subdomains.

[https://github.com/UnaPibaGeek/ctfr](https://github.com/UnaPibaGeek/ctfr)

## Emails

EMAIL SEARCH/VALIDATION Search for email address on a website: -[http://www.email-search.org/search-emails](http://www.email-search.org/search-emails/) (Free) Search for email addresses with a domain name: -[https://hunter.io](https://hunter.io/) (Half free) Get the target's email format with domain name: -[https://www.email-format.com](https://www.email-format.com/) (Free) Making email list with a domain by permuting name and surname: -[http://metricsparrow.com/toolkit/email-permutator](http://metricsparrow.com/toolkit/email-permutator/) (Free) Verify if an email address exists: -[https://verifalia.com/validate-email](https://verifalia.com/validate-email) (Free) Verify email validity, check SMTP servers: [-https://dnslytics.com/email-test](https://dnslytics.com/email-test) (Free)

EMAIL/PASSWORD LEAKS Verify if the email has been compromised in data breach: -[https://haveibeenpwned.com](https://haveibeenpwned.com/) (Free) -[https://ghostproject.fr](https://ghostproject.fr) (Half free) -[https://www.dehashed.com](https://www.dehashed.com/) (Half free) -[https://github.com/khast3x/h8mail](https://github.com/khast3x/h8mail) (Could need non-free API's keys) Find the leaked database: -[https://www.snusbase.com](https://www.snusbase.com/) (Non-free) -[https://www.dehashed.com](https://www.dehashed.com/) (Non-free) Deepweb search engines: -Notevil ([http://hss3uro2hsxfogfq.onion/index.php](http://hss3uro2hsxfogfq.onion/index.php)) -Candle ([http://gjobqjj7wyczbqie.onion](http://gjobqjj7wyczbqie.onion)) -Ahmia ([http://msydqstlz2kzerdg.onion/](http://msydqstlz2kzerdg.onion/))

## Web infrastructure

shodan : net:"SUBNET/MASK"

- org:"company name"

zoomeye : IP/MASK

fofa.so

Get the DNS servers, their records, and map the domain:

-[https://dnsdumpster.com/](https://dnsdumpster.com/)

IP enumeration + response header from domain name:

-[https://zoomeye.org](https://zoomeye.org)

Find subdomains:

-[https://findsubdomains.com](https://findsubdomains.com)

Find technologies used and versions of a webapp:

-[https://github.com/urbanadventurer/WhatWeb](https://github.com/urbanadventurer/WhatWeb)

Website caching platforms:

-[https://archive.org/](https://archive.org/)

-[https://archive.is/](https://archive.is/)

Google Analytics:

- The last piece of information that is really interesting is to check if the same Google Analytics / Adsense ID is used in several websites. This technique was discovered in 2015 and is well described here by [Bellingcat](https://www.bellingcat.com/resources/how-tos/2015/07/23/unveiling-hidden-connections-with-google-analytics-ids/).
- Certificates?

Using Google Dorks to find subdomains
```sh
# find subdomains
site:"something.com"

# without www and subd1
site:"something.com" -www -subd1
```

General search:

- [https://webmii.com](https://webmii.com)
- Google Dork : `site:linkedin.com -inurl:dir "Company" "Name"`

About companies:

- [https://opencorporates.com](https://opencorporates.com)
- [https://www.societe.com](https://www.societe.com) (_France-only_)

Employee's feedback and information about companies:

- [https://www.glassdoor.com](https://www.glassdoor.com)
- [https://www.indeed.com/companies](https://www.indeed.com/companies)

Twitter :

- [https://x.com/search-advanced](https://x.com/search-advanced)
- [https://twiteridfinder.com/](https://twiteridfinder.com/)
- [https://onemilliontweetmap.com](https://onemilliontweetmap.com)

Social networks/medias:

- Twitter
- Facebook
- Instagram
- Pinterest
- Reddit
- VKontakte
- Tumblr
- LinkedIn
- DeviantArt
- Steam

Image recognition:

- [https://lens.google.com](https://lens.google.com)
- [https://tineye.com](https://tineye.com)

## Resources

[https://gbhackers.com/external-black-box-penetration-testing](https://gbhackers.com/external-black-box-penetration-testing)

[https://github.com/jivoi/awesome-osint](https://github.com/jivoi/awesome-osint)

## AWS S3 Buckets

http(s)://{name}.s3.amazonaws.com, search {name}-assets, {name}-www, {name}-public, {name}-private, etc.

1\) Identify important information based on a user's posting history.

2\) Utilize outside resources, such as search engines, to identify additional information, such as full names and additional social media accounts.\
Additional Resources:\
While Rudolph's posting history is enough for us to identify that he has other social media accounts, sometimes we are not that lucky. Great tools exist that allow us to search for user accounts across social media platforms. Sites, such as [https://namechk.com/](https://namechk.com/), [https://whatsmyname.app/](https://whatsmyname.app/) and [https://namecheckup.com/](https://namecheckup.com/) will identify other possible accounts quickly for us. Tools, such as [https://github.com/WebBreacher/WhatsMyName](https://github.com/WebBreacher/WhatsMyName) and [https://github.com/sherlock-project/sherlock](https://github.com/sherlock-project/sherlock) do this as well. Simply enter a username, hit search, and comb through the results. It's that easy!\


TwitterNow, chitterGo

**Learning Objectives:**

1\) Identify important information based on a user's posting history.

2\) Use reverse image searching to identify where a photo was taken and possibly identify additional information, such as other user accounts.

3\) Utilize image EXIF data to uncover critical details, such as exact photo location, camera make and model, the date the photo was taken, and more.

4\) Use discovered emails to search through breached data to possibly identify user passwords, name, additional emails, and location.\



**Additional Resources**

Reverse image searching can help not only identify where an image was taken, but it can assist with identifying websites where that photo exists as well as similar photos (possibly from the same photoset). [https://yandex.com/images/](https://yandex.com/images/) , [https://tineye.com/](https://tineye.com/) and [https://www.bing.com/visualsearch?FORM=ILPVIS](https://www.bing.com/visualsearch?FORM=ILPVIS) are great as well. Additionally, do not neglect the possibility of EXIF data existing in an image. \
Finally, breached data can be incredibly useful from an investigative standpoint. Breach data does not just include passwords. It often has full names, addresses, IP information, password hashes, and more. We can often use this information to tie to other accounts. For example, say we find an account with the email of v3ry1337h4ck3r@gmail.com. If we search that email for breached data, we might find a password or hash associated with it. If unique enough, we can search that password or hash in a breach database and use it to identify other possible accounts. We can do the same with usernames, IPs, names, etc. The possibilities are vast and one email address can lead to a slew of information.\
Websites such as [https://haveibeenpwned.com/](https://haveibeenpwned.com/) will help identify if an account has ever been breached and will, at a minimum, inform us if an account existed at one point. However, it does not provide any password information. Free sites such as [http://scylla.sh/](http://scylla.sh/) will provide password information and are easy to search through. The data on free sites can tend to be older and not up to date with the latest breach information, but these sites are still a powerful resource. Lastly, paid sites such as [https://dehashed.com/](https://dehashed.com/) offer up to date information and are easily searchable at affordable rates.



-----


1. **SpiderFoot:** Una herramienta gráfica y de terminal para obtener datos de **OSINT** (inteligencia de fuentes abiertas). Nos ayuda a extraer información de dominios, empresas y personas, aunque debemos filtrar bien los resultados para evitar caer en falsos positivos.
    
2. **Maltego:** Es ideal para construir mapas visuales de relaciones entre datos recopilados, como nombres de dominio, IPs, emails, etc. ¡Perfecto para entender conexiones complejas!
    
3. **The Harvester:** Útil para buscar subdominios y direcciones de correo electrónico relacionadas con un dominio.
    

Es importante que sepamos qué hace cada herramienta y cómo funciona en su núcleo. Esto marca la diferencia entre un perfil junior (que ejecuta comandos sin saber qué ocurre) y un perfil senior (que entiende lo que pasa en segundo plano y puede adaptar sus análisis).

### Ejemplo práctico: ¿activo o pasivo?

Una anécdota compartida en clase nos ilustra por qué hay que tener cuidado al usar herramientas como **SpiderFoot**. Esta aplicación tiene un modo activo y otro pasivo. El modo activo interactúa directamente con los sistemas objetivo, dejando rastro en los registros (logs) del servidor, mientras que el pasivo recopila datos sin esa interacción directa. Durante una auditoría de un servicio de salud, un pequeño error al no seleccionar el modo correcto hizo que algunos servidores se vieran afectados. Por eso, **es fundamental revisar siempre las configuraciones antes de ejecutar cualquier herramienta**.
