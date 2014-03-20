Feature: Browse
  As a user
  I want to see the markets on a map

   @slow @javascript
   Scenario: See map
    When I go to maps
    Then I should see a map


   @maps @javascript
   Scenario: See one market marker
    Given There is a market with latitude and longitude
    When I go to maps
    Then I should see a marker on the map
    When I click on the marker
    Then I should see the market tooltip

