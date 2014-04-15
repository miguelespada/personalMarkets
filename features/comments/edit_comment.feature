@comments
Feature: Edit comments
  In order to update a comment content
  As a registered user
  I want to be able to edit my comments

  Background:
    Given there are some users
    And I log in as the first user

  Scenario: I have a way to edit a comment
    And I post a comment into a market
    When I visit the other market page
    Then I can edit my comment

  @javascript
  Scenario: When edited it appears updated
    And I post a comment into a market
    When I visit the other market page
    And I edit my comment
    Then It is updated in the list

  Scenario: I cant edit other users comments
    And I post a comment into a market
    And I sign out
    And I sign in as the other user
    When I visit the other market page
    Then I cant edit the comment
