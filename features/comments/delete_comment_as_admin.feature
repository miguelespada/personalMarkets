@comments
Feature: Delete comments as admin
  In order to delete undesired comments
  As an admin
  I want to be able to delete users comments

  Background:
    Given There is a comment in a market
    And I am logged in as an admin

  Scenario: I am able to delete
    When I visit the market page
    Then I can delete comments
