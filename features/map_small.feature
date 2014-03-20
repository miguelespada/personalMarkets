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
  Scenario: See smallmap
    Then I should see a smallmap
    And I click on the smallmap
    Then I should see a marker on the map

  @smallmap
  Scenario: Fill the form and add market
    Given I have filled the name and description
    Then I click on add market


