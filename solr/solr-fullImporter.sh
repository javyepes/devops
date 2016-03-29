# usage ./solr-fullImporter-checker.sh ipadress #e.g. ./solr-fullImporter-checker.sh 10.100.100.1
DATE=`date '+%F'`
marker="monitoringmarker`date +%Y%m%d`" # creating a marker so the script knows when if failed or finished
tomcat_home='' # e.g. /opt/tomcat
servername=$1 # 
import_conf='' # export config file names into the import_conf variable e.g. `ls -1 /solr/conf/ | grep properties | sed 's/\(.*\)\..*/\1/'` 
solr_adm_log='' # e.g. /solr/search_admin_scripts/logs
email_recs=( 'user1' 'user2' ) # I used a array

if [[ -z $servername ]];then
  echo "invalid usage" && echo "missing servername variable"
  echo "usage: ./solr-fullImporter-checker.sh servername" && echo "e.g. ./solr-fullImporter-checker.sh 10.100.100.1"
  echo "      exit 0" && exit 0
elif [[ $servername = 10.100.100.1 ]] || [[ $servername = 10.100.100.2 ]] || [[ $servername = 10.100.100.3 ]];then # in this case we have 3 servers.  if its not one of those servers it will exit 0
  for collections in ${import_conf[@]};do
# added a marker on the file so we know where to start searching
    marker="$collections-monitoringmarker-$DATE"
# add marker to the file, then app the solr api to look for status of the import and put the stdout into the log file
    echo -e "fullImport\n$marker" > $solr_adm_log/indexer_$DATE.out && curl -s -S "http://$servername:8080/solr/select?clean=false&commit=true&qt=/$collections&command=status" >> $solr_adm_log/indexer_$DATE.out # use the api to do a fullimport
    if sed -e "1,/$marker/d" $solr_adm_log/indexer_$DATE.out |grep 'Indexing failed' ;then
      echo "Solr fullImport.sh: Indexing failed for $collections"
# if imports failed then send a email
      echo "Solr fullImport.sh: Indexing failed for $collections" | mail -s "Solr: Import Failed for $collections" ${email_recs[@]}
    elif sed -e "1,/$marker/d" $solr_adm_log/indexer_$DATE.out |grep '"Total Documents Processed">0<' ;then
      echo "Solr fullImport.sh: Zero Documents Were Imported for $collections"
# if no documents are imported then send a email
      echo "Solr fullImport.sh: Zero Documents Were Imported" | mail -s "Solr: Import Failed for $collections" ${email_recs[@]}
    else
      echo "Solr fullImport.sh: documents imported and indexing completed for $collections"
    fi
   done
else
  echo "invalid server: $server" && echo "Canceled: enter the ip address of one of the SOLR servers"
  echo "usage: ./solr-fullImporter-checker.sh servername" && echo "e.g. ./solr-fullImporter-checker.sh 10.100.100.1"
  echo "      exit 0" && exit 0
fi
echo "fyi if you get permission issues run it as sudo"