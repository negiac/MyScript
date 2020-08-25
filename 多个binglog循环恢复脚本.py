#!/usr/bin/env python
#-*-coding:utf-8-*-
import os.path
import datetime
import time
import subprocess
import io
#读取目录下所有binlog的文件名
def binlognamelist(fileBasePath):
        for root,dirs,files in os.walk(fileBasePath):
                if root==fileBasePath:
                #print (files)
                        return files
#写操作
def writeFile(file,content):
        with open(file, 'w') as f:
                f.write(content)



def run(fileBasePath,fileName):

        file=fileBasePath+fileName
        with io.open(file,'r',encoding='utf-8') as f:
                #a为读取文件中的值
                a=f.readline().replace('\n','')

        n=int(a)
        # d=str(n).zfill(6)

        binlogname_list = binlognamelist(fileBasePath)
        #print(len(binlogname_list))
        for x in range(0,len(binlogname_list)):
                # print(x)
                #n值前补0至6位
                d=str(n).zfill(6)
                binlogFileName='mysql-bin.'+d
                #print(binlogFileName)
                #binlogPath=fileBasePath+binlogFileName
                if binlogFileName in binlogname_list:
                        #print (binlogFileName)
                        # 执行sh命令
                        #sh 为shell 命令
                        #sh='ls '+fileBasePath
                        binlogPath=fileBasePath+binlogFileName
                        sh='/home/mysql/mysql/bin/mysqlbinlog --skip-gtids '+binlogPath+' | mysql -f -uroot -p\'JR_11qqAA\' -h127.0.0.1 -P8889 >a.txt'
                        #sh= '/usr/local/mysql/bin/mysqlbinlog --no-defaults mysql-bin.000019 --start-pos=4768240 --stop-pos=4772798 | mysql -f -uroot -ppassword'
                        #sh=r'/usr/local/mysql/bin/mysqlbinlog --no-defaults '+binlogFileName+r' | mysql -f -uroot -p'' -h127.0.0.1'
                #       print (sh)
                #       status=0
                        (status,output) = subprocess.getstatusoutput(sh)
                        print(status)
                        if status==0:
                                print(output)
                                n+=1
                        else:
                                print(output)
                                break
                else:
                        print(d)
                        writeFile(file,d)
                        break


if __name__ == '__main__':
        a=''
        fileBasePath='/home/bak/14756403/'
        #fileBasePath='/home/bak/'
        fileName='binlogNum.txt'
        run(fileBasePath,fileName)