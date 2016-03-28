# count number of packages thats can be upgraded
DATE=`date +%Y-%m-%d`
email_rec=""
server_list=`awk -F" " '{print $1}' server-centos.list` # I am using a comma separated list "server-centos.list"
raw_report="/tmp/$DATE-raw-report-data.txt" ; touch $raw_report && echo "" > $raw_report # create and nulls out the file
quick_report="/tmp/$DATE-quick-report.txt" ; touch $quick_report && echo "" > $quick_report # create and nulls out the file
full_report="/tmp/$DATE-full-report.txt" ; touch $full_report && echo "" > $full_report # create and nulls out the file
mode=$1

if [[ -z $mode ]];then
  echo "invalid: mode = blank"
  echo "usage: ./patch-report-centos.sh -v [verbose] or -s [silent]"
  echo "cancel"
elif [[ $mode = "-v" ]];then
  for server in `awk -F" " '{print $1}' $server_list`;do
    ssh -t $server "echo $DATE && hostname && sudo yum list updates|grep -A 500 'Updated Packages' " > $raw_report # add the date, hostname then dumps stdout to $raw_report file
    echo "`head -2 $raw_report|tail -1 `" |tee -a $full_report && echo "There are `wc -l $raw_report|awk '{print $1}'` package(s) to update" |tee -a $full_report && cat $raw_report |tee -a $full_report # add a message for the report in the full_report file
    sed -i '/^$/d' $full_report # removes blank lines
  done
  cat $full_report|mail -s "CentOS: $DATE full patch report"  
  echo "complete"
elif [[ $mode = "-s" ]];then
  for server in `awk -F" " '{print $1}' $server_list`;do
    ssh -t $server "echo $DATE && hostname && sudo yum list updates|grep -A 500 'Updated Packages' " > $raw_report # dumps stdout to $raw_report file
    echo "`head -2 $raw_report|tail -1 `" |tee -a $quick_report && echo "There are `wc -l $raw_report|awk '{print $1}' ` package(s) to update" |tee -a $quick_report
    sed -i '/^$/d' $quick_report # removes blank lines
  done
    cat $quick_report|mail -s "CentOS: $DATE quick patch report" ${email_rec[@]}
  echo "complete"
else
  echo "invalid: mode = $mode"
  echo "usage: ./patch-report-centos.sh -v [verbose] or -s [silent]"
  echo "cancel"
fi
