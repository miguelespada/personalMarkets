@archive
Feature: Archive market as admin
  As an admin
  I want to archive a market
  So that It desappears from lists

  Background:
    Given I am logged in as an admin
    When I visit a published market

  Scenario: Archive market
    And I archive the market
    Then It is not visible in guest markets
