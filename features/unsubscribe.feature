@unsubscribe @javascript
Feature: Unsubscribe
  In order to become a regular user
  As a premium user
  I want to cancel my subscription

  Background:
    Given a user is in its profile page
    And a user submits for subscription with valid data
    Then he is premium

  Scenario: Cancel subscription
    When I cancel my subscription
    Then I am a regular user

  @subscribe_after_unsubscribe
  Scenario: Subscribe after unsubscription
    When I cancel my subscription
    Then a user is in its profile page
    And a user submits for subscription with valid data
    Then he is premium