Feature: Markets
  In order to other users can see my market
  As a user
  I want to add a market

	Scenario: Add Market
	  Given I am in the add market page
	  When I fill in the name and description
	  When I fill the category
	  And I click on the save market button
	  Then I should see my personal market page
	  And I should be notified that the market has been added
	  
	Scenario: List of Markets
	  Given I go to the market manager page
	  And There are some markets
	  Then I should see the lists of markets
