#!/bin/bash
yum install java-1.8.0-openjdk.x86_64 wget -y
mkdir -p /opt/nexus/
mkdir -p /tmp/nexus/
cd /tmp/nexus
NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
wget $NEXUSURL -O nexus.tar.gz
EXTOUT='tar xzvf nexus.tar.gz'
NUXUSDIR='echo $EXTOUT | cut -d '/' -f1'
rm -rf /tmp/nexus/nexus/ /opt/nexus/
useradd nexus
chown -R nexus.nexus /opt/nexus/
cat <<EOT>> /etc/sustemd/system/nexus.service
[Unit]
Description=nexus service
AFter=network.target

[Service]Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start
ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.targett

EOT

echo 'run_as_user="nexus"' > /opt/nexus/$NEXUSDIR/bin/nexus.rc
systemctl daemon-reload
systemctl start nexus
systemctl enable nexus







