@limits @limit_bargain
Feature: Limits
  As a user
  I can only have ten bargains

  Background:
  Given I am logged in

  Scenario: Limit of bargains
    Given I have nine bargains
    And I add a bargain
    Then I should be notified that the bargain has been added
    When I try to add another bargain
    Then I should be notified that I can have ten bargains only