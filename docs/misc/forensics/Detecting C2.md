# Detecting C2 with RITA
Real Intelligence Threat Analytics (RITA) is an open-source framework created by Active Countermeasures. Its core functionality is to detect command and control (C2) communication by analyzing network traffic captures and logs. Its primary features are:

- C2 beacon detection
- DNS tunneling detection
- Long connection detection
- Data exfiltration detection
- Checking threat intel feeds
- Score connections by severity
- Show the number of hosts communicating with a specific external IP
- Shows the datetime when the external host was first seen on the network

RITA only accepts network traffic input as **Zeek** logs. **Zeek** is an open-source **network security monitoring (NSM)** tool. Zeek is not a firewall or IPS/IDS; it does not use signatures or specific rules to take an action. It simply observes network traffic via configured SPAN ports (used to copy traffic from one port to another for monitoring), physical network taps, or imported packet captures in the PCAP format.
## Parse PCAP to Zeek format
`zeek readpcap <pcapfile> <outputdirectory>`
## Import Zeek Logs on RITA
```sh
rita import --logs ~/zeek_logs/asyncrat/ --database asyncrat

# Now that RITA has parsed and analyzed our data, we can view the results by entering the command
rita view <database-name>
rita view asyncrat

# The terminal window has a search bar
To search, we need to enter a forward slash (/). 
We can then enter our search term and narrow down the results. 
The search utility supports the use of search fields. When we enter `?` while in search mode, we can see an overview of the search fields, alongside some examples.

src:192.168.88.2 dst:c2.malware.net beacon:>=70 sort:duration-desc
```

