@security-checks
Feature:
    Testing Secuirty Policies
        
    @JWT_security    
    Scenario: update a record
        Given I set Content-type header to application/json
        When I POST to /security/jwt
        Then response code should be 200
        And I store the value of body path $.jwt as access token
        And I set bearer token
        When I set body to {"email": "cicd@mail.com"}
        And I set headers to
          | name          | value            |
          | Content-Type  | application/json |
        When I PUT /hr22/9886244925Siddharth
        Then response code should be 200
        And response body path $.email should be cicd@mail.com  
    
    @OAuth_security
    Scenario: delete a record which needs oauth access token
        Given I have basic authentication credentials 9HEUGnaUiQGUhMwEflkiIZ9v8kh3fOVc and 5kIH51hVKntKSlHp
        When I POST to /security/oauth?grant_type=client_credentials
        Then response code should be 200
        And I store the value of body path $.access_token as access token
        And I set bearer token
        When I DELETE /hr22/9886244926Siddharth
        Then response code should be 200
        And response body path $.msg should be Record deleted







