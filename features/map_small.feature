Feature: Browse
  As a user
  I want to use the smallmap to get the location of my market

  Background:
    Given I am a registered user
    And There is one category
    Then I click to sign in 
    And I fill a valid email and password
    When I click on add market

  @smallmap @javascript
  Scenario: See smallmap
    Then I should see a smallmap

