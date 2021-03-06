#!/bin/sh -eux

# Delete all Linux headers
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers' \
  | xargs apt-get -y purge

# Remove specific Linux kernels, such as linux-image-3.11.0-15-generic but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-generic', etc.
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-.*-generic' \
    | grep -v "$(uname -r)" \
    | xargs apt-get -y purge

# Delete Linux source
dpkg --list \
    | awk '{ print $2 }' \
    | grep linux-source \
    | xargs apt-get -y purge

# Delete development packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-dev$' \
    | xargs apt-get -y purge

# delete docs packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-doc$' \
    | xargs apt-get -y purge

# Delete X11 libraries
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6 || true

# Delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf || true

# Delete oddities
apt-get -y purge popularity-contest installation-report command-not-found command-not-found-data friendly-recovery || true

apt-get -y autoremove
apt-get -y clean

# Remove docs
rm -vrf /usr/share/doc/*

# Remove caches
find /var/cache -type f -exec rm -vrf {} \;

# delete any logs that have built up during the install
find /var/log/ -name '*.log' -exec rm -vf {} \;

# clear authorized keys file
cat /dev/null > /home/ubuntu/.ssh/authorized_keys
