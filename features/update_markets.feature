Feature: Markets update
  In order to manage markets 
  As a user
  I want to update a market

	Scenario: Change name
	  Given I go to the market manager page
	  And There is a market
	  When I click on a market
	  And I click the edit button
	  And I fill the name with a new name	  
	  And I click on the update market button
	  Then I should see my personal market page with the new name
	  And I should be notified that the market has been succesfully updated

	Scenario: Update with no changes
	  Given I go to the market manager page
	  And There is a market
	  When I click on a market
	  And I click the edit button
	  And I fill the name with a the same name	  
	  And I click on the update market button
	  And I should be notified that the market was not updated
