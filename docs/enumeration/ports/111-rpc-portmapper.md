# 111 - RPC / PortMapper


```bash
nc -nv $IP 111
nmap -p 111 --script=nfs-ls,nfs-statfs,nfs-showmount 10.10.0.0
rpcinfo -s $IP

# Impacket’s rpcdump.py enumerates Remote Procedure Call (RPC) endpoints
python3 rpcdump.py test.local/john:password123@10.10.10.1
```


## Exploits

```bash
https://www.thehacker.recipes/ad/movement/mitm-and-coerced-authentications/ms-rprn

# PrintNightmare
https://github.com/cube0x0/CVE-2021-1675
https://0xdf.gitlab.io/2021/07/08/playing-with-printnightmare.html
```
