# Local DNS Config for Ingress

### Steps to config Custom local dns name for Ingress

- This steps require pi-hole
- ssh to Pi-Hole server
  ```
  ssh pi@192.168.1.191
  ```
- Create **reverse-proxied-subdomains** 
  ```shell
  sudo vi /etc/dnsmasq.d/42-reverse-proxied-subdomains.conf
  ```
- Add following data to the new file (Format is - domain followed by the external ingress ip)
  ```text
  address=/k8s.local/192.168.2.2
  address=/k3s.local/192.168.60.150
  address=/rsr.net/192.168.100.150
  ```
- Save and reboot pi-hole

### Reference
  https://discourse.pi-hole.net/t/support-wildcards-in-local-dns-records/32098/11
 
