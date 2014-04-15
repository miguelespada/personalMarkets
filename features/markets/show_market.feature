@wip
Feature: Show market
  
  Scenario: Guest users
    Given I am not logged in
    And There is someone else's market
    When I visit a market page
    Then I should see the full description of the market except the address