@users 
Feature: Registered users

  Background:
    Given I am logged in

  Scenario: Visit a market
    And There is someone else's market
    When I visit a market page
    Then I should see the full description of the market including the address

  Scenario: Create market time restriction
    And I create a market 
    When I try to create another market
    Then I can see an error message
  

  Scenario: Create market time restriction
    And I have one month old market 
    When I try to create another market
    Then I can see the new market form

  Scenario: Not able to delete other market featured image
    And There is someone else's market
    When I visit a market page
    Then I should not be able to delete the featured image
