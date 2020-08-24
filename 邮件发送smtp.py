#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-07-10 17:56:23
# @Author  : Your Name (you@example.org)
# @Link    : http://example.org
# @Version : $Id$

import smtplib
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication

if __name__ == '__main__':
        fromaddr = 'xxx@xxx.cn'
        password = 'xxxxxx'
        toaddrs = ['xxxx@163.com','xxxx@qq.com']

        content = '邮件内容haodo a aa a a  '
        textApart = MIMEText(content,'html','utf-8')

        #imageFile = '图片路径'
        #imageApart = MIMEImage(open(imageFile, 'rb').read(), imageFile.split('.')[-1])
        #imageApart.add_header('Content-Disposition', 'attachment', filename=imageFile)

        pdfFile = 'sql1.csv'
        pdfApart = MIMEApplication(open(pdfFile, 'rb').read())
        pdfApart.add_header('Content-Disposition', 'attachment', filename=pdfFile)


       #zipFile = '压缩包路径'
       #zipApart = MIMEApplication(open(zipFile, 'rb').read())
       #zipApart.add_header('Content-Disposition', 'attachment', filename=zipFile)

        m = MIMEMultipart()
        #m.attach(textApart)
        # m.attach(imageApart)
        m.attach(pdfApart)
        # m.attach(zipApart)
        m['Subject'] = '邮件标题'

        try:
            server = smtplib.SMTP_SSL('smtp.exmail.qq.com')
            server.login(fromaddr,password)
            server.sendmail(fromaddr, toaddrs, m.as_string())
            print('success')
            server.quit()
        except smtplib.SMTPException as e:
            print('error:',e) #打印错误
