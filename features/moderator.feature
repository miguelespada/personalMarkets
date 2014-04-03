@moderator
Feature: Moderator

  Background:
    Given I am logged in as a moderator

  Scenario: Delete comments
    When I visit a market
    Then I can delete the market comments 

  Scenario: Delete featured picture
    When I visit a market
    Then I can delete the market picture
