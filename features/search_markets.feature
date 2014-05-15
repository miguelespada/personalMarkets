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

  @javascript
  Scenario: Filter by city
    When I select a city
    Then I see the markets matching my filters

  @javascript  @ajaxSearch 
  Scenario: Filter by my location
    When I allow geolocation
    And I select search by my location
    Then I see the markets matching my filters

  Scenario: Do do not allow search by location
    When I don ot allow geolocation
    And I cannot search by my location

  @javascript
  Scenario: Search with ajax
    And I type a query
    Then I see the markets matching my filters
