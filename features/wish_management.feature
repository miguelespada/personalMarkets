@wishes
Feature: Manage wishes
  I order users can show their wishes
  They would like to manage wishes

  Background:
    Given I am logged in 


  @add_wish
  Scenario: Add Wish
    When I add a wish
    Then I should be notified that the wish has been added
    And I should see the wish in my wishlist
    And I should see the wish in the general wishlist
  
  Scenario: Delete Wish
    When There are some wishes
    And I delete a wish
    Then I should be notified that the wish has been deleted
    And I should not see the wish in my wishlist

  Scenario: Update wish
    When There are some wishes
    And I edit a wish
    Then I should be notified that the wish has been updated
    And I should see the wish with the new description in the wish list

  @javascript @recommend_market
  Scenario: Recommend market
    When There are some wishes
    And There are some published markets
    When I got to a wish page
    Then I can recommend a market to a wish

  @javascript @recommend_next_market
  Scenario: Recommend next market
    When There are some wishes
    And There are some published markets
    When I got to a wish page
    Then I can recommend the next market in the list to a wish
