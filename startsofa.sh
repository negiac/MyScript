#!/usr/bin/expect
set timeout 30
set check "check -b\n"
set in1 "install -b file:///home/etcplatform/fujian-1.0-ark-biz.jar\n"
set in2 "install -b file:///home/etcplatform/guizhou-1.0-ark-biz.jar\n"
set in3 "install -b file:///home/etcplatform/guizhou-ccb-1.0-ark-biz.jar\n"
set in4 "install -b file:///home/etcplatform/jiangsu-1.0-ark-biz.jar\n"
set in5 "install -b file:///home/etcplatform/guangdong-1.0-ark-biz.jar\n"
spawn telnet localhost 1234
expect "sofa-ark*" {send $in1}
sleep 8
expect "sofa-ark*" {send $in2}
sleep 8
expect "sofa-ark*" {send $in3}
sleep 8
expect "sofa-ark*" {send $in4}
sleep 8
expect "sofa-ark*" {send $in5}
sleep 8
expect "sofa-ark*" {send $check}
#interact
expect eof
