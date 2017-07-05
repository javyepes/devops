#!/bin/bash

echo -e "this script assumes you have a 3 aws profiles.\n\tThe 3 profiles are default(dev), staging, and prod"

if [ $1 = dev ];then
	for region in `aws ec2 describe-regions --output text | cut -f3`;
		do aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value[]]' --output json | tr -d '\n[] "' | perl -pe 's/i-/\ni-/g' | tr ',' '\t' | sed -e 's/null/None/g' | grep '^i-' | column -t
	done
fi

if [ $1 = staging ];then
        for region in `aws ec2 describe-regions --output text | cut -f3`;
                do aws --profile staging ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value[]]' --output json | tr -d '\n[] "' | perl -pe 's/i-/\ni-/g' | tr ',' '\t' | sed -e 's/null/None/g' | grep '^i-' | column -t
        done
fi

if [ $1 = prod ];then
        for region in `aws ec2 describe-regions --output text | cut -f3`;
                do aws --profile prod ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value[]]' --output json | tr -d '\n[] "' | perl -pe 's/i-/\ni-/g' | tr ',' '\t' | sed -e 's/null/None/g' | grep '^i-' | column -t
        done
fi
