
# USING SURICATA AS AN IDS 

## Objective: 

This project aims to monitor all network traffic within a virtualised network using Suricata as an Intrusion Detection System (IDS) in promiscuous mode. By enabling promiscuous mode, Suricata captures and analyzes all traffic traversing the network, regardless of destination. To test the effectiveness of Suricata's detection capabilities, various Nmap scans will be used to simulate different types of network attacks and scans e.g. stealth scans. These Nmap scans generate patterns in network traffic that Suricata can identify.
---

## Skills Learned:

- Promiscuous Mode Configuration 
- Custom Rule Creation 
- Nmap Scanning Techniques 
- IDS Configuration and Tuning 

---

## Tools & Technologies:
- **VirtualBox** - To run the virtual lab
- **Suricata** - Intrusion Detection & Prevention System
- **Kali Linux** - To simulate a malicious actor
- **Ubuntu** - Suricata and Target machines
-  **Nmap** - To scan the Target machine

---

## Lab Setup:

### Virtual Machines Configuration:


| VM           | OS         | Purpose            | Network Mode    |
|--------------|------------|--------------------|-----------------|
| Suricata IDS | Ubuntu     | Network Monitoring | Bridged         |
| Attacker     | Kali Linux | Simulating Threats | Bridged         |
| Target       | Ubuntu     | Victim Machine     | Bridged         |

- Set **Promiscuous Mode** to **Allow All** under **Network Settings**
- [VirtualBox Network Settings](Images/network-settings.png)
- Get the IP addresses for each machine using the `ip addr` command
- Verify connectivity using `ping` between machines e.g. `ping 192.168.1.46`

--- 

## Steps: 

### Install Suricata using the following commands or the install-suricata.sh script 
``` bash 
sudo apt update & sudo apt full-upgrade -y
sudo apt install -y suricata 
sudo apt enable --now suricata
sudo suricata --build-info 
```

### Configure Suricata

- Choose the network interface 

```bash 
ip addr
``` 

- Edit the yaml file under af-packet
``` bash
 sudo nano /etc/suricata/suricata.yaml
 af-packet 
    - interface: enp0s3
``` 

- Set the interface to promiscuous mode 
``` bash
ip link set enp0s3 promisc on
```

- Check the interface is set to promiscuous mode
``` bash 
ip link show enp0s3
``` 

- Download the latest ruleset
``` bash 
sudo suricata-update 
``` 
- Check the rules have been downloaded  
``` bash
ls -l /var/lib/suricata/rules 
``` 

- Restart Suricata 
``` bash 
sudo systemctl restart suricata
``` 
- Run Suricata 
``` bash 
sudo suricata -T -c /etc/suricata/suricata.yaml
``` 

### Test Suricata
``` bash 
sudo curl http://testmyids.com
``` 
``` bash
sudo tail -f /var/log/suricata/fast.log
``` 
### Result from testmyids.com 

02/05/2025-19:54:18.380567  [**] [1:2100498:7] GPL ATTACK_RESPONSE id check returned root [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 2001:08d8:100f:f000:0000:0000:0000:0208:80 -> 2a02:6b67:e078:9300:be56:c046:e5b1:a146:57262
