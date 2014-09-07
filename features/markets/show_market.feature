@show_market
Feature: Show market
  
  Scenario: Guest users
    Given I am not logged in
    And There is someone else's market
    When I visit the market page
    Then I should see the full description of the market including the address

  Scenario: Registered user
    Given I am logged in
    And There is someone else's market
    When I visit the market page
    Then I should see the full description of the market including the address
