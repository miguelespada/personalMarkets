Feature: Manage categories
  I order to classify markets
  I want add and delete categories

  Background:
    Given I am logged in
    And There are some categories 
    When I go to category list

  @categories
  Scenario: Add category
    When I add a category
    Then I should be notified that the category has been added
    And I should see the category in the category list

  @categories
  Scenario: Delete category
    And I delete a category
    Then I should be notified that the category has been deleted
    And I should not see the category in the category list