@comments
@wip
Feature: Delete comments
  In order to delete undesired comments
  As a registered user
  I want to be able to delete a comment that I posted

  Background:
    Given I am logged in
    And I post a comment into a market
    When I visit the other market page

  Scenario:
    Then I can delete my comment

  Scenario:
    And I delete my comment
    Then It disappears from list  