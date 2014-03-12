Feature: Social feature
  I order to follow markets
  As register user
  I would like to 'like' someone else's market

  Background:
    Given I am a register user
    And I sign in
    And There is someone else's market

  @social
  Scenario:
    When I go to the market page
    And I like the market
    Then The market is in my favorites
    And The market gets my like
  
  Scenario:
    When I go to my favorites
    And I unlike the market
    Then The market is not in my favorites
    And The market does not have my like
  
  Scenario:
    When I go to my favorites
    Then I cannot unlike the market

  Scenario:
    When I go to my markets
    Then I cannot like my own markets

