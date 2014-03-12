Feature: Browse markets
  As a user
  I want to browse markets

  Background:
  Given There are some indexed markets
  When I go to the Markets
  
    @browse
    Scenario: I want to see the list of Markets
      Then I should see all the markets

    @search
    Scenario: I want to search with empty filter 
      And I click search
      Then I should see all the markets

    @search
    Scenario: I want to search specific markets
      And I fill the search field
      And I click search
      Then I should see the markets that match my search

    @search
    Scenario: I want to filter by category
      When I select one category
      And I click search
      Then I should see the markets that match my category
      
    @browse
    Scenario: I want to see the full description of a market
      And I click the details link of a market 
      Then I should see the full description of a market

    @browse
    Scenario: I want to see my markets
      Given I am a signed in
      And I go to my markets
      Then I should see all my markets
      Then I should see only my markets