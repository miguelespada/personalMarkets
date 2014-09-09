@limit_creation
Feature: Market creation limit
  As a normal user
  I can only create one market each month
    
    Background:
      When I am logged in
      Given I have an unpublished market

    Scenario: Create new market with a draft
      Then I can create a new market

    Scenario: Create new market with another market published
      Then I publish the draft
      Then I should not be able to create another market this month
