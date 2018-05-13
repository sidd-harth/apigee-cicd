#!/bin/bash
deployment_info=$(curl -H "Authorization: Basic <base64 username:password>" "https://api.enterprise.apigee.com/v1/organizations/o/apis/api-name/deployments") 

rev_num=$(jq -r .environment[0].revision[0].name <<< "${deployment_info}" ) 
env_name=$(jq -r .environment[0].name <<< "${deployment_info}" ) 
api_name=$(jq -r .name <<< "${deployment_info}" ) 
org_name=$(jq -r .organization <<< "${deployment_info}" )

declare -r num1=1
pre_rev=$(expr "$rev_num" - "$num1")

echo $rev_num
echo $api_name
echo $org_name
echo $env_name
echo $pre_rev

curl -X DELETE --header "Authorization: Basic <base64 username:password>" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$rev_num/deployments"

curl -X DELETE --header "Authorization: Basic <base64 username:password>" "https://api.enterprise.apigee.com/v1/organizations/$org_name/apis/$api_name/revisions/$rev_num"

curl -X POST --header "Content-Type: application/x-www-form-urlencoded" --header "Authorization: Basic <base64 username:password>" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$pre_rev/deployments"