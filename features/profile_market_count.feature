@profile_count
Feature: User profile
  As a user
  I can see how many markets I created last month
  I can see how many markets I can create now

  Scenario: Normal user market limit
    Given I am logged in
    Then I should see that I have not created any markets during last month
    And I should see that I can still create one market
    And I create and publish a market
    Then I should see that I have to wait a month to create another market

  Scenario: Premium user market limit
    Given I am logged in as premium
    And I have created three markets within one month
    Then I should see that I have three markets during last month
    And I should see that I can still create one market
    And I create and publish a market
    Then I should see that I have to wait until the first market passed to create market