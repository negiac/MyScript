#!/bin/bash

HOSTNAME="IP地址"
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
sql="select * from ( select  ''  as 'ETC协议编号(分行)',' ' as '一级机构地区号',5 as '协议状态',5 as '支付协议类型', concat('\'',c.\`cardNO\`) as 'ETC卡号',98 as '办理渠道',2 as 'OBU类型',3 as '发行模式',440101 as '发行方编号' , '广
东发行机构' as '发行方名称',DATE_FORMAT(c.\`createTime\`,'%Y-%m-%d') as '申请日期',DATE_FORMAT(c.\`createTime\`,'%H.%i.%S') as '申请时间',concat('\'','6222450015809110' ) as '签约卡号',concat('\'',(SELECT VALUE FROM jrtfs_crm3.comp_company_data_tree WHERE company_id = b.company_id AND company_template_field_id = 293 )) as '车主身份证号码',(SELECT VALUE FROM jrtfs_crm3.comp_company_data_tree WHERE company_id = b.company_id AND company_template_field_id = 290 ) as '车主身份证姓名',  c.\`plateNumber\` as '车牌号码' ,2  as '是否营运车辆',b.\`phone\` as '银行预留手机号（车主手机
号）',a.\`bank_marketing_code\` as '营销代码',a.\`bank_marketing_code\`  as '统一认证号',' ' as '营销人员手机号',DATE_FORMAT(c.\`createTime\`,'%Y-%m-%d') as '创建日期',DATE_FORMAT(c.\`createTime\`,'%H.%i.%S') as '最后修改日期',35008 as '备注3',case e.\`vehicle_class\` when '货一' then '011' when '货二' then '012' when '货三' then '013' when '货四
' then '014' when '货五' then '015' when '货六' then '016' when '专一' then '021' when '专二' then '022' when '专三' then '023' when '专四' then '024' when '专五' then '025' when '专六' then '026'  else e.\`vehicle_class\`  end as '收费车型',c.\`plateColor\` as '车辆颜色',concat('\'',c.obuId) as 'OBUID' FROM \`jrtfs_crm3\`.sys_client a ,\`jrtfs_crm3\`.comp_company  b ,\`jrtfs_etc3\`.\`card\` c,\`jrtfs_etc3\`.\`product\` d , jrtfs_crm3.\`customer_vehicle\` e,jrtfs_crm3.\`application_order_detail\` f WHERE a.\`client_id\` = b.\`client_id\` AND c.\`customerCode\` = b.code AND c.\`productId\` = d.\`productId\` AND d.\`productId\` IN (37,38)   AND d.businesstype = 'StoredValueMargin' AND c.\`isDeleted\` != 1 AND e.\`plate_no\` = c.\`plateNumber\` AND e.\`plate_color\` = c.\`plateColor\` AND f.customer_vehicle_id = e.id AND f.\`status\`='SUCCESS' AND left(c.createTime,10)>'$DATE_WEEK_BEF' AND left(c.createTime,10)<'$DATE_YES' order by c.cardid desc ) tep  group by 车牌号码,车辆颜色 ORDER BY 申请日期 asc,申请时间 asc;"

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