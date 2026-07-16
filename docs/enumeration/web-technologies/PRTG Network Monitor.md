[PRTG Network Monitor](https://www.paessler.com/prtg) is agentless network monitor software. It can be used to monitor bandwidth usage, uptime and collect statistics from various hosts, including routers, switches, servers, and more. Devices can also communicate with the tool via a REST API. The software runs entirely from an AJAX-based website, but there is a desktop application available for Windows, Linux, and macOS.

Over the years, PRTG has suffered from [26 vulnerabilities](https://www.cvedetails.com/vulnerability-list/vendor_id-5034/product_id-35656/Paessler-Prtg-Network-Monitor.html) that were assigned CVEs. Of all of these, only four have easy-to-find public exploit PoCs, two cross-site scripting (XSS), one Denial of Service, and one authenticated command injection vulnerability.
## Enumeration
Default credentials `prtgadmin:prtgadmin`. They are typically pre-filled on the login page, and we often find them unchanged. Vulnerability scanners such as Nessus also have [plugins](https://www.tenable.com/plugins/nessus/51874) that detect the presence of PRTG.

Version can be obtained from `Nnmap` or using `cURL`:
```sh
curl -s http://10.129.201.50:8080/index.htm -A "Mozilla/5.0 (compatible;  MSIE 7.01; Windows NT 5.0)" | grep version
```
If default credentials fail, try simple passwords such as `prtgadmin:Password123`.
## Known Vulnerabilites
https://nvd.nist.gov/vuln/detail/CVE-2018-9276
Command Injection Vulnerability [blog post](https://www.codewatch.org/blog/?p=453). When creating a new notification, the `Parameter` field is passed directly into a PowerShell script without any type of input sanitization.

To begin, mouse over `Setup` in the top right and then the `Account Settings` menu and finally click on `Notifications`.
![](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/113/prtg_notifications.png)
Next, click on `Add new notification`.

Give the notification a name and scroll down and tick the box next to `EXECUTE PROGRAM`. Under `Program File`, select `Demo exe notification - outfile.ps1` from the drop-down. Finally, in the parameter field, enter a command. For our purposes, we will add a new local admin user by entering `test.txt;net user prtgadm1 Pwn3d_by_PRTG! /add;net localgroup administrators prtgadm1 /add`. During an actual assessment, we may want to do something that does not change the system, such as getting a reverse shell or connection to our favorite C2. Finally, click the `Save` button.
![](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/113/prtg_execute.png)
After clicking `Save`, we will be redirected to the `Notifications` page and see our new notification named `pwn` in the list.

At this point, all that is left is to click on the `pwn` notification and then click on `Test` or `Send test notification` button on the right side to run our notification and execute the command to add a local admin user. After clicking `Test` we will get a pop-up that says `EXE notification is queued up`.

We can use `NetExec` to confirm local admin access. We could also try to RDP to the box, access over WinRM, or use a tool such as [evil-winrm](https://github.com/Hackplayers/evil-winrm) or something from the [impacket](https://github.com/SecureAuthCorp/impacket) toolkit such as `wmiexec.py` or `psexec.py`.