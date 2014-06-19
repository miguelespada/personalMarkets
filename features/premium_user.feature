@javascript
Feature: Premium user
  As a registered user
  I want to be able to pay for a premium account
  To have more capabilities on Personal Markets

  Background:
    Given a user is in its profile page

  Scenario: A user can become premium in its profile page
    When he wants to become premium
    Then he needs to introduce his credit card data

  @premium
  Scenario: His role is updated to premium
    And a user submits for subscription with valid data
    Then he is notified for a successful subscription
    Then he is premium
