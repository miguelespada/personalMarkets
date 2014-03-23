Feature: Manage categories
  I want to add and delete categories

  @categories
  Scenario: Add category
    Given I am a registered user
    And I go to category list
    And I click on new
    And I fill a category name
    When I click on add category
    Then I should see the category
    And The market counter of the category should be zero
    And I should be notified that the category has been added

  @categories
  Scenario: Delete category
    Given There is a category without markets
    When I go to category list
    And I click on delete category
    Then I should be notified that the category has been deleted
    And I go to category list
    And I should not see the category