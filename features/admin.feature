@admin
@wip
Feature: Admin

  Background:
    Given I am logged in as an admin
    When I visit a market

  @javascript
  Scenario: Edit comments
    Then I can edit the market comments 

  Scenario: Edit market
    Then I can edit the market

  Scenario: Modify market
    And I edit the market
    Then I should be notified that the market has been succesfully updated
