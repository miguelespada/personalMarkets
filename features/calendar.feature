Feature: Manage market dates
  As user I would lile to add dates to my markets
  As user I would like to search by date
  As user I would like to see a calendar

  @calendar
  Scenario: Add date to a market
    Given I am a registered user
    And I have a market
    And I go to edit my market
    When I fill the date field
    And I click on update market
    Then I should see the calendar with my calendar
