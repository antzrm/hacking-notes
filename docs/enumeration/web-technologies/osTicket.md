
> [osTicket](https://osticket.com) is an open-source support ticketing system. It can be compared to systems such as Jira, OTRS, Request Tracker, and Spiceworks. osTicket can integrate user inquiries from email, phone, and web-based forms into a web interface. osTicket is written in PHP and uses a MySQL backend.
## Footprinting/Enumeration
Most osTicket installs will showcase the osTicket logo with the phrase `powered by` in front of it in the page's footer. The footer may also contain the words `Support Ticket System`.
Main functions of osTicket:
### User Input
The core function of osTicket is to inform the company's employees about a problem. 

A significant advantage we have here is that the application is open-source. From the osTicket [documentation](https://docs.osticket.com/en/latest/Getting%20Started/Post-Installation.html), we can see that only staff and users with administrator privileges can access the admin panel. So if our target company uses this or a similar application, we can cause a problem and *"play dumb"* and contact the company's staff. The simulated *"lack of"* knowledge about the services offered by the company in combination with a technical problem is a widespread social engineering approach to get more information from the company.
### Processing
As staff or administrators, they try to reproduce significant errors to find the core of the problem. Processing is finally done internally in an isolated environment that will have very similar settings to the systems in production. Suppose staff and administrators suspect that there is an internal bug that may be affecting the business. In that case, they will go into more detail to uncover possible code errors and address more significant issues.
### Solution
Depending on the depth of the problem, it is very likely that other staff members from the technical departments will be involved in the email correspondence. This will give us new email addresses to use against the osTicket admin panel (in the worst case) and potential usernames with which we can perform OSINT on or try to apply to other company services.
## Attacking
A search for osTicket on exploit-db shows various issues, including remote file inclusion, SQL injection, arbitrary file upload, XSS, etc. osTicket version 1.14.1 suffers from [CVE-2020-24881](https://nvd.nist.gov/vuln/detail/CVE-2020-24881) which was an SSRF vulnerability.

Aside from web application-related vulnerabilities, support portals can sometimes be used to obtain an email address for a company domain, which can be used to sign up for other exposed applications requiring an email verification to be sent.

Suppose we find an exposed service such as a company's Slack server or GitLab, which requires a valid company email address to join. Many companies have a support email such as `support@inlanefreight.local`, and emails sent to this are available in online support portals that may range from Zendesk to an internal custom tool. Furthermore, a support portal may assign a temporary internal email address to a new ticket so users can quickly check its status.

If we come across a customer support portal during our assessment and can submit a new ticket, we may be able to obtain a valid company email address.
![](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/113/new_ticket.png)
Suppose after creating a ticket, an internal email was provided. Now, if we log in, we can see information about the ticket and ways to post a reply. If the company set up their helpdesk software to correlate ticket numbers with emails, then any email sent to the email we received when registering, `940288@inlanefreight.local`, would show up here. With this setup, if we can find an external portal such as a Wiki, chat service (Slack, Mattermost, Rocket.chat), or a Git repository such as GitLab or Bitbucket, we may be able to use this email to register an account and the help desk support portal to receive a sign-up confirmation email.
### Sensitive Data Exposure
Let's say we are on an external penetration test. During our OSINT and information gathering, we discover several user credentials using the tool [Dehashed](http://dehashed.com/).
`python3 dehashed.py -q domain.com -p`

We performed subdomain enumeration and found two subdomains. `Support.inlanefreight.local` is hosting an osTicket instance, and `vpn.inlanefreight.local` is a Barracuda SSL VPN web portal that does not appear to be using multi-factor authentication.

If we got users and emails, we can try to **log in using both on osTicket and check open tickets as well as closed tickets**. We could **find password resets, credentials and other sensitive data**. We could try that password against the exposed VPN portal as the user may not have changed it.

Many organizations have helpdesk using a standard password for new users and password resets. Often the domain password policy is lax and does not force the user to change at the next login. If this is the case, it may work for other users. In this scenario, it would be worth using tools like [linkedin2username](https://github.com/initstring/linkedin2username) to **create a user list of company employees and attempt a password spraying** attack against the VPN endpoint with this standard password.

Many applications such as osTicket also contain an **address book**. It would also be worth **exporting all emails/usernames from the address book as part of our enumeration** as they could also prove helpful in an attack such as password spraying.
**Scenario:**
- Enumerate vhosts and subdomains.
- Use OSINT, Dehashed and other techniques to obtain creds.
- osTicket > Sign in >  I'm an agent — sign in here.
- Try user:pass but also email:pass combinations. 
- Check Open tickets but also Closed tickets.
- Check other sections such as Users or Tasks as well.
## Prevention
- Limit what applications are exposed externally
- Enforce multi-factor authentication on all external portals
- Provide security awareness training to all employees and advise them not to use their corporate emails to sign up for third-party services
- Enforce a strong password policy in Active Directory and on all applications, disallowing common words such as variations of `welcome`, and `password`, the company name, and seasons and months
- Require a user to change their password after their initial login and periodically expire user's passwords
