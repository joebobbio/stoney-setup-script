#!/bin/bash


printf 'This script needs to be run as superuser (root on most unix systems)\n'
cd ~/Desktop/

sudo su - root << EOF
echo "max_parallel_downloads=10\ndeltarpm=true" >> /etc/dnf/dnf.conf

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;

dnf update --refresh -y;

dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin sound-and-video;
dnf group upgrade --with-optional Multimedia;
dnf install -y tlp tlp-rdw lame\* --exclude=lame-devel intel-media-driver ffmpeg-libs libva libva-utils git;
sudo systemctl mask power-profiles-daemon;

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; flatpak update

git clone https://github.com/eupnea-linux/audio-scripts
cd audio-scripts;chmod+x setup-audio;./setup-audio
EOF
printf 'Installation finished, please reboot your system\n'
