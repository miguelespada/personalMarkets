@social @unlike_as_admin
Feature: Unlike a market
  As a admin
  I want to unlike markets

  Background:
    Given I am logged in as an admin
    Given There are some published markets
    And I like the market

  Scenario: Unlike market
    When I unlike the market
    Then The number of likes decrement
    And I cannot unlike that market again
    And The market is not staff pick
