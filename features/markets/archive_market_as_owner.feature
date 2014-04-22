Feature: Archive market as owner
  As an owner
  I want to archive my market
  So that It desappears from lists

  Background:
    Given I am logged in
    And I have a market

  Scenario: Archive market
    When I archive it
    Then It is not visible in guest markets
