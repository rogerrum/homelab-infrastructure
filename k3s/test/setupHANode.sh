#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
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

  sudo apt install -fy  curl wget htop nfs-common qemu-guest-agent

  sudo apt-get install -fy linux-modules-extra-$(uname -r)

}

resolvConfig() {
  message "Config resolv"
  sudo ln -sfn /run/systemd/resolve/resolv.conf /etc/resolv.conf
}


installK3s() {
  message "installing K3S Cluster"

  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --token $K3S_TOKEN --server https://192.168.50.205:6443 --disable servicelb --disable traefik --disable local-storage --flannel-backend=host-gw --node-label k3s-upgrade=enabled " sh -

  sudo apt autoremove -fy

  mkdir -p $HOME/.kube
  sudo cp -i /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  sudo chmod -R +r /etc/rancher/k3s/k3s.yaml

  kubectl get nodes -o wide
}

installHelm() {
  message "installing installHelm"

  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh

}

export K3S_TOKEN=$1

installPackages
resolvConfig
installK3s
installHelm

message "All Done - Use the token below to setup workers"
sudo cat /var/lib/rancher/k3s/server/node-token




