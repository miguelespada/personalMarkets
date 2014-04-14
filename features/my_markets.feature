@wip
Feature: My markets
  As a registered user
  I want to see my markets
  So that I can manage them

  Background:
    Given I am logged in
    And I have some markets
    When I go to my markets list

  Scenario: info shown
    Then I should see their names and descriptions

  Scenario: markets actions
    Then I should see an edit button
    And I should see an delete button
    And I should see an show button
