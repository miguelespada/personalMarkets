@comments
Feature: Market comments
  In order to have opinions about a market
  As a registered user
  I want to be able to comment a market

  Background:
    Given I am a registered user
    And I have one market

  Scenario: See market comments
    And It has comments
    And I sign in
    When I visit the market page
    Then I should see the market comments

  Scenario: Post a comment
    And I sign in
    When I visit the market page
    And I post a comment
    Then It appears in the list

  Scenario: Post a comment in other user market
    And I sign in
    When I comment other user market
    Then It appears in the other market list

  Scenario: Not logged in
    When I visit the market page
    Then I cant post a comment
