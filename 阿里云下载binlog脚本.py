#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-08-14 16:46:12
# @Author  : Your Name (you@example.org)

from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.acs_exception.exceptions import ClientException
from aliyunsdkcore.acs_exception.exceptions import ServerException
from aliyunsdkrds.request.v20140815.DescribeBinlogFilesRequest import DescribeBinlogFilesRequest
import json
import os
import datetime
#python 2.7
#import urllib
#python 3.6
import urllib.request
import time


def isNotFileExists(path):
	isExists = os.path.exists(path)
	if not isExists:
		return True
	else:
        # 如果目录存在则不创建，并提示目录已存在
		#print(path+' 文件已经存在')
		return False


def mkdir_save_path(basePath, HostInstanceID):

	path = basePath + '/' + str(HostInstanceID)
	#print (path)
	isExists = os.path.exists(path)
	#print type(isExists)
	# 判断结果
	if not isExists:
    	# 如果不存在则创建目录
    	# 创建目录操作函数
		os.makedirs(path) 
		#print(path+' 创建成功')
		return True
	else:
        # 如果目录存在则不创建，并提示目录已存在
		#print(path+' 目录已存在')
		return False

def alirds_req(pageNum,StartTime,EndTime):
	client = AcsClient('aa', 'aa', 'cn-hangzhou')
	request = DescribeBinlogFilesRequest()
	request.set_accept_format('json')
	request.set_DBInstanceId("rm-bp106u25naaaa65i4maqu")
	# request.set_StartTime("2020-08-16T00:00:00Z")
	# request.set_EndTime("2020-08-17T00:00:00Z")
	#print(StartTime)
	#print(EndTime)
	request.set_StartTime(StartTime)
	request.set_EndTime(EndTime)
	request.set_PageNumber(pageNum)
#	print (request)
	response = client.do_action_with_exception(request)
	return response



#配置starttime和endtime，下载时间区间
date=time.strftime("%Y-%m-%d", time.localtime())
print("start---"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
nowtime=datetime.datetime.now()
date_now=datetime.datetime.now().strftime('%Y-%m-%d')
date_yes=((nowtime+datetime.timedelta(days=-1))).strftime('%Y-%m-%d')
StartTime=str(date_yes)+'T00:00:00Z'
EndTime=str(date_now)+'T00:00:00Z'
# StartTime="2020-08-16T00:00:00Z"
# EndTime="2020-08-17T00:00:00Z"


pageNum=1
#basePath = '/home/bak'
basePath = 'e:/1'
response=alirds_req(pageNum,StartTime,EndTime)
#print (type(response))
json_dump=json.loads(response)

#TotalRecordCount=json_dump.get('TotalRecordCount')
TotalRecordCount =json_dump.get('TotalRecordCount')
PageRecordCount  =json_dump.get('PageRecordCount')
pageNumTotal=0
if TotalRecordCount%PageRecordCount==0:
	pageNumTotal=TotalRecordCount/PageRecordCount
else:
	pageNumTotal=TotalRecordCount//PageRecordCount+1
#print pageNumTotal

pageNum=1

listb=[]
i=0
#for pageNum in xrange(1,pageNumTotal+1):
for pageNum in range(1,pageNumTotal+1):
#	for j in range(0,3):
#	try:
	response=alirds_req(pageNum,StartTime,EndTime)
	#print pageNum
	#print (type(response))
	json_dump=json.loads(response)


	BinLogFile=json_dump.get('Items').get('BinLogFile')
	for x in BinLogFile:
	#print type(x)
		DownloadLink=x.get('DownloadLink')
		HostInstanceID=x.get('HostInstanceID')
		LogFileName=x.get('LogFileName')
		#print (DownloadLink)
		mkdir_save_path(basePath, HostInstanceID)
		path = basePath + '/' + str(HostInstanceID)+'/'+str(LogFileName)
		for j in range(0,3):
			try:
				with open(path, "wb") as f:
					#urllib.request.urlretrieve(DownloadLink,path)
					print (DownloadLink)
					break
			except Exception as e:
				print (e)
				print (DownloadLink)
		i+=1
#		break		
#	except Exception as e:
#		print (e)
#		print (DownloadLink)
		
print("一共"+str(i)+'个文件')
print("END---"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
