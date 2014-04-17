@unlike
Feature: Unlike a market
  As a registered user
  I want to unlike already liked markets
  So that I can unfollow them

  Background:
    Given I liked a market

  Scenario: Unlike market button
    When I am in the market page
    Then there is an unlike button

  Scenario: Like count decrement
    When I click the unlike button
    Then the number of likes decrement

  Scenario: Able to like the market again
    When I click the unlike button
    Then there is a like button
