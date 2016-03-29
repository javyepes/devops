#!/bin/bash
### vars ###
log_file="" # e.g. /var/log/solr-datasource-monitor.log"
sudo touch $log_file
sudo chmod 777 $log_file
DATE=`date +%Y-%m-%d`
echo $DATE >> $log_file
email_rec=( 'user1' 'user2' ) # I used a array
datasource="" # enter the ipaddress of the datasource
db_port="" # e.g. 3306

echo "Checking connectivity to the database"
(
echo "nc -z -v -w 5 $datasource $db_port"
nc -z -v -w 5 $datasource $db_port
if [ $? -eq 0 ];then
  echo "works"
else
  echo -e "Unable to Connect to Datasource: $datasource:$db_port\nPlease review logs">> $log_file
  cat $log_file|mail -s "Solr: Unable connect to Datasource" ${email_rec[@]}
fi
)|tee -a $log_file
