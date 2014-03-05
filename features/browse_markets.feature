Feature: Browse markets
  As a user
  I want to browse markets

  Background:
	Given I go to browse markets
	And there are some markets

	Scenario: I want to see the list of Markets
		Then I should see all the markets

	Scenario: I want to a search specific markets
		And I fill the search field
		And I click search
		Then I should see the markets that match my search

	Scenario: I want to see the full description of a market
		And I click the details link of a market 
		Then I should see the full description of a market

	Scenario: I want to see my markets
		Given I am a signed in
		And I go to my markets
		Then I should see all my markets
		Then I should see only my markets
