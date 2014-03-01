Feature: Markets
  In order to other users can see my market
  As a user
  I want to add a market
  Background:
	Given I am in my user space
	When I click on add market
	When I fill in the name and description
	And I click on the save market button

	Scenario: Add Market
	  Then I should see my personal market page
	  And I should be notified that the market has been added
	 
	Scenario: List of Markets
	  And I go to the my List of Markets
	  Then I should see the lists of markets

	Scenario: modify market
	  And I go to the my List of Markets
	  And I click on edit a market
      And I fill the name with a new name
      And I click on the update market button
      Then I should see my personal market page with the new name
      And I should be notified that the market has been succesfully updated

	Scenario: delete market
		And I go to the my List of Markets
		When I click the delete button
		Then I should go to the market manager page
		And I should not see the market