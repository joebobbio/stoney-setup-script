#!bin/bash

# Make DNF actually usable
echo -e "max_parallel_downloads=10\ndeltarpm=true" >> test.txt

# Install the RPM Fusion repos
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install app-stream metadata
sudo dnf groupupdate core


# Install TLP
sudo dnf install -y tlp tlp-rdw

# Mask power-profiles-daemon
sudo systemctl mask power-profiles-daemon


# Media Codecs

sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia


# HW VAAPI
sudo dnf -y install intel-media-driver ffmpeg-libs libva libva-utils


flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

sudo dnf install -y git

cd /home/jade

git clone https://github.com/eupnea-linux/audio-scripts
cd audio-scripts
./setup-audio
