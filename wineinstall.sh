#!/bin/sh
# install script for wine
# add by lvf chongqing yuanxian
sudo apt-get update

#1.install
sudo apt-get -y --force-yes install ttf-mscorefonts-installer
sudo apt-get -y --force-yes install dchroot 
sudo dpkg -i  ./debootstrap_1.0.60cbs1_all.deb

sudo aptitude install python-wxgtk2.8 
sudo aptitude install icoutils 

sudo dpkg -i  ./PlayOnLinux_4.2.12.deb 

if [ ! -d "/var/chroot" ]; then
   sudo mkdir /var/chroot
fi
#2.config schroot
sudo sh -c "cat >> /etc/schroot/schroot.conf << EOF
[nfs_i386]
description=Ubuntu Wine
directory=/var/chroot
users=nfs
groups=sbuild
root-groups=root
EOF"

#3.create sub system
sudo debootstrap --arch=i386 --no-check-gpg pub /var/chroot ftp://update.os.nfschina.com/repo_desktop_2.0

#4.config sources.list
sudo /bin/bash -c "cat > /var/chroot/etc/apt/sources.list << EOF
deb http://us.archive.ubuntu.com/ubuntu/ trusty main 
deb http://am.archive.ubuntu.com/ubuntu/ trusty main 
deb http://cn.archive.ubuntu.com/ubuntu/ trusty main 
deb ftp://update.os.nfschina.com/repo_desktop_1.0/ pub Main Multiverse Restricted Universe
EOF"
[ $? -eq 0 ] && echo "Config sources completed-----------" ||echo "Config sources.list error-----------"
#5.
sudo chroot /var/chroot /bin/bash -c "apt-get update" 
[ $? -eq 0 ] && echo "apt-get update completed-----------" ||echo "apt-get update error-----------"

sudo chroot /var/chroot /bin/bash -c "apt-get  -y --force-yes install  wine1.4-i386  "
[ $? -eq 0 ] && echo "Install sub system dep completed-----------" ||echo "Install sub system dep error-----------"

#6.config env
sudo sed -i '1s#"$#:/var/chroot/usr/bin"#' /etc/environment
sudo sed -i '1a export WINE=/var/chroot/usr/bin/wine' /etc/environment
/bin/sh /etc/environment
cd ~
sudo sed -i '1a export WINE=/var/chroot/usr/bin/wine' ~/.bashrc
source ~/.bashrc
[ $? -eq 0 ] && echo "Config environment completed-----------" ||echo "Config environment error-----------"

#7.config libc.conf
sudo sed -i '1a /var/chroot/usr/lib/i386-linux-gnu' /etc/ld.so.conf.d/libc.conf
[ $? -eq 0 ] && echo "Config libc.conf completed-----------" ||echo "Config libc.conf error-----------"
sudo /sbin/ldconfig -v
[ $? -eq 0 ] && echo "Execute ldconfig completed-----------" ||echo "Execute ldconfig error-----------"

#8.copy files
sudo cp /var/chroot/lib/i386-linux-gnu/libpng12.so.0  /lib32
sudo cp /var/chroot/lib/i386-linux-gnu/libgcrypt.so.11 /lib32
sudo cp /var/chroot/lib/i386-linux-gnu/libcom_err.so.2 /lib32
sudo cp /var/chroot/lib/i386-linux-gnu/libgpg-error.so.0 /lib32
sudo cp /usr/share/fonts/truetype/freefont/FreeSans.ttf /var/chroot/usr/share/wine/fonts/simhei.ttf
sudo cp /usr/share/fonts/truetype/wqy/wqy-zenhei.ttc /var/chroot/usr/share/wine/fonts/simsun.ttc
sudo cp /var/chroot/lib/i386-linux-gnu/libuuid.so.1 /lib32/
sudo cp /var/chroot/lib/i386-linux-gnu/liblzma.so.5 /lib32/
sudo cp /var/chroot/lib/i386-linux-gnu/liblzma.so.5.0.0 /lib32/
[ $? -eq 0 ] && echo "Wine config completed-----------" ||echo "wine config  error-----------"
