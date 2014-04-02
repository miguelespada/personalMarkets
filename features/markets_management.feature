Feature: Manage market
  In order to other users can see my market
  As a registered user
  I want to modify my market

  Background:
    Given I am logged in
    And I have one market

  Scenario: See my markets
    Then I should see the market in my markets list

  @wip
  Scenario: Modify market
    When I edit my market
    Then I should be notified that the market has been succesfully updated
    And I should see my personal market page with the new data

  Scenario: delete market
    When I delete my market
    Then I should be notified that the market has been succesfully deleted
    And I should not see the market in my markets list