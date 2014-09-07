@social @like
Feature: Like a market
  As a registered user
  I want to like other users markets
  So that I can follow them
    
    Background:
      When I am logged in
      Given There are some published markets

    @like_market
    Scenario: Like market
      When I like the market
      Then The number of likes increment
      Then I cannot like that market again