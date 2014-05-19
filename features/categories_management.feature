Feature: Manage categories
  I order to classify markets
  I want manage categories

  Background:
    Given I am logged in as an admin

  @categories
  Scenario: Add category
    When I add a category
    Then I should be notified that the category has been added
    And I should see the category in the category list
    And I should see the correct style in the map
    And I should see the category with map and glyph in the category list
 
  Scenario: Delete category
    When There are some categories
    And I delete a category
    Then I should be notified that the category has been deleted
    And I should not see the category in the category list

  Scenario: Cannot delete category with markets
    When There is a category with markets
    And I delete a category
    Then I should be notified that I cannot delete the category
    And I should see the category in the category list

  Scenario: Update category
    When There are some categories
    And I edit a category
    Then I should be notified that I the category has been updated
    And I should see the category with the new name in the category list

  Scenario: Browse markets by category
    When There is a category with markets
    And I browse one category
    Then I should see the markets of the category 