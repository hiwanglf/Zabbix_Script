zabbix_script.md
# zabbix说明
> 本文档里面述写了关于zabbix监控Linux OS当中agent的目录里面内容情况，主要包含：一些应用的监控脚本、Zabbix的部分配置文件等。
## 1. 目录结构
- zabbix agent监控端的目录结构示例如下：

```SHELL
/etc/zabbix/
├── zabbix_agentd.conf
└── zabbix_agentd.d
    ├── diskio
    │   └── diskdiscovery.sh
    ├── fping
    │   └── ping_dest.json
    ├── nginx
    │   ├── check_nginx_alive.py
    │   └── nginx_status.sh
    ├── userparameter_diskio.conf
    ├── userparameter_fping.conf
    ├── userparameter_nginx.conf
    └── userparameter_php.conf
```

- 说明：agent的配置文件位于/etc/zabbix目录下，其中zabbix_agentd.conf为配置文件，zabbix_agentd.d是一些agent调用监控的脚本文件。

## 2. 监控脚本
> 使用SHELL或者Python实现，agent和server的模式使用主动模式,全部位于zabbix_agentd.d目录下。

- diskio：用来监控操作Linux的磁盘使用，配合userparameter_diskio.conf使用；
- fping：用来监控Linux与某些主机的网络连通性，配合userparameter_fping.conf使用；
- nginx：用来监控nginx的运行状况，配合serparameter_nginx.conf使用；
- 其他都是这种形式的！

## 3. 监控告警
监控告警的配置位于zabbix server上，告警脚本的位置可以查看zabbix_server.conf里面的配置：
```Shell
# AlertScriptsPath=${datadir}/zabbix/alertscripts
AlertScriptsPath=/usr/lib/zabbix/alertscripts
```
即一般告警脚本的位置在**/usr/lib/zabbix/alertscripts**目录下。

### a. 钉钉告警

### b. 微信告警

### c. 邮件告警

### d. 短信告警
