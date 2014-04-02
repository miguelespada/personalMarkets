@users
Feature: Guest users

  Background:
    Given I am not logged in

  Scenario: Visit a market
    And There is someone else's market
    When I visit a market page
    Then I should see the full description of the market except the address

  
  Scenario: Sign up with Omniauth
    When I visit the sign in page
    Then I am able to sign up with Facebook and Gmail
