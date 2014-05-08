@unpublish_market
Feature: Unpublish market
  In order to hide a market to users
  As the owner of a published market
  I want to unpublish it

  Scenario:
    Given my published market
    When I unpublish it
    Then It does not appear in navegable markets

