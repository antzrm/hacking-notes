# OSINT

![](../assets/image (17).png)

![](../assets/image (141).png)

![](../assets/image (142).png)

[phonebook.cz](https://phonebook.cz/)

[Ahmia.fi](https://ahmia.fi/) is a search engine specifically for finding sites on the Tor Network, although the search engine itself is accessible on the “clearnet.” But you will need the [Tor Browser](https://www.torproject.org/download/) in order to open your Tor search results.

[Wayback Machine](https://archive.org/web/)

Check out OSINT tools on the security podcast "Privacy Security and OSINT" my Michael Bazzell and website check out [https://inteltechniques.com/blog/](https://inteltechniques.com/blog/) or [https://www.trustedsec.com/blog/upgrade-your-workflow-part-1-building-osint-checklists/](https://www.trustedsec.com/blog/upgrade-your-workflow-part-1-building-osint-checklists/) or [https://medium.com/@hunchly/bulk-extracting-exif-metadata-with-hunchly-and-exiftool-164d67c8d7e2](https://medium.com/@hunchly/bulk-extracting-exif-metadata-with-hunchly-and-exiftool-164d67c8d7e2) I know of Exiftool and imagemagick. I personally wouldn't use something that doesn't run locally. I like Hunchly but I don't think it's free.

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


TwitterNow, chitterGo\
**Learning Objectives:**\
1\) Identify important information based on a user's posting history.

2\) Use reverse image searching to identify where a photo was taken and possibly identify additional information, such as other user accounts.

3\) Utilize image EXIF data to uncover critical details, such as exact photo location, camera make and model, the date the photo was taken, and more.

4\) Use discovered emails to search through breached data to possibly identify user passwords, name, additional emails, and location.\


**Additional Resources**\
Reverse image searching can help not only identify where an image was taken, but it can assist with identifying websites where that photo exists as well as similar photos (possibly from the same photoset). [https://yandex.com/images/](https://yandex.com/images/) , [https://tineye.com/](https://tineye.com/) and [https://www.bing.com/visualsearch?FORM=ILPVIS](https://www.bing.com/visualsearch?FORM=ILPVIS) are great as well. Additionally, do not neglect the possibility of EXIF data existing in an image. \
Finally, breached data can be incredibly useful from an investigative standpoint. Breach data does not just include passwords. It often has full names, addresses, IP information, password hashes, and more. We can often use this information to tie to other accounts. For example, say we find an account with the email of v3ry1337h4ck3r@gmail.com. If we search that email for breached data, we might find a password or hash associated with it. If unique enough, we can search that password or hash in a breach database and use it to identify other possible accounts. We can do the same with usernames, IPs, names, etc. The possibilities are vast and one email address can lead to a slew of information.\
Websites such as [https://haveibeenpwned.com/](https://haveibeenpwned.com/) will help identify if an account has ever been breached and will, at a minimum, inform us if an account existed at one point. However, it does not provide any password information. Free sites such as [http://scylla.sh/](http://scylla.sh/) will provide password information and are easy to search through. The data on free sites can tend to be older and not up to date with the latest breach information, but these sites are still a powerful resource. Lastly, paid sites such as [https://dehashed.com/](https://dehashed.com/) offer up to date information and are easily searchable at affordable rates.
