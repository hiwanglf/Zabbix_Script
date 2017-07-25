#!/usr/bin/env python
# coding=utf8

## By Lengtoo
## 2017 6 27

import commands

## The containers need monitor should be listed in dict;
Containers = {
    '21458c380527': "zabbix",
    '44f2ccad4de5': "zabbix-mysql",
    'saadwweaddaa':'test1',
    '22dasdse3da2':'test2',
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

