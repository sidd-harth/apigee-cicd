#!/bin/bash

current_deployment_info=$(curl -H "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/onlineman477-eval/apis/HR-API/deployments") 

rev_num=$(jq -r .environment[0].revision[0].name <<< "${current_deployment_info}" ) 
env_name=$(jq -r .environment[0].name <<< "${current_deployment_info}" ) 
api_name=$(jq -r .name <<< "${current_deployment_info}" ) 
org_name=$(jq -r .organization <<< "${current_deployment_info}" )

declare -r hardcoding_stable_revision=20

# declare -r num1=1
# pre_rev=$(expr "$rev_num" - "$num1")


echo $rev_num
echo $api_name
echo $org_name
echo $env_name
# echo $pre_rev
echo ${stable_revision}


if ["$stable_revision" == "null"]
then
	echo "WARNING: Test failed, undeploying and deleting revision $rev_num"

	curl -X DELETE --header "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$rev_num/deployments"

	curl -X DELETE --header "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/$org_name/apis/$api_name/revisions/$rev_num"
else
echo "WARNING: Test failed, reverting from $rev_num to $stable_revision --- undeploying and deleting revision $rev_num"

curl -X DELETE --header "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$rev_num/deployments"

curl -X DELETE --header "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/$org_name/apis/$api_name/revisions/$rev_num"

curl -X POST --header "Content-Type: application/x-www-form-urlencoded" --header "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$stable_revision/deployments"
fi

