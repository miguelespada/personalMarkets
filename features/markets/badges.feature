Feature: Market Badges
  As a registered user
  I can see badges of each market
  So that I can know the type of a market
	
	@badges @javascript
  Scenario: PRO market badge
    Given I am logged in
    And I have one market
    When I make it PRO
    Then I should see the badge of PRO

  @badges @javascript
  Scenario: Sample market badge
    Given I am logged in as admin user
    And I have one market
    Then I should see the badge of sample

  @badges @javascript
  Scenario: Sample market badge
    Given I am logged in as admin user
    Given There are some published markets
    When I like the market
    Then I should see the badge of staff pick