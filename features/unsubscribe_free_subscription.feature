@unsubscribe_free_subscription @javascript
Feature: Unsubscribe free subscription
  In order to become a regular user
  As a premium user with a free subscription
  I want to cancel my subscription

  Background:
    Given an admin made me premium

  Scenario: Cancel subscription
    When I cancel my subscription
    Then I am a regular user