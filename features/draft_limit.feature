@limits @limit_draft @javascript
Feature: Limits
  As a user
  I can only have five drafts

  Background:
  Given I am logged in

  Scenario: Limit of drafts
    Given I have four drafts
    And I add a draft market
    Then I should be notified that the market has been added
    When I try to add another market
    Then I should be notified that I can have five drafts only