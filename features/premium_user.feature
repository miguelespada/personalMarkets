@wip
Feature: Premium user
  As a registered user
  I want to be able to pay for a premium account
  To have more capabilities on Personal Markets


  Scenario: A user can become premium in its profile page
    Given a user is in its profile page
    When he wants to become premium
    Then he needs to introduce his credit card data