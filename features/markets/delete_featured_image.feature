@wip
Feature: Delete market featured image
  As an admin
  I want to delete market's featured image
  So that It cannot be seen

  Scenario: Delete image as an admin
    Given I am logged in as an admin
    And I visit a market
    When I delete the image
    Then I cannot see it in the market page