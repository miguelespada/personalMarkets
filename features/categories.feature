Feature: Manage categories
  I want to add and delete categories

  @categories
  Scenario: Default category is always present
    When I go to category list
    Then should the uncategorized category

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

  @categories
  Scenario: I cannot delete a category with markets
    Given there is a market
    When I go to category list
    And I should see the market category with the number of markets     
    Then I click on delete category
    And I should be notified that the category has not been deleted
    And I go to category list
    Then I should see the market's category

  @categoriesSearch
  Scenario: I can access to markets by category
    Given there is an indexed market
    When I go to category list
    And I click on show markets
    And I should see the market 

