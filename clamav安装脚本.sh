yum install zlib -y
yum install gcc -y
yum install libcurl -y
yum install curl-devel -y
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>���clamav�˻�>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
groupadd clamav
useradd -g clamav -s /bin/false -c "Clam AntiVirus" clamav

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>��װClamav>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
tar xvzf clamav-0.103.0.tar.gz
cd clamav-0.103.0
./configure --prefix=/opt/clamav --disable-clamav -with-zlib=/home/nginx/zlib-1.2.8
make
make install

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>����Clamav>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>����Ŀ¼>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
mkdir /opt/clamav/logs
mkdir /opt/clamav/updata

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>�����ļ�>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
touch /opt/clamav/logs/freshclam.log
touch /opt/clamav/logs/clamd.log

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>�鿴�ļ���>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cd /opt/clamav/logs
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>�鿴�ļ�����>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
chown clamav:clamav clamd.log
chown clamav:clamav freshclam.log


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>��ʼ�������ļ�>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cp /opt/clamav/etc/clamd.conf.sample /opt/clamav/etc/clamd.conf
cp /opt/clamav/etc/freshclam.conf.sample /opt/clamav/etc/freshclam.conf

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>�༭�����ļ�>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#�༭�����ļ�
sed -i 's/Example/#Example/g' /opt/clamav/etc/clamd.conf
# vim /opt/clamav/etc/clam.conf
# Example ע�͵���һ��

#������������
echo "LogFile /opt/clamav/logs/clamd.log" >> /opt/clamav/etc/clamd.conf
echo "PidFile /opt/clamav/updata/clamd.pid" >> /opt/clamav/etc/clamd.conf
echo "DatabaseDirectory /opt/clamav/updata"  >> /opt/clamav/etc/clamd.conf

# Example ע�͵���һ��
sed -i 's/Example/#Example/g' /opt/clamav/etc/freshclam.conf

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>����������>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
mkdir -p /opt/clamav/share/clamav
chown clamav:clamav /opt/clamav/share/clamav

/opt/clamav/bin/freshclam