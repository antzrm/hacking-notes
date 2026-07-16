## Why Spam Is Not Phishing?

Spam is just digital noise: annoying, but mostly harmless. Phishing, however, is a precision strike, in this case from Malhare’s Eggsploit Bunnies, crafted to deceive TBFC employees and open a path into the company’s defences.

Spam focuses on quantity over precision. Unlike phishing, which aims to deceive specific users, spam messages are sent in bulk to flood inboxes with unwanted marketing or irrelevant content. Their goal isn’t usually to steal data, but to push exposure or engagement.

Common intentions behind spam messages:

- **Promotion:** Advertising products, services, or events. Often unsolicited or low-quality.
- **Scams:** Spreading fake offers or “get rich quick” schemes to attract clicks.
- **Traffic generation (clickbait):** Driving users to external sites or boosting ad metrics.
- **Data harvesting:** Collecting active email addresses for future campaigns.

## Social Engineering

Social engineering in phishing is the art of manipulating people rather than breaking technology. Attackers craft believable stories, emails, calls, or chat messages that exploit emotions (fear, helpfulness, curiosity, urgency) and real-world context to lure the recipients of a message.

Now, read the content of the previous email you had opened. We can spot multiple social engineering techniques:

- **Impersonation:** Is a type of Social Engineering. The attacker is pretending to be McSkidy!
- **Sense of urgency:** We can observe words such as "urgent" and "immediately" to pressure the recipient.
- **Side channel:** The attacker tries to discourage the recipients from reaching McSkidy using his standard communication channels (phone and email address).
- **Malicious intention:** The attacker is trying to trick the user into giving VPN credentials. They can also try to ask for approval of payments, opening malware, or sharing sensitive data.

## Social Engineering Toolkit
[Social-Engineer Toolkit (SET)](https://github.com/trustedsec/social-engineer-toolkit). It is an open-source tool primarily designed by David Kennedy for social engineering attacks. It offers a wide range of features. In particular, it lets you compose and send a phishing email. In the current scenario, we will use this tool to create and send a phishing email to the target user.

To start the tool, type `setoolkit` into the terminal, and it will present you with a menu containing multiple options. At the bottom, you will see `set>`, where you can input your desired option number. For our case, we would select option `1`, i.e., `Social-Engineering Attacks`. If you choose the wrong option at any stage, the option `99` will take you back to the main menu, where you can start again. However, if you commit any mistake while writing the phishing email, you would have to press `Ctrl + C` to return to the main menu. The social engineering attacks cover various attacks from spear-phishing and mass mailer attacks to wireless access point attacks.

Example:
- **Send email to**: Let’s begin by targeting `factory@wareville.thm`
- **How to deliver the email**: We will choose `Use your own server or open relay`
- **From address**: We know that the guys at the toy factory communicate regularly with Flying Deer, the shipping company, so that we will use `updates@flyingdeer.thm` as the source email address
- **From name**: Let’s use the name `Flying Deer`
- **Username for open-relay**: We will leave it blank and just hit the **Enter** key
- **Password for open-relay**: We will leave it blank and just hit the **Enter** key
- **SMTP email server address**: We will deliver directly to the TBFC mail server by entering `10.80.166.252`.
- **Port number for the SMTP server**: We leave the default value of `25` and just hit the **Enter** key

The next set of questions will ask if you want to send it as a high priority or attach a file.

- **Flag this message as high priority:** The choice is entirely up to you, depending on your knowledge of the circumstances, but we will answer with `no`
- **Do you want to attach a file:** We will answer with `n`
- **Do you want to attach an inline file:** Again, let’s answer with `n`

Finally, we pick an email subject and enter the message contents in plaintext or HTML.

- **Email subject:** We need to think of something convincing, for example, “Shipping Schedule Changes”
- **Send the message as HTML or plain:** We will keep the default choice of plaintext and just hit the **Enter** key
- **Enter the body of the message, and type END (capitals) when finished:** Create and type any convincing message. Make sure to include the URL `http://CONNECTION_IP:8000` to check if the target will fall for this trick.

```bash
https://github.com/trustedsec/social-engineer-toolkit

We can use the Social Engineer Toolkit to set up a fake website and phish the users. 
SEToolkit supports cloning pages and capturing incoming credentials. 
Run setoolkit and select the options Social-Engineering Attacks > Website Attack Vectors > Credential Harvester Attack > Site Cloner . Next, enter your VPN IP address (e.g. 10.10.14.X) for incoming requests, followed by the login page URL:

https://humongousretail.com/remote/auth/login.aspx

# Then we can send emails using swaks
```

## Convincing Phishing Emails

* Sender address from a significant brand, contact or cowoker. Use OSINT to suit it better to the destinatary.
* Subject: urgent, worrying, piques the victim's curiosity (account compromised, package shipped, payroll info, leaked pics...
* Content/Body: mimic standard email templates of the company, signatures, use anchor text \<a href> to disguise links

## Phishing Infrastructure

* Domain Name (buy expired domains, typosquatting, TLD alternative such as .co.uk, IDN Homograph Attack/Script Spoofing)
* SSL/TLS certificates
* Email Server/Account
* DNS Records to improve deliverability (not getting into spam folder)
* Web Server
* Analytics of emails sent, opened...

[https://getgophish.com/](https://getgophish.com/)

[https://www.trustedsec.com/tools/the-social-engineer-toolkit-set/](https://www.trustedsec.com/tools/the-social-engineer-toolkit-set/)

Droppers > software to be downloaded and run (legitimate but once installed, the intended malware is either unpacked or downloaded)

Use MS Office in Phishing as attachments with macros

Browser exploits: difficult, but might work if we know systems and are old or unpatched for sth like [https://msrc.microsoft.com/update-guide/vulnerability/CVE-2021-40444](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2021-40444)


## Spoofing

Email spoofing is another way attackers can trick users into thinking they are receiving emails from a legitimate domain.  
The message looks like it came from a trusted sender (the display name and “From:” you see in the preview), but the underlying headers tell a different story. Modern email clients can easily reject spoofing attempts, but because Wareville email protection is down, some spoofing attempts can pass silently!
It looks like a real domain from TBFC, but let's check some essential fields in the email headers:

- `Authentication-Results`
- `Return-Path`

![Headers from the last email message highlighting the failed SPF, DKIM, and DMARC. Also, the Return-Path to a different email address.](https://tryhackme-images.s3.amazonaws.com/user-uploads/68dac5d6d4d4f23175b3296f/room-content/68dac5d6d4d4f23175b3296f-1763037347342.png)
On `Authentication-Results`, SPF, DKIM, and DMARC are security checks that help confirm if an email really comes from who it says it does:

- **SPF:** Says which servers are allowed to send emails for a domain (like a list of approved senders).
- **DKIM:** Adds a digital signature to prove the message wasn’t changed and really came from that domain.
- **DMARC:** Uses SPF and DKIM to decide what to do if something looks fake (for example, send it to spam or block it).

If both SPF and DMARC fail, it’s a strong sign the email is spoofed, meaning the sender isn’t who they claim to be. In this message case, everything failed!

On the `Return-Path` we can see the real mail address `zxwsedr@easterbb.com`. This confirms the spoofing attempt on the missing calls email from TBFC!
