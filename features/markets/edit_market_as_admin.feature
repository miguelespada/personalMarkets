@javascript @edit_as_admin
Feature: Edit market as admin
  As an admin
  I want to modify my market
  So that I can update its information

  Background:
    Given I am logged in as an admin
    When I visit a market

  Scenario: Edit market
    Then I can edit the market

  Scenario: Modify market notifies on update
    And I edit the market
    Then I am notified that the market has been succesfully updated

  Scenario: Modify market updates market info
    And I edit the market
    Then I see the market page with the new data

