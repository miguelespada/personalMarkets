Feature: Browse markets
  As a user
  I want to browse markets

  Background:
  Given There are some published markets
  And There are some special locations
  When I go to Search

  @search
  Scenario: Search markets
    And I do a search
    Then I see the markets matching my query

  @javascript
  Scenario: Filter category with ajax
    And I select a category filter
    Then I see the markets matching my filters

  @javascript
  Scenario: Filter time range with ajax
    And I select range
    Then I see the markets matching my filters
    And I select range all
    Then I see all markets

  @javascript
  Scenario: Filter by location
    When I select a special location
    Then I see the markets matching my filters


  @ajaxSearch @javascript
  Scenario: Filter by city


  @ajaxSearch @javascript
  Scenario: Filter by my location

  @javascript
  Scenario: Search with ajax
