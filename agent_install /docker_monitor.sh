#!/bin/bash

###########################
Docker Monitor
###########################
DOCKER=`docker ps | awk -F ' ' '{print "\t""\047"  $1 "\047"    ": " "\047" $NF "\047," }'`
mkdir /etc/zabbix/zabbix_agentd.d/docker
cat > /etc/zabbix/zabbix_agentd.d/docker/instance.py << EOF
#!/usr/bin/env python
# coding=utf8

## By Lengtoo
## 2017 6 27

import commands

## The containers need monitor should be listed in dict;
Containers = {
EOF

docker ps | awk -F ' ' '{print "\t""\047"  $1 "\047"    ": " "\047" $NF "\047," }' > /etc/zabbix/zabbix_agentd.d/docker/container.list
cat /etc/zabbix/zabbix_agentd.d/docker/container.list >> /etc/zabbix/zabbix_agentd.d/docker/instance.py

cat >> /etc/zabbix/zabbix_agentd.d/docker/instance.py << EOF
}

flag = 0
msg = "\n"
(runstat, stats) = commands.getstatusoutput('sudo docker stats --no-stream')
if runstat == 0:
    info = str(stats).split()
    for key in Containers.keys():
        if key not in info:
            flag = flag + 1
            msg = msg + str(Containers[key]) + "\n"
    if flag == 0:
        print "1"
    else:
        print msg
else:
    print "Script Run Error"
EOF

cat > /etc/zabbix/zabbix_agentd.d/docker/status.sh << EOF
#! /bin/bash

# by lengtoo
# date 2017 6 26
function docker_service() {
## 1= has docker process
## 0= no docker process
if
sudo systemctl status docker | grep "active (running)">>/dev/null
then
    echo "1"

else
    echo "0"
fi

}
STATUS="docker_service";
$STATUS
EOF

cat >  /etc/zabbix/zabbix_agentd.d/userparameter_docker.conf << EOF
UserParameter=docker.service.status, /bin/bash /etc/zabbix/zabbix_agentd.d/docker/status.sh
UserParameter=docker.service.instance, /usr/bin/python /etc/zabbix/zabbix_agentd.d/docker/instance.py
EOF

chmod +x /etc/zabbix/zabbix_agentd.d/docker/status.sh
chmod +x /etc/zabbix/zabbix_agentd.d/docker/instance.py
systemctl stop zabbix-agent
systemctl start zabbix-agent
systemctl status zabbix-agent
