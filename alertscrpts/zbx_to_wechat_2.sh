#!/bin/bash
# create by lengtoo mail is hiwanglf@163.com
# date 2018-08-21
# This shell script use in zabbix alerting to your wechat;
# 相关微信文档参考：
# https://work.weixin.qq.com/api/doc#10167
# https://work.weixin.qq.com/api/doc#10013

# 参数1：CORPID
# 参数2：SECRET
# 参数3：AGENTID
# 参数4：PATIES
# 参数5：USERS
# 参数6：TAG
# 参数7：MSG
# 注意，某个参数为空时，使用“”代替，参数4/5/6不能全为空,有多个参数的使用'|'分隔开；

#CORPID 在企业微信->我的企业->企业ID
CORPID=$1
#SECRECT 在企业微信->应用与小程序->自建的应用 Secret
SECRECT=$2

URL_TOKEN="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CORPID&corpsecret=$SECRECT"
#通过HTTP GET方式获取ACCESS_TOKEN
ACCESS_TOKEN=`/usr/bin/curl -s -G $URL_TOKEN | awk -F\" '{print $10}'` >>/var/log/zabbix/zabbix_alert.log
URL_POST="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$ACCESS_TOKEN"
#创建函数，生成格式化的消息体

function CONTENT(){
		# 需要发送给的AGENTID
		local AGENTID=$1
		# 需要发送消息的部门ID
		local PARTIES=$2
		# 需要发送的用户
		local USERS=$3
		# TAG
		local TAG=$4
		# 消息内容
        local MSG=$(echo "$5")
        printf '{\n'
        printf '\t"touser"   : "'$USERS'\" ,\n'
        printf '\t"toparty"  : "'$PARTIES'\" ,\n'
        printf '\t"togag"    : "'"$TAG"'\" ,\n'
		printf '\t"msgtype"  : "text",\n'
        printf '\t"agentid"  : '$AGENTID',\n'
        printf '\t"text"     : {\n'
        printf '\t\t"content": "'"$MSG"\"'\n'
        printf '\t},\n'
        printf '\t"safe"     : 0\n'
        printf '}\n'
}
#告警消息写入日志
printf "\n------------------------------------------------------------------------\n" >>/var/log/zabbix/zabbix_alert.log

echo $(date)  >> /var/log/zabbix/zabbix_alert.log

CONTENT $3 $4 $5 $6 $7 >>  /var/log/zabbix/zabbix_alert.log
#发送状态写入日志
STATUS=`/usr/bin/curl --data-ascii "$(CONTENT $1 $2 $3)" $URL_POST` >> /var/log/zabbix/zabbix_alert.log
