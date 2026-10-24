#!/bin/bash
# Runs ONCE as root on the instance's first boot (cloud-init).
# Updates the system and installs nginx; launch.sh then uploads the site over SSH.
set -eux
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install -y nginx rsync
systemctl enable --now nginx
# let the ubuntu user deploy without sudo
chown -R ubuntu:ubuntu /var/www/html
echo "<h1>nginx is up - waiting for the site upload</h1>" > /var/www/html/index.html
