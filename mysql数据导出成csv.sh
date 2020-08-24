#!/bin/bash

HOSTNAME="IPµØÖ·"
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
sql="select * from table;"

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