#!/bin/bash

HOSTNAME="IP��ַ"
PORT="3306"
USERNAME="username"
PASSWORD="passwd"
path="/root/script/data/"
DATE=$(date +"%Y-%m-%d")
CSVNAME=$path$DATE"00.csv"
CSVNAME01=$path$DATE"03.csv"
CSVNAME02=$path$DATE".csv"

echo "$CSVNAME"
echo $DATE "###############################"

DATE_YES=$(date -d "-0 days" +"%Y-%m-%d")
DATE_WEEK_BEF=$(date -d "-8 days" +"%Y-%m-%d")
echo "Begin to Export data $DATE_WEEK_BEF -- $DATE_YES"
sql="select * from ( select  ''  as 'ETCЭ����(����)',' ' as 'һ������������',5 as 'Э��״̬',5 as '֧��Э������', concat('\'',c.\`cardNO\`) as 'ETC����',98 as '��������',2 as 'OBU����',3 as '����ģʽ',440101 as '���з����' , '��
�����л���' as '���з�����',DATE_FORMAT(c.\`createTime\`,'%Y-%m-%d') as '��������',DATE_FORMAT(c.\`createTime\`,'%H.%i.%S') as '����ʱ��',concat('\'','6222450015809110' ) as 'ǩԼ����',concat('\'',(SELECT VALUE FROM jrtfs_crm3.comp_company_data_tree WHERE company_id = b.company_id AND company_template_field_id = 293 )) as '�������֤����',(SELECT VALUE FROM jrtfs_crm3.comp_company_data_tree WHERE company_id = b.company_id AND company_template_field_id = 290 ) as '�������֤����',  c.\`plateNumber\` as '���ƺ���' ,2  as '�Ƿ�Ӫ�˳���',b.\`phone\` as '����Ԥ���ֻ��ţ������ֻ�
�ţ�',a.\`bank_marketing_code\` as 'Ӫ������',a.\`bank_marketing_code\`  as 'ͳһ��֤��',' ' as 'Ӫ����Ա�ֻ���',DATE_FORMAT(c.\`createTime\`,'%Y-%m-%d') as '��������',DATE_FORMAT(c.\`createTime\`,'%H.%i.%S') as '����޸�����',35008 as '��ע3',case e.\`vehicle_class\` when '��һ' then '011' when '����' then '012' when '����' then '013' when '����
' then '014' when '����' then '015' when '����' then '016' when 'רһ' then '021' when 'ר��' then '022' when 'ר��' then '023' when 'ר��' then '024' when 'ר��' then '025' when 'ר��' then '026'  else e.\`vehicle_class\`  end as '�շѳ���',c.\`plateColor\` as '������ɫ',concat('\'',c.obuId) as 'OBUID' FROM \`jrtfs_crm3\`.sys_client a ,\`jrtfs_crm3\`.comp_company  b ,\`jrtfs_etc3\`.\`card\` c,\`jrtfs_etc3\`.\`product\` d , jrtfs_crm3.\`customer_vehicle\` e,jrtfs_crm3.\`application_order_detail\` f WHERE a.\`client_id\` = b.\`client_id\` AND c.\`customerCode\` = b.code AND c.\`productId\` = d.\`productId\` AND d.\`productId\` IN (37,38)   AND d.businesstype = 'StoredValueMargin' AND c.\`isDeleted\` != 1 AND e.\`plate_no\` = c.\`plateNumber\` AND e.\`plate_color\` = c.\`plateColor\` AND f.customer_vehicle_id = e.id AND f.\`status\`='SUCCESS' AND left(c.createTime,10)>'$DATE_WEEK_BEF' AND left(c.createTime,10)<'$DATE_YES' order by c.cardid desc ) tep  group by ���ƺ���,������ɫ ORDER BY �������� asc,����ʱ�� asc;"

echo "$sql"
#dao chu shuju
#mysql -u$USERNAME -p$PASSWORD -h$HOSTNAME -e "$sql" > $CSVNAME 2>/dev/null
mysql -u$USERNAME -p$PASSWORD -h$HOSTNAME -e "$sql" |sed -e  "s/\t/,/g" -e "s/NULL/  /g" -e "s/\n/\r\n/g" > $CSVNAME 2>/dev/null

echo "Export data success"

#awk '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13","$14","$15","$16","$17","$18","$19","$20","$21","$22","$23","$24","$25","$26","$27","$28","$29","$30","$31 > "\$CSVNAME01"}' $CSVNAME
#awk '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13","$14","$15","$16","$17","$18","$19","$20","$21","$22","$23","$24","$25 > "$CSVNAME01" }' $CSVNAME
#sleep 5
#sed -e 's/^/"/g;s/$/"\n/g' $CSVNAME >$CSVNAME01

echo " Begin Convert UTF-8 to GBK"
#zhuan huan shuju geshi
iconv -f UTF-8 -t GBK $CSVNAME -o $CSVNAME02
echo "Convert Success\n\n"