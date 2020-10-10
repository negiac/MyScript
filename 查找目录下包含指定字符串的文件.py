#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-10-09 14:47:03
# @Author  : Your Name (you@example.org)
# @Link    : http://example.org
# @Version : $Id$

import os
import glob

class seachFile(object):
    """docstring for ClassName"""
    def __init__(self, path):
        self.path = path
    def fileList(self,st):
        filelist=[]
        path=self.path
        files=glob.glob(f'{path}/*{st}*', recursive=True)
        # for file in files:
        #     filelist.append(file)
        return files

if __name__ == '__main__':
    st='te'
    a=seachFile(r'f:\1').fileList(st)

    print(a)
