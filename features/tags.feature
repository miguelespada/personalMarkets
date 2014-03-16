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

    @tags
    Scenario: See tag list
      When there are some tagged markets
      And I go to tag list
      Then I can see all the tags
      And I click on a tag
      Then I see the markets matching the tag

    @suggested
    Scenario: Star one tag
      When there are some tagged markets
      And I go to tag list
      And I click star tag
      And I go to add market
      Then I should see tag as suggested tag

    @suggested
    Scenario: UnStar one tag
      When there are some tagged markets
      And I go to tag list
      And I click star tag
      And I click unstar tag
      Then I click star tag


