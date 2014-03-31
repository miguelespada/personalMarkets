@comments
@wip
Feature: Report comments
  In order to report abuse on a comment
  As a registered user
  I want to be able to mark a comment as abusive

  Background:
    Given There is a comment in a market
    And I am logged in

  Scenario: Report as abusive
    When I report a comment as abusive
    Then The comment is marked as abusive
