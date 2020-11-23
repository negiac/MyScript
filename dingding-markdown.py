#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-11-23 16:28:01
# @Author  : Your Name (you@example.org)
# @Link    : http://example.org
# @Version : $Id$
import requests
import json
class dingding(object):
    """docstring for ClassName"""
    # def __init__(self, arg):
    #     super(ClassName, self).__init__()
    #     self.arg = arg
    def msg(self,api_url,text,user):
        headers = {'Content-Type': 'application/json;charset=utf-8'}
        json_text= {
         "msgtype": "markdown",
            "markdown": {
                "title":"zabbix monitor",
                "text": text
            },
            "at": {
                "atMobiles": [
                    user
                ],
                "isAtAll": False
            }
        }

        r=requests.post(api_url,data=json.dumps(json_text),headers=headers).json()
        code = r["errcode"]
        print(code)


if __name__ == "__main__":
    api_url="https://oapi.dingtalk.com/robot/send?access_token=bd543546ebf2537d8ae117127e2444" #webhook地址
    text="可以使用markdown格式(typora):表格示例\n------------------\n|列名1|列明2|列明3|\n|----|----|----|\n|数据1|数据2|数据3|\n|数据5|数据6|数据7|\n"
    user=138xxxxx323 #@ 手机号a
    ding=dingding()
    ding.msg(api_url,text,user)
