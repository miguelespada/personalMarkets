Feature: Markets
  In order to other users can see my market
  As a user
  I want to add a market

	Scenario: Add Market
	  Given I am in the add market page
	  When I fill in the name and description
	  And I click on the save market button
	  Then I should see my personal market page
	  And I should be notified that the market has been added

	Scenario: Add featured photo
		Given I am editing a market
		When I add a photo
		And I click on the save market button
		Then I should see the picture

Feature: Access Market
In order to add markets 
As a user
I want to access the creation market page

	Scenario: Go to create Market
	  Given I am in the home page 
	  When I click on the add market link
	  Then I should see the creation market page


