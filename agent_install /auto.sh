#!/bin/bash
# written by lengtoo

##
echo “1.上载软件包”

echo “2.安装软件”
rpm -ivh bc-1.06.95-13.el7.x86_64.rpm
rpm -ivh libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm
rpm -ivh unixODBC-2.2.14-12.el6_3.x86_64.rpm
rpm -ivh zabbix-agent-3.0.1-2.el6.x86_64.rpm
rpm -ivh lm_sensors-libs-3.4.0-4.20160601gitf9185e5.el7.x86_64.rpm
rpm -ivh sysstat-10.1.5-11.el7.x86_64.rpm


echo “3.删除上载的软件包”
rm -f sysstat-10.1.5-11.el7.x86_64.rpm zabbix-agent-3.0.1-2.el6.x86_64\(1\).rpm lm_sensors-libs-3.4.0-4.20160601gitf9185e5.el7.x86_64.rpm
rm -f bc-1.06.95-13.el7.x86_64.rpm libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm unixODBC-2.2.14-12.el6_3.x86_64.rpm zabbix-agent-3.0.1-2.el6.x86_64\(1\).rpm
rm -f zabbix-agent-3.0.1-2.el6.x86_64.rpm
systemctl start sysstat


echo “修改/etc/sudoers,给zabbix用户添加sudo权限”
echo "zabbix  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
chmod +r /etc/ssh/sshd_config

HOSTNAME=`hostname`

rm -f /etc/zabbix/zabbix_agentd.conf
rm -f /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf

cat >  /etc/zabbix/zabbix_agentd.conf  << EOF
Server=119.254.101.145
ServerActive=119.254.101.145
Hostname=$HOSTNAME
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
DebugLevel=3
LogFileSize=10
Include=/etc/zabbix/zabbix_agentd.d/*.conf
HostMetadataItem=system.uname
Timeout=30
StartAgents=0
EnableRemoteCommands=1
RefreshActiveChecks=60
BufferSize=1000
MaxLinesPerSecond=100
EOF

mkdir /etc/zabbix/zabbix_agentd.d/diskio
cat >  /etc/zabbix/zabbix_agentd.d/diskio/diskdiscovery.sh  << EOF
#!/bin/bash
 diskarray=(`cat /proc/diskstats |grep -E "\bsd[a-z]\b|\bxvd[a-z]\b|\bvd[a-z]\b"|awk '{print $3}'|sort|uniq   2>/dev/null`)

 length=${#diskarray[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
        printf '\n\t\t{'
        printf "\"{#DISK_NAME}\":\"${diskarray[$i]}\"}"
        if [ $i -lt $[$length-1] ];then
                printf ','
        fi
done
printf  "\n\t]\n"
printf "}\n"
EOF

chmod +x /etc/zabbix/zabbix_agentd.d/diskio/diskdiscovery.sh

cat >  /etc/zabbix/zabbix_agentd.d/userparameter_diskio.conf << EOF
UserParameter=disk.discovery, /bin/bash /etc/zabbix/zabbix_agentd.d/diskio/diskdiscovery.sh
UserParameter=disk.transport.persecond[*], iostat -d | grep $1 | head -1 | awk '{print $$2}'
UserParameter=disk.read.persecond[*], iostat -d | grep $1 | head -1 | awk '{print $$3}'
UserParameter=disk.write.persecond[*], iostat -d | grep $1 | head -1 | awk '{print $$4}'
UserParameter=disk.allread.persecond[*], iostat -d | grep $1 | head -1 | awk '{print $$5}'
UserParameter=disk.allwrite.persecond[*], iostat -d | grep $1 | head -1 | awk '{print $$6}'
UserParameter=disk.rsec.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$4}'
UserParameter=disk.wsec.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$5}'
UserParameter=disk.rrequ.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$6}'
UserParameter=disk.wrequ.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$7}'
UserParameter=disk.avgrq.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$8}'
UserParameter=disk.avqu.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$9}'
UserParameter=disk.await.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$10}'
UserParameter=disk.svctm.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$13}'
UserParameter=disk.util.persecond[*], iostat -x | grep $1 | head -1 | awk '{print $$14}'
EOF

mkdir /var/run/zabbix
chmod 777 /var/run/zabbix
touch /var/run/zabbix/zabbix_agentd.pid
chmod 777 /var/run/zabbix/zabbix_agentd.pid
systemctl enable zabbix-agent
systemctl stop zabbix-agent
systemctl start zabbix-agent
service zabbix-agent start
systemctl status zabbix-agent
