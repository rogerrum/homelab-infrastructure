# Router Config

The metallb needs BGP for dynamic load balancer ips

### Steps to config Unifi Router

- ssh to cloud key (Find the admin password on the router admin)
  ```
  ssh roger@192.168.1.6
  ```
- Copy **config-gateway.json** to _**/srv/unifi/data/sites/default/**_
- After adding the config.gateway.json to the Controller site of your choosing, you can test it by running a "force
  provision" to the USG in the UniFi Controller Devices > USG > Config > Manage Device > Force provision.

### Temp way to test BGP config prior to prev step

- Login to gateway - get pass from ubnt console
  ```
  ssh admin@192.168.1.1
  ```
- once login use the following
  ```shell
  configure
  set protocols bgp 64501 parameters router-id 192.168.1.1
  set protocols bgp 64501 neighbor 192.168.1.242 remote-as 64500
  commit
  save
  exit
  
  show ip route bgp
  ```


### Reference
  https://community.ui.com/questions/BGP-instructions-for-USG-K8s-MetalLB/b61e2f67-34f2-4571-9140-8d6b9cde2d72
