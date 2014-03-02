Feature: Markets
  As a user
  I want to search markets
  
  Scenario: Add User
	  Given There are some markets
	  And I am in the search page
	  When I fill the search field
	  And I click search
	  Then I should see the results of my search