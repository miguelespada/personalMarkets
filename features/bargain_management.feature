@bargains
Feature: Manage bargains
  I order to show what I bought
  I would like to have images of my shoopings

  Background:
    Given I am logged in 

  Scenario: Add bargain
    When I add a bargain
    Then I should be notified that the bargain has been added
    And I should see the bargain in my bargain list
    And I should see the bargain in the general bargain

  Scenario: Delete bargain
    When There are some bargains
    And I delete a bargain
    Then I should be notified that the bargain has been deleted
    And I should not see the bargain in my bargain list

  Scenario: Update bargain
    When There are some bargains
    And I edit a bargain
    Then I should be notified that the bargain has been updated
    And I should see the bargain with the new description in the bargain list

  @comment_bargain
  Scenario: Comment bargain
    When There are some bargains
    And I go to a bargain page
    Then I should be able to comment the bargain
