

sudo apt-get install keepalived

#192.168.1.232 - home-lb
#192.168.1.237 - home-lb-pihole


sudo vi /etc/keepalived/notify-haproxy.sh


sudo vi /etc/keepalived/notify-pihole.sh

sudo chmod +x /etc/keepalived/*.sh


sudo vi /etc/keepalived/keepalived.conf

sudo service keepalived start

tail /var/log/syslog
