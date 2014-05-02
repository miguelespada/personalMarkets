@wishes
Feature: Manage wishes
  I order users can show their wishes
  They would like to manage wishes

  Background:
    Given I am logged in 

  Scenario: Add bargain
    When I add a wish
    Then I should be notified that the wish has been added
    And I should see the wish in my wishlist
    And I should see the wish in the general wishlist