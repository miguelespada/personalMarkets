@comments
Feature: Delete comments
  In order to delete undesired comments
  As a registered user
  I want to be able to delete a comment that I posted

  Background:
    Given there are some users
    Given I log in as the first user

  Scenario: I have a way to delete comment
    And I post a comment into a market
    When I visit the other market page
    Then I can delete my comment

  Scenario: When deleted does not appear in the list
    And I post a comment into a market
    When I visit the other market page
    And I delete my comment
    Then It disappears from list

  Scenario: I cant delete other users comments
    And I post a comment into a market
    And I sign out
    And I sign in as the other user
    When I visit the other market page
    Then I cant delete the comment
