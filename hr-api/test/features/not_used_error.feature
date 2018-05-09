Feature:
	apigee tests
	
	Scenario: error check
		Given I set body to {"name":"jane","city":"hyd"}
		When I POST to /hr
		Then response code should be 400
		And response body path $.error should be duplicate_unique_property_exists	