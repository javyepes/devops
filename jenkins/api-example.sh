### script vars ###
log_file='enter you location'
sudo touch $log_file
sudo chmod 775 $log_file
DATE=`date +%Y-%m-%d`
echo $DATE >> $log_file

### jenkins vars ###
url="enter your url"
jenkins_uid='enter your uid'
my_token='enter you api token'
job_name='enter the full path of the build/job;

echo "example usage to execute jenkins jobs"

(
echo "get the crumb"
crumb=`curl --user "$jenkins_uid:$my_token" -X GET http://$url/crumbIssuer/api/xml?xpath=concat'(//crumbRequestField,":",//crumb)'`

echo "execute the following job: $job_name" && echo curl --user "$jenkins_uid:$my_token" -H "$crumb" -X POST http://$url/job/$job_name/build?token=$my_token
curl --user "$jenkins_uid:$my_token" -H "$crumb" -X POST http://$url/job/$job_name/build?token=$my_token
)|tee -a $log_file


