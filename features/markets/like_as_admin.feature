@social  @like_as_admin
Feature: Like a market
  As a registered user
  I want to highlight markets
    
    Background:
      Given I am logged in as an admin
      Given There are some published markets

    Scenario: Like market
      When I like the market
      Then The number of likes increment
      And I cannot like that market again
      And The market becomes staff pick