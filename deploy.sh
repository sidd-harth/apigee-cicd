#! /bin/bash

# this scripts checks for any new update on edge.json. 
	# if there is a update it is going to deploy both the config and proxy
	# if there is NO update, only proxy will be deployed

	# this script was written by Kurt Googler Kanaskie
		# https://community.apigee.com/questions/70453/separating-proxy-and-config-deployment-using-maven.html

ConfigChanges=`git diff --name-only HEAD HEAD~1 | grep "edge.json"`
if [[ $? -eq 0 ]]
then
	export EdgeConfigOptions="update"
else
	export EdgeConfigOptions="none"
fi

# Redirect output from this script to an "edge.properties" file in Jenkins. 
echo EdgeConfigOptions=$EdgeConfigOptions

mvn -f HR-API/pom.xml install -Pprod -Dusername=${apigeeUsername} -Dpassword=${apigeePassword} -Dapigee.config.options=$EdgeConfigOptions