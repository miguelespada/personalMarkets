@limits @limit_wish
Feature: Limits
  As a user
  I can only have ten wishes

  Background:
  Given I am logged in

  Scenario: Limit of wishes
    Given I have nine wishes
    And I add a wish
    Then I should be notified that the wish has been added
    When I try to add another wish
    Then I should be notified that I can have ten wishes only