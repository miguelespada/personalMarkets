Feature: Markets
  In order to other to have users
  I want to add a user

  Scenario: Add User
	  Given I am in the add user page
	  When I fill in the email and password
	  And I click on the sign up button
	  And I should be notified that the user has been added

  Scenario: See User List
  	Given I am in the home page
  	And there are some users
  	When I click on User List
  	Then I should see the list of users