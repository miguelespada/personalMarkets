Feature: Edit market
  As a registered user
  I want to modify my market
  So that I can update its information

  Background:
    Given I am logged in
    And I have one market

  @edit_market
  Scenario: Change market info
    When I edit my market
    Then I am notified that the market has been succesfully updated
    And I see the market page with the new data
