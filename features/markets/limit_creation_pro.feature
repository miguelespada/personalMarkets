@limit_creation_pro
Feature: Market creation limit
  As a PRO user
  I can only create four markets each month
    
    Background:
      When I am logged in as premium
      Given I have four unpublished markets

    Scenario: Create new market with a draft
      Then I can create a new market

    Scenario: Create new market with another market published
      Then I publish all my drafts
      Then I should not be able to create another market this month