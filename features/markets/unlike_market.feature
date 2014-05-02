@unlike
Feature: Unlike a market
  As a registered user
  I want to unlike already liked markets
  So that I can unfollow them

  Background:
    When I am logged in
    Given There are some published markets
    And I like the market

  Scenario: Unlike market
    When I unlike the market
    Then The number of likes decrement
    Then I cannot unlike that market again
