Feature: Markets list
  As a registered user
  I want my markets to appear in the markets list
  So that other users can see my markets info

  Background:
    Given I am logged in
    And I have some markets
    And I sign out
    When I go to Markets

  Scenario: Markets info
    Then I see their names and descriptions

  Scenario: Markets actions
    Then I see a show button
