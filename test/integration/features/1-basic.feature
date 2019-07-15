@basic-operations
Feature:
    Testing the CRUD Operations
        
    @POST_create_record    
    Scenario: Create a User Record
        Given I set body to {"email":"mail@cicd.com","first_name":"Siddharth","last_name":"Jai","phone":"9886244925","user":"employee"}
        And I set headers to
	      | name          | value 			 |
	      | Content-Type  | application/json |
        When I POST to /hr22
        Then response code should be 200
        And response body path $.id should be 9886244925Siddharth
        And response body path $.name should be Siddharth Jai
        And response body path $.account should be Active

    @GET_all_records    
    Scenario: Read all records and check status code
        Given I set Content-type header to application/json
        When I GET /hr22
        Then response code should be 200    
    
    @GET_specific_record    
    Scenario: retrieve a specific user record
        Given I set Content-type header to application/json
        When I GET /hr22/9886244925Siddharth
        Then response code should be 200


