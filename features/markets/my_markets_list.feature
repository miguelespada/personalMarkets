Feature: My markets
  As a registered user
  I want to see my markets
  So that I can manage them

  Background:
    Given I am logged in
    And I have some markets
    When I go to my markets list

  Scenario: Markets info
    Then I see their names and descriptions

  @markets_buttons
  Scenario: Markets actions
    Then I see an edit button
    And I see a archive button
    And I see a show button
