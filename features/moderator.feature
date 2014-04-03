@moderator
Feature: Moderator
  
  @wip
  Scenario: Delete comments
    Given I am logged in as a moderator
    When I visit a market
    Then I can delete the market comments 