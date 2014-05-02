@bargains
Feature: Manage bargains
  I order to show what I bought
  I would like to have images of my shoopings

  Background:
    Given I am logged in 

  Scenario: Add bargain
    When I add a bargain
    Then I should be notified that the bargain has been added
    And I should see the bargain in the bargain list