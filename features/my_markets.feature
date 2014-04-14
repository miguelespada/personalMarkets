@wip
Feature: My markets
  As a registered user
  I want to see my markets
  So that I can manage them

  Background:
    Given I am logged in
    And I have some markets
    When I go to my markets list

  Scenario: Info shown
    Then I see their names and descriptions

  Scenario: Markets actions
    Then I see an edit button
    And I see a delete button
    And I see a show button
