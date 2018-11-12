#!/bin/bash
# by lengtoo
#====================================================
# for zabbix monitor openstack controller service-list status or num
# UP = up
# DOWN = down
#====================================================

if [ "$1"x = "ALIVE"x ];then
	IF_DOWN=`source /etc/kolla/admin-openrc.sh && neutron  agent-list | grep xxx | awk -F"|" '{print $4,$7}' | wc -l`
    if [ "$IF_DOWN"x == "0"x ]; then
		echo 0
    else
		source /etc/kolla/admin-openrc.sh && neutron  agent-list | grep xxx | awk -F"|" '{print $4,$7}'
    fi
elif [ "$1"x = "L3-AGENT"x ];then
	source /etc/kolla/admin-openrc.sh && neutron  agent-list | grep ":-)" | grep neutron-l3-agent| wc -l
elif [ "$1"x = "DHCP-AGENT"x ];then
	source /etc/kolla/admin-openrc.sh && neutron  agent-list | grep ":-)" | grep neutron-dhcp-agent| wc -l
elif [ "$1"x = "OPENVSWITCH-AGENT"x ];then
	source /etc/kolla/admin-openrc.sh && neutron  agent-list | grep ":-)" | grep neutron-openvswitch-agent| wc -l
elif [ "$1"x = "METADATA-AGENT"x ];then
	source /etc/kolla/admin-openrc.sh && neutron  agent-list | grep ":-)" | grep neutron-metadata-agent| wc -l
else
	echo -1
fi
