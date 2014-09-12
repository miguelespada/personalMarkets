@ajaxSearch

Feature: Browse markets
  As a user
  I want to browse markets

  Background:
  Given There are some published markets
  And There are some special locations
  When I go to Search


  @javascript @category_filter
  Scenario: Filter category with ajax
    And I select a category filter
    Then I see the markets matching my filters

  @javascript
  Scenario: Filter time range with ajax
    And I select range
    Then I see the markets matching my filters
    And I select range all
    Then I see all markets

  @javascript @location_filter
  Scenario: Filter by location
    When I select a special location
    Then I see the markets matching my filters

   @javascript @my_location_filter
  Scenario: Filter by my location
    When I allow geolocation
    And I can search by my location
    Then I search by my location
    Then I should see that my location is selected
    And I should see the markets near to me ordered by distance

  @javascript
  Scenario: Search with ajax
    And I type a query
    Then I see the markets matching my filters
