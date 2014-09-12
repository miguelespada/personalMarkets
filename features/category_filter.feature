@category_home_filter @javascript
Feature: Category filter
  As a user
  I can click on one of the categories in the home page
  So that I can see all the markets of the category

  Background:
    Given There are some categories
    And There are some markets with the categories

  Scenario: Click to filter category
  	When I click on a category on the home page
  	Then I should see all the available markets of this category
  	And I should see that the filter button of this category is selected
