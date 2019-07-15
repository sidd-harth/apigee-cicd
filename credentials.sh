client_id=$(curl -H "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/onlineman477-eval/apiproducts/Cicd-Prod-Product?query=list&entity=keys")

id=$(jq -r .[0] <<< "${client_id}" )
echo $id

client_secret=$(curl -H "Authorization: Basic $base64encoded" "https://api.enterprise.apigee.com/v1/organizations/onlineman477-eval/developers/hr@api.com/apps/hrapp/keys/$id")

secret=$(jq -r .consumerSecret <<< "${client_secret}" )
echo $secret