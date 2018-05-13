Feature:
    apigee tests
        
    @POST_call    
    Scenario: Create a record
        Given I set body to {"name":"jane","city":"hyd"}
        When I POST to /hr
        Then response code should be 200
        And response body path $.entities[0].name should be jane
    @Error    
    Scenario: error check
        Given I set body to {"name":"jane","city":"hyd"}
        When I POST to /hr
        Then response code should be 400
        And response body path $.error should be duplicate_unique_property_exists    
    @GET_call    
    Scenario: retrieve a record
        Given I set Content-type header to application/json
        When I GET /hr/jane
        Then response code should be 200
        And response body path $.entities[0].name should be jane
        And response body path $.entities[0].city should be hyd
    @Error
    Scenario: not found record
        Given I set Content-type header to application/json
        When I GET /hr/invalid_name
        Then response code should be 404
        And response body path $.error should be entity_not_found
    @PUT_call    
    Scenario: update a record
        Given I set body to {"city":"bang"}
        When I PUT /hr/jane
        Then response code should be 200
        And response body path $.entities[0].name should be jane
        And response body path $.entities[0].city should be bang        
    @OAuth
    Scenario: delete a record which needs oauth access token
        Given I have basic authentication credentials <client_id> and <client_secret>
        When I POST to /hcl_oauth/token?grant_type=client_credentials
        Then response code should be 200
        And I store the value of body path $.access_token as access token
        And I set bearer token
        When I DELETE /hr/jane
        Then response code should be 200
        And response body path $.entities[0].name should be jane
        And response body path $.entities[0].city should be bang