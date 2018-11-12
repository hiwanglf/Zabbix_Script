#! /bin/bash
# create by lengtoo 
# 2018-06-11
# auto start zabbix-agent
systemctl stop zabbix-agent
mkdir /var/run/zabbix
chmod 777 /var/run/zabbix
touch /var/run/zabbix/zabbix_agentd.pid
chmod 777 /var/run/zabbix/zabbix_agentd.pid
systemctl start zabbix-agent
service zabbix-agent start