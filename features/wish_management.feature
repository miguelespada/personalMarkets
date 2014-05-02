@wishes
Feature: Manage wishes
  I order users can show their wishes
  They would like to manage wishes

  Background:
    Given I am logged in 

  Scenario: Add Wish
    When I add a wish
    Then I should be notified that the wish has been added
    And I should see the wish in my wishlist
    And I should see the wish in the general wishlist
  
  @wishes
  Scenario: Delete Wish
    When There are some wishes
    And I delete a wish
    Then I should be notified that the wish has been deleted
    And I should not see the wish in my wishlist