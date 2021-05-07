yum install zlib -y
yum install gcc -y
yum install libcurl -y
yum install curl-devel -y
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>添加clamav账户>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
groupadd clamav
useradd -g clamav -s /bin/false -c "Clam AntiVirus" clamav

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>安装Clamav>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
tar xvzf clamav-0.103.0.tar.gz
cd clamav-0.103.0
./configure --prefix=/opt/clamav --disable-clamav -with-zlib=/home/nginx/zlib-1.2.8
make
make install

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>配置Clamav>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>创建目录>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
mkdir /opt/clamav/logs
mkdir /opt/clamav/updata

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>创建文件>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
touch /opt/clamav/logs/freshclam.log
touch /opt/clamav/logs/clamd.log

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>查看文件属>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cd /opt/clamav/logs
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>查看文件属主>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
chown clamav:clamav clamd.log
chown clamav:clamav freshclam.log


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>初始化配置文件>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cp /opt/clamav/etc/clamd.conf.sample /opt/clamav/etc/clamd.conf
cp /opt/clamav/etc/freshclam.conf.sample /opt/clamav/etc/freshclam.conf

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>编辑配置文件>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#编辑配置文件
sed -i 's/Example/#Example/g' /opt/clamav/etc/clamd.conf
# vim /opt/clamav/etc/clam.conf
# Example 注释掉这一行

#增加以下内容
echo "LogFile /opt/clamav/logs/clamd.log" >> /opt/clamav/etc/clamd.conf
echo "PidFile /opt/clamav/updata/clamd.pid" >> /opt/clamav/etc/clamd.conf
echo "DatabaseDirectory /opt/clamav/updata"  >> /opt/clamav/etc/clamd.conf

# Example 注释掉这一行
sed -i 's/Example/#Example/g' /opt/clamav/etc/freshclam.conf

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>升级病毒库>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
mkdir -p /opt/clamav/share/clamav
chown clamav:clamav /opt/clamav/share/clamav

/opt/clamav/bin/freshclam