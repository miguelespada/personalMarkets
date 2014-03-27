@wip
Feature: Market comments
  In order to have opinions about a market
  As a registered user
  I want to be able to comment a market

  Background:
    Given I am logged in
    And I have one market

  Scenario: See market comments
    And It has comments
    When I visit the market page
    Then I should see the market comments

  Scenario: Post a comment
    When I visit the market page
    And I post a comment
    Then It appears in the list