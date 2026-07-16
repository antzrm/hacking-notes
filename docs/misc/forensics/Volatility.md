
At the time of writing, there are two versions of Volatility: [Volatility 2](https://github.com/volatilityfoundation/volatility), which is built using Python 2, and [Volatility 3](https://github.com/volatilityfoundation/volatility3), which uses Python 3. There are different use cases for each version, and depending on this, you might choose either one over the other. For example, Volatility 2 has been around for longer, so in some cases, it will have modules and plugins that have yet to be adapted to Volatility 3. For the purposes of this task, we're using Volatility 2.


```bash
https://downloads.volatilityfoundation.org/releases/2.4/CheatSheet_v2.4.pdf

######### VOLATILITY 2 WAS USED FOR THESE EXAMPLES
# Profiles (Linux profiles have to be manually created from the same device the memory dump is from)
vol.py --info
# To use a Linux profile, we have to copy it where Volatility stores the various profiles for Linux (~/.local/lib/python2.7/site-packages/volatility/plugins/overlays/linux/
https://beguier.eu/nicolas/articles/security-tips-3-volatility-linux-profiles.html

# Memory Analysis
vol.py -f memorydump.mem --profile="LinuxUbuntu_5_4_0-163-generic_profilex64" -h

############ PLUGINS
# History file
vol.py -f linux.mem --profile="LinuxUbuntu_5_4_0-163-generic_profilex64" linux_bash
# Running processes
vol.py -f linux.mem --profile="LinuxUbuntu_5_4_0-163-generic_profilex64" linux_pslist
# Process Extraction (extract binary process by specifing its PID)
mkdir extracted
vol.py -f linux.mem --profile="LinuxUbuntu_5_4_0-163-generic_profilex64" linux_procdump -D extracted -p PID
# File Extraction (in this case looking for cron files)
vol.py -f linux.mem --profile="LinuxUbuntu_5_4_0-163-generic_profilex64" linux_enumerate_files | grep -i cron 
# Extract specific file by indicating its inode value 0x...
vol.py -f linux.mem --profile="LinuxUbuntu_5_4_0-163-generic_profilex64" linux_find_file -i $INODE -O extracted/elfie


python2 /opt/Hacking/TOOLS/volatility/vol.py -f memdump.elf --profile="Win7SP1x64" -h
# Check files included on the memory damp
python2 /opt/Hacking/TOOLS/volatility/vol.py -f memdump.elf --profile="Win7SP1x64" filescan
# Grep if a specific file is found (hex value id of every file is shown)
python2 /opt/Hacking/TOOLS/volatility/vol.py -f memdump.elf --profile="Win2008R2SP1x64_23418" filescan | grep -i FILE
# Dump a specific file by its hex id, we can rename it and dump it on the current directory)
python2 /opt/Hacking/TOOLS/volatility/vol.py -f memdump.elf --profile="Win7SP0x64" dumpfiles -Q 0x000000001c7e8500 --name file2 -D .


# List possible profiles
volatility -f MEMORY_FILE.raw imageinfo

# Test different profiles to find the good one / View active processes
volatility -f MEMORY_FILE.raw --profile=PROFILE pslist

# View active network connections 
volatility -f MEMORY_FILE.raw --profile=PROFILE netscan

# View intentionally hidden processes
... psxview

# Three columns will appear here in the middle, InLoad, InInit, InMem. If any of these are false, that module has likely been injected which is a really bad thing. 
... ldrmodules

# View unexpected patches in the standard system DLLs
# If we see an instance where Hooking module: <unknown> that's really bad.
... apihooks

# Check code injection and extract it. We can upload them to Virustotal to see the malware (for example, Trojan/Win32.CRIDEX where Cridex is the malware)
... malfind -D $DEST_PATH

# list all of the DLLs in memory
... dlllist

# See/Pull DLLs out of the abnormal process (process PID, optional destination)
volatility -f MEMORY_FILE.raw --profile=PROFILE --pid=PID dlldump (-D <Dest. Dir.>)

#####################
https://github.com/volatilityfoundation/volatility
https://github.com/volatilityfoundation/volatility3 # Faster but fewer plugins
# Installing Volatility 2
git clone <https://github.com/volatilityfoundation/volatility.git> # If Python 2 isn't installed sudo apt install python2 # To Install Pip 2 curl <https://bootstrap.pypa.io/pip/2.7/get-pip.py> -o get-pip.py python2 get-pip.py # Installing distorm 3 and pycryptdome pip2 install distorm3 pycryptodome
# Installing volatility 3
git clone <https://github.com/volatilityfoundation/volatility3> # Installing pycryptodome pip3 install pycryptodome
# Memory dump samples
https://github.com/pinesol93/MemoryForensicSamples
# Virtual Machine Files meaning
https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-CEFF6D89-8C19-4143-8C26-4B6D6734D2CB.html
# VOLATILITY PLUGINS
vol3 banners # symbols, know OS and kernel versions
linux_bash # bash history
netscan / linux_netstat # ports
imageinfo # identify the profile (Win7SP1x64, Win2008R2SP0x64...)
pstree # running processes
strings file.vmem | grep # find some specific strings in memory dump
editbox # which popped up for getting user credentials
filescan # find files from the memory dump
dumpfiles -u -r pst$ -D pst_files # dump all files that end on pst to a directory called pst_files, -r for regex purposes -u unsafe
```

