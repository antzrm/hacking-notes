## Why Spam Is Not Phishing?

Spam is just digital noise: annoying, but mostly harmless. Phishing, however, is a precision strike, in this case from Malhare’s Eggsploit Bunnies, crafted to deceive TBFC employees and open a path into the company’s defences.

Spam focuses on quantity over precision. Unlike phishing, which aims to deceive specific users, spam messages are sent in bulk to flood inboxes with unwanted marketing or irrelevant content. Their goal isn’t usually to steal data, but to push exposure or engagement.

Common intentions behind spam messages:

- **Promotion:** Advertising products, services, or events. Often unsolicited or low-quality.
- **Scams:** Spreading fake offers or “get rich quick” schemes to attract clicks.
- **Traffic generation (clickbait):** Driving users to external sites or boosting ad metrics.
- **Data harvesting:** Collecting active email addresses for future campaigns.

**Social Engineering**

Social engineering in phishing is the art of manipulating people rather than breaking technology. Attackers craft believable stories, emails, calls, or chat messages that exploit emotions (fear, helpfulness, curiosity, urgency) and real-world context to lure the recipients of a message.

Now, read the content of the previous email you had opened. We can spot multiple social engineering techniques:

- **Impersonation:** Is a type of Social Engineering. The attacker is pretending to be McSkidy!
- **Sense of urgency:** We can observe words such as "urgent" and "immediately" to pressure the recipient.
- **Side channel:** The attacker tries to discourage the recipients from reaching McSkidy using his standard communication channels (phone and email address).
- **Malicious intention:** The attacker is trying to trick the user into giving VPN credentials. They can also try to ask for approval of payments, opening malware, or sharing sensitive data.

**Spoofing**

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
