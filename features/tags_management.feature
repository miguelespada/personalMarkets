@tags

Feature: Manage tags
  I order to classify markets
  I want manage tags

  Background:
    Given I am logged in as an admin

  Scenario: Add tag
    When I add a tag
    Then I should be notified that the tag has been added
    And I should see the tag in the tag list
 
  Scenario: Delete tag
    When There are some tags
    And I delete a tag
    Then I should be notified that the tag has been deleted
    And I should not see the tag in the tag list

  Scenario: Update tag
    When There are some tags
    And I edit a tag
    Then I should be notified that I the tag has been updated
    And I should see the tag with the new name in the tag list

  @javascript @browse_by_tag
  Scenario: Browse markets by tag
    When There is a market with a suggsested tag
    And I browse the tag
    Then I should see the market tagged with the tag