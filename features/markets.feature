Feature: Markets
  In order to other users can see my market
  As user
  I want to add a market

Scenario: Add Market
  Given I am in the add market page
  When I fill in the name and description
  And I click on the save market button
  Then I should see my personal market page 