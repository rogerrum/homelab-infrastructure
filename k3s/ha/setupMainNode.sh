#!/bin/bash


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

  #curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.19.7+k3s1  INSTALL_K3S_EXEC="server  --cluster-init  --token $K3S_TOKEN --tls-san rancher-server-1 --tls-san rancher-server-2 --tls-san rancher-server-3 --tls-san rancher.rsr.net --disable servicelb --disable traefik --disable local-storage --flannel-backend=host-gw --node-label k3s-upgrade=enabled " sh -
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server  --cluster-init  --token $K3S_TOKEN --tls-san rancher-server-1 --tls-san rancher-server-2 --tls-san rancher-server-3 --tls-san rancher.rsr.net --disable servicelb --disable traefik --disable local-storage --flannel-backend=host-gw --node-label k3s-upgrade=enabled " sh -

  sudo apt autoremove -fy

  mkdir -p $HOME/.kube
  sudo cp -i /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  sudo chmod -R +r /etc/rancher/k3s/k3s.yaml

  kubectl get nodes -o wide
}


#installFlux() {
#  message "installing installFlux"
#
#  curl -s https://toolkit.fluxcd.io/install.sh | sudo bash
#
#}

installHelm() {
  message "installing installHelm"

  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh

}

installVault() {
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

  sudo apt-get update && sudo apt-get install -fy vault

}

installVelero() {
  wget https://github.com/vmware-tanzu/velero/releases/download/v1.5.3/velero-v1.5.3-linux-amd64.tar.gz
  tar -zxvf velero-v1.5.3-linux-amd64.tar.gz
  sudo mv velero-v1.5.3-linux-amd64/velero /usr/local/bin/
}


token="$(openssl rand -base64 48)"
export K3S_TOKEN=$token
message $token

installPackages
resolvConfig
installK3s
#installFlux
installHelm
installVault
installVelero

message "All Done - Use the token below to setup workers"
sudo cat /var/lib/rancher/k3s/server/node-token


