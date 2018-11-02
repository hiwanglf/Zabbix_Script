#!/usr/bin/python
# -*- coding: utf-8 -*-
import urllib2
import json
import sys
import datetime
# 默认编码为ascii，转换成utf-8，否则会报错
reload(sys)
sys.setdefaultencoding('utf-8')


####################################
# create by lengtoo
# 2018-08-23
# for zabbix monitor alert
####################################

#=============================================================================
# 参数1：CORPID
# 参数2：SECRET
# 参数3：AGENTID
# 参数4：PATIES
# 参数5：USERS
# 参数6：TAG
# 参数7：MSG
# 注意，某个参数为空时，使用“”代替，参数4/5/6不能全为空,有多个参数的使用'|'分隔开；
#=============================================================================

CORPID  = sys.argv[1]
SECRET  = sys.argv[2]
AGENTID =  sys.argv[3]
PATIES  = sys.argv[4]
USERS   = sys.argv[5]
TAG     = sys.argv[6]
MSG     = str(sys.argv[7])

token_url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid="+CORPID+"&"+"corpsecret="+SECRET
str_res = urllib2.urlopen(token_url).read()
# 将获取的字符串转换为字典
dict_res = json.loads(str_res)
# 从字典中取出TOKEN值
TOKEN = dict_res.get("access_token")
send_url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="+TOKEN
dict_content = {
   "touser": USERS ,
   "toparty": PATIES,
   "totag": TAG,
   "msgtype": "text",
   "agentid": AGENTID,
   "text":{
       "content" : MSG
   },
   "safe":0
}
# 将字典转换为字符串，并转码
str_content = json.dumps(dict_content).decode('unicode_escape')
# 使用post，将消息体推送到服务器
request_data = urllib2.Request(send_url, data=str_content)
post_data = urllib2.urlopen(request_data)
# 日志记录
def save_to_file(file_name, contents):
    f = open(file_name, 'a+')
    f.write(contents)
    f.close()

# 保存告警日志信息文件路径
alert_log_file = "/Users/lengtoo/PycharmProjects/zbx_alert/zabbix_alerts.log"

cur_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
save_to_file(alert_log_file, "\n-------------------------\n")
save_to_file(alert_log_file, cur_time)
save_to_file(alert_log_file, str_content)
