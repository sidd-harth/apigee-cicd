## !! incomplete steps !! futher refining is required !!
# CI/CD Demo - Apigee API Management Platform
This repository includes the instructions and pipeline definition for CI/CD using Jenkins, Apigee Lint, Apickli, Cucumber Reports, Slack & Apigee Maven Deploy plugin on Apigee.

Often the most difficult and confusing aspect of application development is figuring out how to build a common framework for creating/deploying new applications. Over time, development teams have started using tools like Maven to automate some of these functions. This repository uses various tools/plugins for deploying Apigee bundles to the Edge platform.

# Introduction
On every pipeline execution, the code goes through the following steps:
1. Develop an API Proxy in `test` environment Apigee Edge UI, Download the proxy and push to Github. 
2. In Jenkins, Apigee Proxy bundle is cloned from Github.
3. Unit testing takes place in the `test` environment either using Newman or Assertible.
4. Code Analysis is done using Apigee Lint.
5. A new revision is published in `prod` environment using Apigee Maven Build Plugin.
6. The newly deployed `prod` environment goes through Integration tests using Apickli.
7. Apickli produced Cucumber Reports are displayed in Jenkins
8. Build Success/Fail notification is sent to Slack Room.

The following diagram shows the steps included in the deployment pipeline:
![arch_diagram](https://user-images.githubusercontent.com/28925814/40002136-6bd6fbd2-57ad-11e8-8479-cefba21054c9.jpg)

# Prerequisites
* [Apigee Edge Account](https://login.apigee.com/login)
* [Assertible Account + Jenkins Config](https://assertible.com/blog/automated-api-testing-with-jenkins)
* [Slack Account + Jenkins Config](https://wiki.jenkins.io/display/JENKINS/Slack+Plugin)
* NodeJS & NPM
* Configure Jenkins with Git, Cucumber Reports, JDK, Maven, NodeJS, Slack Plugins
![blueocean](https://user-images.githubusercontent.com/28925814/40007507-9e76a9cc-57ba-11e8-9064-e7a0064227ac.jpg)

# Demo Guide
1. HR API - Which does do all CRUD operations on employee records. For backend I am using Apigee BaaS.
2. You can use any backend of your preference or simply mock the data using Assign Message Policy.
3. Download `hr-api_rev1_test_env.zip` from this repo & deployed to `test` env or create an sample API Proxy.
4. Clone/Fork this repo & Create a directory structure as per `hr-api` directory & place your `apiproxy` folder.
5. In Jenkins as of 14th May, 2018 I am not using Git SCM due to some Jenkins issue(this will be rectified ASAP). I have manually copy-pasted my Jenkinsfile Script in my Pipeline Job.
6. Trigger Build Manually. First Assertible will run through the unit tests.
```
curl -u apikey: 'https://assertible.com/deployments' -d'{\"service\":\"d8d73-b0a94b325ae4\",\"environmentName\":\"production\",\"version\":\"v1\"}'
```
7. Apigee Lint will go through the `apiproxy` folder,
```node
apigeelint -s /hr-api/apiproxy/ -f table.js
```
![apigee-lint](https://user-images.githubusercontent.com/28925814/40007499-98bd6dfe-57ba-11e8-8d95-ba09a6000039.jpg)
8. Build & Deploy happens through Apigee Maven Plugin(update `pom` files with appropiate details),
```maven
mvn -f /hr-api/pom.xml install -Pprod -Dusername=<email_here> -Dpassword=<password_here>
```
![maven-build](https://user-images.githubusercontent.com/28925814/40007503-9ba8be74-57ba-11e8-921f-b556a4048c77.jpg)
9. Integration tests happen through Apickli - Cucumber - Gherkin Tests,
```javascript
cucumber-js --format json:reports.json features/prod_tests.feature
```
10. Cucumber Reports plugin in Jenkins will use the `reports.json` file to create HTML Reports & satistics.
![cucumber-tag-fail](https://user-images.githubusercontent.com/28925814/40005985-e5518528-57b6-11e8-85e8-2327449d84a6.jpg)
![cucumber-failure](https://user-images.githubusercontent.com/28925814/40005994-ea8f5b0a-57b6-11e8-8655-6222d806154e.jpg)

11. If Integration tests fail, then through a `undeploy.sh` shell script I am undoing _Step 8_.
```javascript
curl -X DELETE --header "Authorization: Basic <base64 username:password>" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$rev_num/deployments"
curl -X DELETE --header "Authorization: Basic <base64 username:password>" "https://api.enterprise.apigee.com/v1/organizations/$org_name/apis/$api_name/revisions/$rev_num"
curl -X POST --header "Content-Type: application/x-www-form-urlencoded" --header "Authorization: Basic <base64 username:password>" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$pre_rev/deployments"
```
12. When Build Starts/Ends & At any step if a Failure occurs, a notification is sent to Slack Room.
![slack-web](https://user-images.githubusercontent.com/28925814/40006639-7e98897e-57b8-11e8-85ac-9dd9022b7773.jpg)

# Known/Current Issues
1. Git Plugin issue with Jenkins. Hence a lot of manual steps had to be done in Jenkinsfile. Working on a solution, will update this Jenkinsfile.
2. Cucumber Tests don't run/work in local directory. It only works from global directory /usr/node_modules/npm/ directory
