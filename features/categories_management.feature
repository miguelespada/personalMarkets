@categories

Feature: Manage categories
  I order to classify markets
  I want manage categories

  Background:
    Given I am logged in
    And There are some categories 
    When I go to Category list

  Scenario: Add category
    When I add a category
    Then I should be notified that the category has been added
    And I should see the category in the category list

  Scenario: Delete category
    And I delete a category
    Then I should be notified that the category has been deleted
    And I should not see the category in the category list

  Scenario: I cannot delete a category with markets

  Scenario: Update categories

  Scenario: Browse markets by category