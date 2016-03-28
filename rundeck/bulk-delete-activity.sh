# bulk delete all executions of jobs in a project
rb_url='' # enter the full url of your rundeck instance
api_token='' # enter the admin user's api token
rb_projects=( 'array01' 'array02' ) # using a array if you have more than one project
jobeid_list=( `curl -s -S -H "X-RunDeck-Auth-Token: $api_token" -X GET "$rb_url/api/1/jobs?project=${rb_projects[@]}"|grep "job id"|awk -F"'" '{print $2}'` ) # using the api to list all of the jobs we want to delete

echo "##################"
echo "### bulk       ###"
echo "### delete     ###"
echo "### all        ###"
echo "### job        ###"
echo "### executions ###"
echo "##################"

for jobeid in ${jobeid_list[@]};do
  echo ""
  echo "deleting all executions of the following ID: ${jobeid}"
  echo ""
  curl -s -S -H "X-RunDeck-Auth-Token: $api_token" -X DELETE "$rb_url/api/12/job/${jobeid}/executions"
done

echo ""
echo "############################"
echo "### Bulk Delete Complete ###"
echo "############################"
