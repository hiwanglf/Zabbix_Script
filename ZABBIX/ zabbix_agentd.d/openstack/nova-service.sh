#!/bin/bash
# by lengtoo
#====================================================
# for zabbix monitor openstack controller service-list status or num
# UP = up
# DOWN = down
#====================================================

if [ "$1"x = "DOWN"x ];then
	IF_DOWN=`source /etc/kolla/admin-openrc.sh && nova service-list | grep down | awk '{print $4, $6}' | wc -l`
    if [ "$IF_DOWN"x == "0"x ]; then
		echo 0
    else
		source /etc/kolla/admin-openrc.sh && nova service-list | grep down | awk '{printf $4, $6}'
    fi
elif [ "$1"x = "DISABLED"x ];then
        source /etc/kolla/admin-openrc.sh && nova service-list| grep disabled | wc -l
elif [ "$1"x = "COMPUTE-UP"x ];then
	source /etc/kolla/admin-openrc.sh && nova service-list| grep nova-compute |grep enabled | grep up | wc -l
elif [ "$1"x = "CONDUCTOR-UP"x ];then
	source /etc/kolla/admin-openrc.sh && nova service-list| grep nova-conductor|grep enabled | grep up | wc -l
elif [ "$1"x = "SCHEDULER-UP"x ];then
	source /etc/kolla/admin-openrc.sh && nova service-list| grep nova-scheduler|grep enabled | grep up | wc -l
elif [ "$1"x = "CONSOLEAUTH-UP"x ];then
	source /etc/kolla/admin-openrc.sh && nova service-list| grep nova-consoleauth|grep enabled | grep up | wc -l
else
	echo -1
fi
