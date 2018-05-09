Feature:
	apigee tests
	
	Scenario: oauth token check
		Given I have basic authentication credentials o2BIQQNjdJEvt8fIe9xyQ7qITTd80ZTb and 9dHhpzxAnHK4GAne
		When I POST to /hcl_oauth/token?grant_type=client_credentials
		Then response code should be 200
		And I store the value of body path $.access_token as access token
		And I set bearer token
		When I GET /hr/Siddharth
		Then response code should be 200
