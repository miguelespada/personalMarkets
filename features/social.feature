Feature: Social Networks feature
  I order to follow markets
  As register user
  I would like to 'like' someone else's market

  Background:
    Given There is someone else's market
    And I am logged in

  @social
  Scenario: Like a market
    When I like a market
    Then The market is in my favorites
    And The market has got a like

  @social
  Scenario: Unlike a market
    Given I have some favorite markets
    And I unlike a market
    Then The market is not in my favorites