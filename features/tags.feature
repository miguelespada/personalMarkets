Feature: Manage tags
  As user I want to add tags to my markets
  and I want to search by tags
  As admin I want to manage tags
  and I want to suggest tags

  Background:
    Given I am a registered user
    And There is one category
    Then I click to sign in 
    And I fill a valid email and password
    When I click on add market
    When I fill in the name and description
    And I click on the save market button

  @tags
  Scenario: Add tag list
    When I go to the my markets
    And I click on edit a market
    And I fill the tag list
    And I click on update market 
    Then I should see my personal market page with the tags
    And I should be notified that the market has been succesfully updated

