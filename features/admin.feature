@admin
@wip
Feature: Admin

  Background:
    Given I am logged in as an admin

  @javascript
  Scenario: Edit comments
    When I visit a market
    Then I can edit the market comments 

  Scenario: Edit market
    When I visit a market
    Then I can edit the market
