#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

if [ -z "$1" ]
  then
    echo "Missing Token"
    exit 1
fi


message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}


installPackages() {
  message "installing installPackages"

  sudo apt update

  sudo apt upgrade

  sudo apt install -fy  curl wget htop nfs-common


}

resolvConfig() {
  message "Config resolv"
  sudo ln -sfn /run/systemd/resolve/resolv.conf /etc/resolv.conf
}


installK3s() {
  message "installing K3S Cluster"

  curl -sfL https://get.k3s.io | K3S_URL=https://rancher.rsr.net:6443 K3S_TOKEN=$K3S_TOKEN sh -s - --node-taint arm64=true:NoExecute --node-label k3s-upgrade=enabled

  sudo apt autoremove -fy

}


export K3S_TOKEN=$1
installPackages
resolvConfig
installK3s

message "All Done"

