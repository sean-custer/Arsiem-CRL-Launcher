#! /bin/bash
sudo -i
apt-get update
apt-get upgrade -y
apt-get -y install xfce4
apt-get -y install xrdp
systemctl enable xrdp
apt install freerdp2-dev -y

echo xfce4-session >~/.xsession
sudo service xrdp restart
apt-get install gcc-6 g++-6 libossp-uuid-dev libavcodec-dev libpango1.0-dev libssh2-1-dev libcairo2-dev libjpeg-turbo8-dev libpng-dev libavutil-dev libswscale-dev libfreerdp-dev libvncserver-dev libssl-dev libvorbis-dev libwebp-dev -y
apt-get install tomcat8 tomcat8-admin tomcat8-common tomcat8-user -y
wget http://apachemirror.wuchna.com/guacamole/1.1.0/source/guacamole-server-1.1.0.tar.gz
tar -xvzf guacamole-server-1.1.0.tar.gz
cd guacamole-server-1.1.0
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig
systemctl enable guacd
systemctl start guacd
wget https://mirrors.estointernet.in/apache/guacamole/1.1.0/binary/guacamole-1.1.0.war
mkdir /etc/guacamole
mv guacamole-1.1.0.war /etc/guacamole/guacamole.war
ln -s /etc/guacamole/guacamole.war /var/lib/tomcat8/webapps/
systemctl restart tomcat8
systemctl restart guacd
cd ..
git clone https://github.com/sean-custer/Arsiem-Guac-files.git
mv /Arsiem-Guac-files/guacamole.properties /etc/guacamole/
mkdir /etc/guacamole/{extensions,lib}
echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/tomcat8
mv /Arsiem-Guac-files/user-mapping.xml /etc/guacamole/
#wait... 10 min
systemctl restart tomcat8
systemctl restart guacd
#Chrome installation for testing
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo apt install ./google-chrome-stable_current_amd64.deb -y