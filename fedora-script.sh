#!/bin/bash


printf 'This script needs to be run as superuser (root on most unix systems)\n'
cd ~/Desktop/

sudo su - root << EOF
echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;

dnf update --refresh -y;

dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin sound-and-video --allowerasing;
dnf group upgrade -y --with-optional Multimedia --allowerasing;
dnf install -y lame\* --exclude=lame-devel ffmpeg-libs libva libva-utils git flatpak;

wget -c https://tree123.org/chrultrabook/stoney-patched-kernel.tar.xz
tar xvf stoney-patched-kernel.tar.xz
cp -r stoney/modules/lib/modules/6.5.6-stoney /lib/modules
printf 'Installing kernel, this may take a bit\n'
kernel-install add 6.5.6-stoney stoney/vmlinuz-6.5.6-stoney

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; flatpak update

git clone https://github.com/WeirdTreeThing/chromebook-linux-audio
cd chromebook-linux-audio;chmod +x setup-audio;./setup-audio
EOF
printf 'Installation finished, please reboot your system\n'
