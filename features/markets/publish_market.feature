@wip
Feature: Publish market

Background:
  Given I am logged in
  And I have a draft market
  And I go the market page

Scenario: Draft market view
  Then I can publish it

Scenario: Notified when publishing
  When I publish the market
  Then I see a success publishing notification

Scenario: Appears in published markets list
  When I publish the market
  Then I see it in the published markets