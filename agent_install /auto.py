#!/usr/bin/python
# -*- coding: UTF-8 -*-

import platform
import os


# judge the OS is CentOS
def isCentOS():
    result = int(os.system('ls /etc/ | grep hosts'))
    return result


print(isCentOS())



