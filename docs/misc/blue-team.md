# Blue Team


```bash
# MITRE
https://medium.com/mitre-engenuity/introducing-the-all-new-adversary-emulation-plan-library-234b1d543f6b

# YARA
https://cuckoosandbox.org/
```

Good Blue Team courses
- CCNA-CyberOps – Cisco Certified CyberOps Associate
    - [CyberOps Associate](https://www.netacad.com/es/courses/cyberops-associate?courseLang=es-XL)
- Security Blue Team
    - [Blue Team Junior Analyst Pathway | Free Blue Team Training](https://www.securityblue.team/courses/blue-team-junior-analyst-pathway-bundle)
    - [BTLO](https://blueteamlabs.online/home/challenges) 🡪 Laboratorios
    - [Security Blue Team - eLearning Platform](https://elearning.securityblue.team/home/courses/free-courses)
- [TryHackMe | SOC Level 1 Training](https://tryhackme.com/path/outline/soclevel1?ref=blog.tryhackme.com)
- PaloAlto: [Cybersecurity Fundamentals - The Learning Center](https://learn.paloaltonetworks.com/learn/courses/229/cybersecurity-fundamentals)
- [Palo Alto Networks Certified Cybersecurity Practitioner - The Learning Center](https://learn.paloaltonetworks.com/learn/learning-plans/339/palo-alto-networks-certified-cybersecurity-practitioner)
- [Cortex XSOAR: Analyst Training (ver. 2020) - The Learning Center](https://learn.paloaltonetworks.com/learn/courses/2281/cortex-xsoar-analyst-training-ver-2020)
- GIAC GCIH (Incident Handler)
## Alert Triaging

|   |   |   |
|---|---|---|
|**Key Factors**|**Description**|**Why It Matters?**|
|Severity Level|Review the alert's severity rating, ranging from Informational to Critical.|Indicates the urgency of response and potential business risk.|
|Timestamp and Frequency|Identify when the alert was triggered and check for related activity before and after that time.|Helps identify ongoing attacks or patterns of repeated behaviour.|
|Attack Stage|Determine which stage of the attack lifecycle this alert indicates (reconnaissance, persistence, or data exfiltration).|It gives insight into how far the attacker may have progressed and their objective.|
|Affected Asset|Identify the system, user, or resource involved and assess its importance to operations.|Prioritises response based on the asset's importance and the potential impact of compromise.|

After reviewing these factors, decide on your next step: escalate to the incident response team, perform a deeper investigation, or close the alert if it's confirmed to be a false positive. A structured triage process like this helps ensure that time and resources are focused on what truly matters.
## Diving Deeper into an Alert

After identifying which alerts deserve further attention, it's time to dig into the details. Follow these steps to investigate and correlate effectively:

- **Investigate the alert in detail.**  
    Open the alert and review the entities, event data, and detection logic. Confirm whether the activity represents real malicious behaviour.  
- **Check the related logs.**  
    Examine the relevant log sources. Look for patterns or unusual actions that align with the alert.  
- **Correlate multiple alerts.**  
    Identify other alerts involving the same user, IP address, or device. Correlation often reveals a broader attack sequence or coordinated activity.  
- **Build context and a timeline.**  
    Combine timestamps, user actions, and affected assets to reconstruct the sequence of events. This helps determine if the attack is ongoing or has already been contained.  
- **Decide on the following action.**  
    If there are indicators of compromise, escalate to the incident response team. Investigate further if more evidence or correlation is needed. Close or suppress if the alert is a confirmed false positive, and update detection rules accordingly.  
- **Document findings and lessons learned.**
    Keep a clear record of the analysis, decisions, and remediation steps. Proper documentation strengthens SOC processes and supports continuous improvement.

## Microsoft Sentinel
- Logs > load a log
- Threat Intelligence > Incidents > check them
- Open incident > see events.
Diving deeper into this, we can try checking the raw events from a single host through a custom query. To do this, let's change the view into an editable KQL query and find all the events triggered from **app-02**.

1. Press the **Simple mode** dropdown from the upper-right corner and select KQL mode.
2. Modify the query with the following KQL query below.  
      
    `set query_now = datetime(2025-10-30T05:09:25.9886229Z);`  
    `Syslog_CL`  
    `| where host_s == 'app-02'`  
    `| project _timestamp_t, host_s, Message`



## Malware


### First steps
```bash
Check MD5 hash with Virustotal

Check obfuscation/packing of executables with PEiD
Whilst this tool has a huge database, it doesn't have every packer out there! 
Especially say if an Author has written their own - PeID will have no way 
of identifying the packer used. In cases like this, it's more about what
 PeID doesn't tell us - rather than what it does.
 
 If it's packed, open it with IDA Freeware
 Only few imports -- it's obfuscated
 
 Use Ghidra for static analysis
 
 # PACKING & ENTROPY -- DETECT IF AN EXECUTABLE WAS PACKED
 Not too many imports
 High entropy
 Use PEiD
```


### REMnux

```bash
https://remnux.org/
https://docs.remnux.org/

## PDF
# Inspection
peepdf demo_notsuspicious.pdf
# Script creation
echo 'extract js > javascript-from-demo_notsuspicious.pdf' > extracted_javascript.txt
# Javascript extraction
peepdf -s extracted_javascript.txt demo_notsuspicious.pdf

## MICROSOFT OFFICE MACROS
vmonkey DefinitelyALegitInvoice.doc
```




## GPO

GPOs are distributed to the network via a network share called `SYSVOL`, which is stored in the DC. All users in a domain should typically have access to this share over the network to sync their GPOs periodically. The SYSVOL share points by default to the `C:\Windows\SYSVOL\sysvol\` directory on each of the DCs in our network.


```powershell
GPO > Default Domain Policy > New > User Configuration > Administrative Templates > Control Panel > Prohibit Control Panel # may be applied for some users
# Sync/Update GPOs changes immediately
PS C:\> gpupdate /force
```


## PDF

[https://www.kali.org/tools/pdfid/](https://www.kali.org/tools/pdfid/)

## osquery


```bash
# TABLE LIST
https://osquery.io/schema/4.7.0/

https://osquery.readthedocs.io/en/stable/deployment/yara/

# LINUX
yara /var/osquery/yara/scanner.yara /home/charlie/
SELECT * FROM yara WHERE path LIKE '/home/tryhackme/%' and sigfile='/var/osquery/yara/scanner.yara';

# WINDOWS
https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/troubleshoot-microsoft-defender-antivirus?view=o365-worldwide
https://github.com/polylogyx/osq-ext-bin/blob/master/README.md
osqueryi --allow-unsafe --extension "C:\Program Files\osquery\extensions\osq-ext-bin\plgx_win_extension.ext.exe"
# Wait for the command prompt to reflect the phrase Done StartDriver. This will indicate that the extension is fully loaded into the session.
select * from win_event_log_channels where source like '%Sysmon%';
select eventid from win_event_log_data where source='Microsoft-Windows-Sysmon/Operational' order by datetime limit 1;
```


## DNS Poisoning

```bash
Check C:\Windows\System32\drivers\etc\hosts
```

## Windows Event Logs

```bash
Get-WinEvent -LogName Security -FilterXPath '*/EventData/Data[@Name="TargetUserName"]="System"'

Get-WinEvent -Path <Path to Log> -FilterXPath '*/System/EventID=15'

#Hunting for Common Back Connect Ports with PowerShell
Get-WinEvent  -Path <Path to Log> -FilterXPath '*/System/EventID=3 and  */EventData/Data[@Name="DestinationPort"] and  */EventData/Data=<Port>'

# Detecting LSASS Behavior with PowerShell
Get-WinEvent  -Path <Path to Log> -FilterXPath '*/System/EventID=10 and  */EventData/Data[@Name="TargetImage"] and  */EventData/Data="C:\Windows\system32\lsass.exe"'

# Hunting for open ports
Get-WinEvent  -Path <Path to Log> -FilterXPath '*/System/EventID=3 and  */EventData/Data[@Name="DestinationPort"] and */EventData/Data=4444'
```


## Powershell - Hash files, strings, streams, hide connectors


```
# Obtain the hash of a file
Get-FileHash -Algorithm MD5 file.txt

\Tools\strings64.exe -accepteula file.exe
# n the output, you should notice a command related to ADS. You know this by the end of the Powershell command -Stream.

# View ADS
Get-Item -Path file.exe -Stream *

# We can use a built-in Windows tool, Windows Management Instrumentation, to launch the hidden file.
wmic process call create $(Resolve-Path file.exe:streamname)
```


Alternate Data Streams (ADS) is a file attribute specific to Windows NTFS (New Technology File System). Every file has at least one data stream ($DATA) and ADS allows files to contain more than one stream of data. Natively Window Explorer doesn't display ADS to the user. There are 3rd party executables that can be used to view this data, but Powershell gives you the ability to view ADS for files.

Malware writers have used ADS to hide data in an endpoint, but not all its uses are malicious. When you download a file from the Internet unto an endpoint there are identifiers written to ADS to identify that it was downloaded from the Internet.

## Ransomware and Shadow Copy

Ransomware is a real threat that enterprise defenders and casual computer users need to defend & prepare against. According to Wikipedia, ransomware is a type of malware that threatens to publish the victim's data or perpetually block access to it unless a ransom is paid. It can be a frightening experience to log into a machine only to realize that malware has encrypted all of your important documents.

There are numerous security products that can be implemented in the security stack to catch this type of malware. If ransomware infects an endpoint, depending on the actual malware, there might be a decryptor made available by a security vendor. If not then you must rely on backups in order to restore your machines to the last working state, along with its files. Windows has a built-in feature that can assist with that.

The Volume Shadow Copy Service (VSS) coordinates the actions that are required to create a consistent shadow copy (also known as a snapshot or a point-in-time copy) of the data that is to be backed up.  (official definition)

Malware writers know of this Windows feature and write code in their malware to look for these files and delete them. Doing so makes it impossible to recover from a ransomware attack unless you have an offline/off-site backup. Not all malware deletes the volume shadow copies though.

Before diving into VSS on the endpoint let's talk briefly regarding the Task Scheduler.

The Task Scheduler enables you to automatically perform routine tasks on a chosen computer. Task Scheduler does this by monitoring whatever criteria you choose (referred to as triggers) and then executing the tasks when those criteria are met. (official definition)

Malware writers might have the malware create a scheduled task in order for the malware to run at a specific desired day/time or trigger. The Task Scheduler utility has been conveniently been placed in the taskbar for you. To view, the scheduled tasks click on Task Scheduler Library.  You should see 2 scheduled tasks of interest: 1 with a weird name and the other related to VSS. Click on any of the scheduled tasks to populate more information about it, such as Triggers and Actions.

At this point you should realize that VSS is enabled and thanks to the scheduled task you know the ID of the volume.

The command to interact with VSS is `vssadmin`. Running the command alone will display brief information on how to run the utility with additional commands. Two commands of particular interest are `List Volumes` and `List Shadows`.

![](https://assets.tryhackme.com/additional/sam-aoc2020/vssadmin1.png)

If you run `vssadmin list volumes` you will see that the C:\ drive has a different volume name/id. There must be another volume on the endpoint.

![](https://assets.tryhackme.com/additional/sam-aoc2020/vssadmin2.png)

You can use Disk Management to check into that. Disk Management is a system utility in Windows that enables you to perform advanced storage tasks. (official definition) As with the other utilities, Disk Management has been placed in the taskbar for your convenience.

As you can see there is another volume but you're unable to view it within Windows Explorer. Right-click the partition to view its properties. Now, look at the `Security` tab. Confirm that the volume name/id from the Task Scheduler and vssadmin output is similar to the `object name` of this partition.  Also, notice there is a tab titled `Shadow Copies`. Review the information and close the Properties window.

In order to see this partition within Windows Explorer, you must assign it a drive letter. Right-click the partition and select `Change Drive Letter and Paths`.  Click `Add`.  In the dropdown choose a letter, such as Z, and click OK.  At the top, in the Volume column, you should now see that the partition has a letter assigned to it. Open Windows Explorer to navigate to the partition.

In a previous challenge, you managed to view hidden content in folders via the command-line. You can do the same within Windows Explorer. In the menu, select `View`, and checkmark  `Hidden Items`. You should now see any hidden content right within Windows Explorer.

Back to VSS, to restore files to a previous version, simply right-click the folder and select `Properties` then select the `Previous Versions` tab.  Select which shadow copy you would like to restore and click the `Restore`button. Accept the confirmation to restore the shadow copy. Close the Properties window and drill into the folder to find the restore file(s).


## YARA
YARA is a tool built to identify and classify malware by searching for unique patterns, the digital fingerprints left behind by attackers. Imagine it as a detective’s notebook for cyber defenders: instead of dusting for prints, YARA scans code, files, and memory for subtle traces that reveal a threat’s identity.
In what situations might defenders rely on this tool?

- **Post-incident analysis**: when the security team needs to verify whether traces of malware found on one compromised host still exist elsewhere in the environment.
- **Threat Hunting**: searching through systems and endpoints for signs of known or related malware families.
- **Intelligence-based scans**: applying shared YARA rules from other defenders or kingdoms to detect new indicators of compromise.
- **Memory analysis**: examining active processes in a memory dump for malicious code fragments.
## YARA Rules
A YARA rule is built from several key elements:

- **Metadata**: information about the rule itself: who created it, when, and for what purpose.
- **Strings**: the clues YARA searches for: text, byte sequences, or regular expressions that mark suspicious content.
- **Conditions**: the logic that decides when the rule triggers, combining multiple strings or parameters into a single decision.

Here’s how it looks in practice:

```php
rule TBFC_KingMalhare_Trace
{
    meta:
        author = "Defender of SOC-mas"
        description = "Detects traces of King Malhare’s malware"
        date = "2025-10-10"
    strings:
        $s1 = "rundll32.exe" fullword ascii
        $s2 = "msvcrt.dll" fullword wide
        $url1 = /http:\/\/.*malhare.*/ nocase
    condition:
        any of them
}
```
**Strings**

As mentioned earlier, strings are the clues that YARA searches for when scanning files, memory, or other data sources.  
They represent the signatures of malicious activity in fragments of text, bytes, or patterns that can reveal the presence of King Malhare's code. In YARA, there are three main types of strings, each with its own purpose. Let’s talk about them and see how they can help defend the kingdom of TBFC.  
  
**Text strings  
**Text strings are the simplest and most common type used in YARA rules. They represent words or short text fragments that might appear in a file, script, or memory. By default, YARA treats text strings as ASCII and case-sensitive, but you can modify how they behave using special modifiers - small keywords added after the string definition. The example below shows a simple rule that searches for the word **Christmas** inside a file:

```php
rule TBFC_KingMalhare_Trace
{
    strings:
        $TBFC_string = "Christmas"

    condition:
        $TBFC_string 
}
```

Sometimes, attackers like King Malhare try to hide their code by changing how text looks inside a file - using encoding, case tricks, or even encryption. YARA helps defenders counter these obfuscation methods with a few powerful modifiers that extend the capabilities of text strings:

- **Case-insensitive strings - nocase  
    **By default, YARA matches text exactly as written. Adding the `nocase` modifier makes the match ignore letter casing, so "Christmas", "CHRISTMAS", or "christmas" will all trigger the same result.

```php
strings:
    $xmas = "Christmas" nocase
```

- **Wide-character strings - wide, ascii**  
    Many Windows executables use two-byte Unicode characters. Adding `wide` tells YARA to also look for this format, while `ascii` enforces a single-byte search. You can use both together:

```php
strings:
    $xmas = "Christmas" wide ascii
```

- **XOR strings - xor  
    **Malhare's agents often XOR-encode text to hide it from scanners. Using the `xor` modifier, YARA automatically checks all possible single-byte XOR variations of a string - revealing what attackers tried to conceal.

```php
strings:
    $hidden = "Malhare" xor
```

- **Base64 strings - base64, base64wide**  
    Some malware encodes payloads or commands in Base64. With these modifiers, YARA decodes the content and searches for the original pattern, even when it’s hidden in encoded form.

```php
strings:
    $b64 = "SOC-mas" base64
```

Each of these modifiers makes your rule smarter and more resilient, ensuring that even when King Malhare disguises his code, the defenders of TBFC can still uncover the truth.  
  
**Hexadecimal strings  
**Sometimes, King Malhare's code doesn't leave readable words behind; instead, it hides in raw bytes deep inside executables or memory. That's when hexadecimal strings come to the rescue. Hex strings allow YARA to search for specific byte patterns, written in hexadecimal notation. This is useful when defenders need to detect malware fragments like file headers, shellcode, or binary signatures that can't be represented as plain text.

```php
rule TBFC_Malhare_HexDetect
{
    strings:
        $mz = { 4D 5A 90 00 }   // MZ header of a Windows executable
        $hex_string = { E3 41 ?? C8 G? VB }

    condition:
        $mz and $hex_string
}
```

**  
Regular expression strings  
**Not all traces of King Malhare's malware follow a fixed pattern. Sometimes, his code mutates, small changes in file names, URLs, or commands make it harder to detect using plain text or hex strings. That's where regular expressions come in. Regex allows defenders to write flexible search patterns that can match multiple variations of the same malicious string.  
It's especially useful for spotting URLs, encoded commands, or filenames that share a structure but differ slightly each time.

```php
rule TBFC_Malhare_RegexDetect
{
    strings:
        $url = /http:\/\/.*malhare.*/ nocase
        $cmd = /powershell.*-enc\s+[A-Za-z0-9+/=]+/ nocase

    condition:
        $url and $cmd
}
```

 Regex strings are powerful but should be used carefully; they can match a wide range of data and may slow down scans if written too broadly.

**Conditions**

Now that the defenders of TBFC know how to describe what to look for using strings, it's time to learn when YARA should decide that a threat has been found. That logic lives inside the condition section, the heart of every YARA rule. The condition tells YARA when the rule should trigger based on the results of all the string checks. Think of it as the final decision point, the moment when the system confirms: "Yes, this looks like King Malhare's code." Let's look at a few basic examples defenders use in their daily missions.  
  
**Match a single string**  
The simplest condition, the rule triggers if one specific string is found. For example, the variable xmas.

```php
condition:
    $xmas
```

**Match any string  
**When multiple strings are defined, the rule can be configured to trigger as soon as any one of them is found:

```php
condition:
    any of them
```

This approach is useful for detecting early signs of compromise; even a single matching clue can be enough to raise attention.  
  
**Match all strings  
**To make the rule stricter, you can require that all defined strings appear together:

```php
condition:
    all of them
```

This approach reduces false positives; YARA will only flag a file if every indicator matches.

**Combine logic using: and, or, not  
**Defenders often need more control over how rules behave. Logical operators let you combine multiple checks into one condition, just like building a small defensive strategy.

```php
condition:
    ($s1 or $s2) and not $benign
```

This means the rule will trigger if either $s1 or $s2 is found, but not $benign. In other words: detect suspicious code, but ignore harmless system files.  
  
**Use comparisons like: filesize, entrypoint, or hash  
**YARA can also check file properties, not just contents. For example, you can detect files that are unusually small or large, a common trick used by King Malhare to disguise his payloads.

```php
condition:
    any of them and (filesize < 700KB)
```
## YARA Study Use Cases

The evil kingdom of Malhare used a trojan known as IcedID to steal credentials from systems. McSkidy's analysts discovered that the malicious files spread across Wareville shared a common signature, the same MZ header found in executable malware used by the Dark Kingdom. These samples were small, lightweight loaders designed to infiltrate systems and later summon more dangerous payloads. Let's write our YARA rule.

```php
rule TBFC_Simple_MZ_Detect
{
    meta:
        author = "TBFC SOC L2"
        description = "IcedID Rule"
        date = "2025-10-10"
        confidence = "low"

    strings:
        $mz   = { 4D 5A }                        // "MZ" header (PE file)
        $hex1 = { 48 8B ?? ?? 48 89 }            // malicious binary fragment
        $s1   = "malhare" nocase                 // story / IOC string

    condition:
        all of them and filesize < 10485760     // < 10MB size
}
```

Our analysts saved this to a file named **icedid_starter.yar** and executed it on one of the hosts. As a result, we can see that one file was detected.

```php
yara -r icedid_starter.yar C:\
icedid_starter  C:\Users\WarevilleElf\AppData\Roaming\TBFC_Presents\malhare_gift_loader.exe
```

We can use the `man yara` command to find out what flags could be useful in our scenario, and we find the following:

- `-r` - Allows YARA to scan directories recursively and follow symlinks
- `-s` - Prints the strings found within files that match the rule

## Practice
- Search for the keyword `TBFC:` followed by an ASCII alphanumeric keyword
`/TBFC:[A-Za-z0-9]+/`
- Across the `/home/ubuntu/Downloads/easter`
- Extract the message with `-s`
`yara -s -r test.yar /home/ubuntu/Downloads/easter/`
