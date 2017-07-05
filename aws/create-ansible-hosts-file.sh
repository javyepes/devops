#!/bin/bash
tmphf="/tmp/tmp-hosts"
hfile="/Users/jyepes/Documents/ansible/hosts"

touch $tmphf
echo "[prod]" > $tmphf
for region in `aws ec2 describe-regions --output text | cut -f3`;do
	aws --profile prod ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value[]]' --output json | tr -d '\n[] "' | perl -pe 's/i-/\ni-/g' | tr ',' '\t' | sed -e 's/null/None/g' | grep '^i-' | column -t | awk '{print $4, $6}' |sed 's| | #|g' >> $tmphf
done

echo "[stag]" >> $tmphf
for region in `aws ec2 describe-regions --output text | cut -f3`;do
	aws --profile staging ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value[]]' --output json | tr -d '\n[] "' | perl -pe 's/i-/\ni-/g' | tr ',' '\t' | sed -e 's/null/None/g' | grep '^i-' | column -t | awk '{print $4, $6}' |sed 's| | #|g' >> $tmphf
done

echo "[dev]" >> $tmphf
for region in `aws ec2 describe-regions --output text | cut -f3`;do
	aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value[]]' --output json | tr -d '\n[] "' | perl -pe 's/i-/\ni-/g' | tr ',' '\t' | sed -e 's/null/None/g' | grep '^i-' | column -t | awk '{print $4, $6}' |sed 's| | #|g' >> $tmphf
done

echo "move $tmphf to $hfile"
mv $tmphf $hfile
if [ $? -ne 0 ];then
	echo -e "unable to create new hostfile\n\texit 1" && exit 1
else
	echo "complete: new $hfile created"
fi