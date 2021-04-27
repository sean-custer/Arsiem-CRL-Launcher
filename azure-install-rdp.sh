#! /bin/bash
sudo -i
apt-get update
apt-get upgrade -y
apt-get -y install xfce4
apt-get -y install xrdp
systemctl enable xrdp
apt install freerdp2-dev -y
echo xfce4-session >~/.xsession
service xrdp restart
#Only data on the Windows & Ubuntu machine is Wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark > /dev/null
