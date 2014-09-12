@stats @javascript
Feature: Stats visibility
  As a owner of a VIM market
  I can see the stats of my market

  Scenario: Normal user with VIM market can see stats
    Given I am logged in
    And I have one pro market
    When I visit the market
    Then I should be able to see the stats

  Scenario: PRO user can see stats
    When I am logged in as premium
    And I create a market
    Then I should see the market page
    Then I should be able to see the stats