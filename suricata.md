#  Network Monitoring with Suricata

## Overview 
This project demonstrated how to use the open source IDS/IPS **Suricata** for **network monitoring** in a virtualised lab.  The aim is to detect, log and analyse network threats.

## Tools & Technologies
- **VirtualBox** - To run the virtual lab
- **Suricata** - Intrusion Detection & Prevention System
- **Kali Linux** - To simulate a malicious actor
- **Ubuntu** - Suricata and Target machines
-  **nmap** - To scan the Target machine

---

## Lab Setup

### Virtual Machines Configuration

| VM           | OS         | Purpose            | Network Mode    |
|--------------|------------|--------------------|-----------------|
| Suricata IDS | Ubuntu     | Network Monitoring | Bridged         |
| Attacker     | Kali Linux | Simulating Threats | Bridged         |
| Target       | Ubuntu     | Victim Machine     | Bridged         |

- Set **Promiscuous Mode** to **Allow All** under **Network Settings**
- Get the IP addresses for each machine using the `ip addr` command
- Verify connectivity using `ping` between machines e.g. `ping 192.168.1.46`

--- 

## Installing Suricata

On the Suricata VM run the following commands:
``` bash
sudo apt update && sudo apt full upgrade -y
sudo apt install suricata -y 
sudo systemctl enable --now suricata
```

Verify installation:
``` bash
suricata --build-info 
```

## Configuring Suricata
 
Get the interface face (on modern OS its usually enp0s3) using the following command:
```bash 
ip addr
```

Edit the yaml file 

``` bash
sudo nano /etc/suricata/suricata.yaml
```

Find the section beginning with **af-packet** and change the interface:
``` bash 
af-packet
  - interface: <interface>
```
Change the interface to promiscuous mode to capture packets:
``` bash
ip link set <interface> promisc on
```
To check if promiscuous mode is on: 
``` bash
ip link show <interface> 
``` 

Download latest ruleset:
``` bash 
sudo suricata-update 
```

Check that the rules have been downloaded:
``` bash 
ls -l /var/lib/suricata/rules/

There should be a file similar to suricata.rules
``` 

Restart Suricata:
``` bash
sudo systemctl restart suricata
```
Verify rules have loaded
``` bash
sudo suricata -T -c /etc/suricata/suricata/yaml
```

## Testing Suricata
Option 1:
Visit http://testmyids.com 

Option 2:
``` bash 
sudo apt install curl -y 
sudo curl http://testmyids.com
```
---

Check log file:
``` bash
sudo tail -f /var/log/suricata/fast.log

There will be an entry similar/identical to the following:
[1:2100498:7] GPT ATTACK_RESPONSE id check returned root

```

