@like
Feature: Like a market
  As a registered user
  I want to like other users markets
  So that I can follow them

    Scenario: Like market button
      Given There is someone else's market
      And I am logged in
      When I am in the market page
      Then there is a like button

    Scenario: Unable to like my markets
      Given I am logged in
      And I have one market
      When I visit the market page
      Then there is no like button

    @like_count
    Scenario: Like count increment
      Given There is someone else's market
      And I am logged in
      When I am in the market page
      And click the like button
      Then the number of likes increment

    Scenario: Disable like button when already liked
      Given There is someone else's market
      And I am logged in
      When I am in the market page
      And click the like button
      Then I cannot like that market again
