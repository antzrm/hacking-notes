# 135 - MSRPC

```bash
rpcdump.py $IP -p 135

# RID bruteforce - with creds we can enumerate more users
lookupsid.py user:pass@HOST
cme smb IP -u user -p pass --rid-brute
```

## net rpc

```bash
# Net command
net
net rpc
# Change a user's password
net rpc password $USERNAME_TO_CHANGE_PWD -U '$LOGIN_USER' -S $IP
```

## rpcclient

```bash
    lsaquery: get domain name and SID (Security IDentifier)
    enumalsgroups builtin: list local groups, returns RIDs (Relative IDs)
    queryaliasmem <RID>: list local group members, returns SIDs
    lookupsids <SID>: resolve SID to name
    lookupnames <NAME>: resolve name to SID
    enumdomusers: list users, equivalent to net user /domain
    enumdomgroups: list groups equivalent to net group /domain
    queryuser <rid/name>: obtain info on a user, equivalent to net user <user> /domain
    querygroupmem <rid>: obtain group members, equivalent to net group <group> /domain
    getdompwinfo: get password policy

rpcclient -c "command1,command2" $TARGET_IP
```

## IOXIDResolver

```bash
If the IOXIDResolver service is active and accessible on a windows host, it is possible to find new network endpoints(like IPv6 address) on this last one (via anonymous connection or with credentials). A python script exists to do this task remotly IOXIDResolver-ng.

python IOXIDResolver-ng.py -t $TARGET_IP

# OUTPUT EXEMPLE
[*] Anonymous connection on MSRPC
[+] Retriev Network Interfaces for 192.168.5.20...
[+] ServerAlive2 methode find 3 interface(s)
[+] aNetworkAddr addresse : DC01 (Hostname)
[+] aNetworkAddr addresse : 192.168.5.20 (IPv4)
[+] aNetworkAddr addresse : db69:ecdc:d85:1b54:1676:7fa4:f3fe:4249 (IPv6)
```
