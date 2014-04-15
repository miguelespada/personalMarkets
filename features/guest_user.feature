@users
Feature: Guest users

  Background:
    Given I am not logged in
 
  Scenario: Sign up with Omniauth
    When I visit the sign in page
    Then I am able to sign up with Facebook and Gmail
