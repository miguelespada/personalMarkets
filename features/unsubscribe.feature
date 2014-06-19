@unsubscribe 
Feature: Unsubscribe
  In order to become a regular user
  As a premium user
  I want to cancel my subscription


  Scenario: Cancel subscription
    Given I am logged in as premium
    When I cancel my subscription
    Then I am a regular user 
