#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-10-09 10:41:20
# @Author  : Your Name (you@example.org)
# @Link    : http://example.org
# @Version : $Id$


import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import sys
import os
#from glob import glob  python3.7
import glob2 as glob
import time
from datetime import date, timedelta
import datetime


class sendmail(object):
    """docstring for sendmail"""
    def __init__(self,mailto_list,mail_host,mail_user,mail_pass):
        self.mailto_list = mailto_list
        self.mail_host = mail_host
        self.mail_user = mail_user
        self.mail_pass= mail_pass



# 参数：收件人，主题，正文，文件名集合（可发送多个文件），文件路径（文件在同一个路径）
    def send_mail(self,sub,content,files,path):
        mailto_list = self.mailto_list
        mail_host =     self.mail_host
        mail_user =     self.mail_user
        mail_pass =     self.mail_pass

        me = sub + "<" + mail_user + ">"
        msg = MIMEMultipart()
        msg.attach(MIMEText(content, _subtype='html', _charset='utf-8'))
        msg['Subject'] = sub
        msg['From'] = me
        msg['To'] = ",".join(mailto_list)  # 将收件人列表以‘,’分隔
        for file in files:
            if os.path.isfile(path + '/' + file):
                # 构造附件
                att = MIMEText(open(path + '/' + file, 'rb').read(), 'base64', 'utf-8')
                att["Content-Type"] = 'application/octet-stream'
                att.add_header("Content-Disposition", "attachment", filename=("gbk", "", file))
                msg.attach(att)
        try:
            #server = smtplib.SMTP()
            server = smtplib.SMTP_SSL(mail_host)
            # if mail_host == 'smtp.gmail.com':
            #     server.connect(mail_host, port=587)  # 连接服务器
            #     server.starttls()
            # else:
            #     server.connect(mail_host)
            server.login(mail_user, mail_pass)  # 登录操作
            server.sendmail(me, mailto_list, msg.as_string())
            server.close()
            print('Mail sent successfully')
            return True
        except Exception as e:
            print('Mail sent failed')
            print(sys.exc_info()[0], sys.exc_info()[1])
            return False

class seachFile(object):
    """docstring for ClassName"""
    def __init__(self, path):
        self.path = path
    def fileList(self,st):
        filelist=[]
        path=self.path
        #files=glob.glob(f'{path}/*{st}*', recursive=True) #python 3.7
	
        files=glob.glob(path+r"/"+st+r'-*')
	print (files)
        for file in files:
            filepath, filename = os.path.split(file)
        # for file in files:
            filelist.append(filename)
        return filelist




if __name__ == '__main__':
    date=time.strftime("%Y-%m-%d", time.localtime())
    nowtime=datetime.datetime.now()
    date_yes=((nowtime+datetime.timedelta(days=-1))).strftime('%Y%m%d')
    date_week_ago=(nowtime+datetime.timedelta(days=-7)).strftime('%Y%m%d')
    
    mailto_list = ['zhangsan@group.cn','lisi@group.cn','wangwu@group.cn'] # 收件人列表，以英文逗号分隔
    mail_host = "smtp.exmail.qq.com"  # 使用的邮箱的smtp服务器地址
    mail_user = "aa@sygroup.cn"  # 用户名
    mail_pass = "aaaaa"  # 授权码，不是密码，授权码要在邮箱设置中获取  我用的是密码
    path = r"/root/baobiao/khxx"  #文件目录
    sub = "客户信息" # 邮件标题
    content = "注:带Except字样的文件为除浙通卡,苏通卡外其他卡用户文件"  # 邮件内容
    st= date    # 文件名包含的字符串
    files_a = seachFile(path)
    files=files_a.fileList(st)
    s=sendmail(mailto_list,mail_host,mail_user,mail_pass)
    s.send_mail(sub, content, files, path)  # 发送/home/data文件夹下面两个文件
