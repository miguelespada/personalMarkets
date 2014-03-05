Feature: Manage users
  I order to have manage users 
  I want to create accounts
  I want to sign in and sign out

  Scenario: Sign up
    Given I am in the home page
    When I click on sign up
	  And I fill in the email and password
	  And I click on the sign up button
	  Then I should be notified that the user has been added
    And I should see that I am logged 

  Scenario: Sign in 
    Given I am a registered user
    Then I click to sign in 
    And I fill a valid email and password
    And I should see that I am logged as myself

  Scenario: Sign out
    Given I am a registered user
    Then I click to sign in 
    And I fill a valid email and password
    When I click on sign out
    Then I should be notified that the I signed out
    Then I should see that that I am not logged

  Scenario: See User List
  	Given there are some users
    And I am in the home page
  	When I click on User List
  	Then I should see the list of users