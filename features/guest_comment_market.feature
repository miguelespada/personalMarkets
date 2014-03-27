Feature: Market comments
  In order to have opinions about a market
  As a registered user
  I want to be able to comment a market

  Scenario: Not logged in
    Given I am a registered user
    And I have one market
    When I visit the market page
    Then I cant post a comment
