Feature: Manage market
  In order to other users can see my market
  As a registered user
  I want to add and manage a market

  Background:
    Given I am a registered user
    And There is one category
    Then I click to sign in 
    And I fill a valid email and password
	When I click on add market
	When I fill in the name and description
	And I click on the save market button

	Scenario: Add Market
	  Then I should see the market page
	  And I should be notified that the market has been added

	Scenario: modify market
	  And I go to the my markets
	  And I click on edit a market
	  And I fill the name field with a new name
	  And I click on update market
	  Then I should see my personal market page with the new name
	  And I should be notified that the market has been succesfully updated

	Scenario: delete market
	  And I go to the my markets
	  When I click the delete button
	  Then I should go to the market manager page
	  And I should not see the market
