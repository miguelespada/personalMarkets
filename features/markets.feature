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


