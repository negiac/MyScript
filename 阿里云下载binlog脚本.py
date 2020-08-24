#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-08-14 16:46:12
# @Author  : negiaC

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

class binlogDownLoad(object):
	"""docstring for ClassName"""
	def __init__(self):
		self.accessKeyId ='xxxxxxx'
		self.accessSecret='xxxxxxx'
		self.RegionId='cn-hangzhou'
		self.accept_format='json'
		self.DBInstanceId='rm-xxxxxxxx'

		
	def isNotFileExists(self,path):
		if os.path.exists(path):
			return False
		else:
			return True
	def downLoad(self,path,DownloadLink):
		with open(path, "wb") as f:
			#urllib.request.urlretrieve(list_DownloadLink,path)
			#2.7
			#urllib.request.urlretrieve(DownloadLink,path)
			#3.6

			#urllib.request.urlretrieve(DownloadLink,path)					
			#print (DownloadLink)
			print (path)

	def mkdir_save_path(self,basePath, HostInstanceID):

		path = basePath + '/' + str(HostInstanceID)
		#print (path)
		isExists = os.path.exists(path)
		#print type(isExists)
		# 判断结果
		if not isExists:
			# 如果不存在则创建目录
			os.makedirs(path) 
			#print(path+' 创建成功')
			return True
		else:
			# 如果目录存在则不创建，并提示目录已存在
			#print(path+' 目录已存在')
			return False

	def alirds_req(self,pageNum,StartTime,EndTime):
		client = AcsClient(self.accessKeyId, self.accessSecret, self.RegionId)
		request = DescribeBinlogFilesRequest()
		request.set_accept_format(self.accept_format)
		request.set_DBInstanceId(self.DBInstanceId)
		# request.set_StartTime("2020-08-16T00:00:00Z")
		# request.set_EndTime("2020-08-17T00:00:00Z")
		request.set_StartTime(StartTime)
		request.set_EndTime(EndTime)
		request.set_PageNumber(pageNum)
	#	print (request)
		response = client.do_action_with_exception(request)
		return response



	#配置starttime和endtime，下载时间区间



	def allPageNume(self,pageNum,StartTime,EndTime):
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

		return pageNumTotal


	def downLoadLogFile(self,pageNumTotal,StartTime,EndTime,basePath):
		i=0
		for pageNum in range(1,pageNumTotal+1):
			for j in range(0,3):
				try:
					response=alirds_req(pageNum,StartTime,EndTime)
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
						#判断文件是否存在
						if isNotFileExists(path)==True:
							downLoad(path,DownloadLink)
							i+=1
					break		
				except Exception as e:
					print (e)

		print("一共"+str(i)+'个文件')
	#判断时间格式参数
	def is_valid_date(self,str):
	  '''判断是否是一个有效的日期字符串'''
	  try:
	    time.strptime(str, "%Y-%m-%dT%H:%M:%SZ")
	    return True
	  except:
	    return False

	#获取时间1、不传入，为前一天零点到今天零点，2 ，传入参数，格式传入起止时间：'0000-00-00T00:00:00Z' '1111-11-11T00:00:00Z'
	def timeZone(self):
	    print (sys.argv)
	    if len(sys.argv)>2:
	        arg1=sys.argv[1]
	        arg2=sys.argv[2]
	        StartTime=''
	        EndTime=''
	        if is_valid_date(arg1)==True and is_valid_date(arg2)==True:
	            StartTime=arg1
	            EndTime=arg2
	        else:
	            print("请查看输入的时间格式是否正确")
	    else:
	        date=time.strftime("%Y-%m-%d", time.localtime())
	        nowtime=datetime.datetime.now()
	        date_now=datetime.datetime.now().strftime('%Y-%m-%d')
	        date_yes=((nowtime+datetime.timedelta(days=-1))).strftime('%Y-%m-%d')
	        StartTime=str(date_yes)+'T00:00:00Z'
	        EndTime=str(date_now)+'T00:00:00Z'
	    return (StartTime,EndTime)




if __name__ == '__main__':
	basePath = '/home/bak1'
	i=0
	pageNum=1
	print("start---"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
	t=binlogDownLoad()
	(StartTime,EndTime)=t.timeZone()
	print(StartTime)
	print(EndTime)
	#for pageNum in xrange(1,pageNumTotal+1):
	pageNumTotal=t.allPageNume(pageNum,StartTime,EndTime)
	t.downLoadLogFile(pageNumTotal,StartTime,EndTime,basePath)
	print("END---"+datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))