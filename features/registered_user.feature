@users 
Feature: Registered users

  Background:
    Given I am logged in

  Scenario: Not able to delete other market featured image
    And There is someone else's market
    When I visit a market page
    Then I should not be able to delete the featured image
