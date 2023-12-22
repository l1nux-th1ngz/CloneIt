#!/bin/bash

# Update the package lists for upgrades and new package installations
sudo apt-get update

# Install git, unzip, and wget
sudo apt-get install -y git unzip wget

# Download the latest version of Gitea
wget -O gitea https://dl.gitea.io/gitea/latest/gitea-linux-amd64

# Make the downloaded file executable
chmod +x gitea

# Move Gitea to the /usr/local/bin directory
sudo mv gitea /usr/local/bin

# Create the necessary directories for Gitea
sudo mkdir -p /var/lib/gitea/{custom,data,indexers,public,log}
sudo chown -R git:git /var/lib/gitea/
sudo chmod -R 750 /var/lib/gitea/
sudo mkdir /etc/gitea
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea

# Create a new service file for Gitea
sudo bash -c 'cat > /etc/systemd/system/gitea.service << EOF
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
After=mysql.service
#After=postgresql.service
#After=memcached.service
#After=redis.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea
# If you want to bind Gitea to a port below 1024 uncomment
# the two values below
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE
EOF'

# Start and enable the Gitea service
sudo systemctl start gitea
sudo systemctl enable gitea
