Feature: Browse
  As a user
  I want to use the smallmap to get the location of my market

  Background:
    Given I am a registered user
    And There is one category
    Then I click to sign in 
    And I fill a valid email and password
    When I click on add market

  @slow @javascript
  Scenario: Use small map to update location and address in add market
    Then I should see a smallmap
    And I click on the smallmap
    Then I should see a marker on the map
    Given I have filled the name and description
    Then I click on create market
    Then I should see the location
    Then I should see the address




