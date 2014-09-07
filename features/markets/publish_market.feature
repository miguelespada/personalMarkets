@publish_market
Feature: Publish market

Scenario: Draft market view
  Given I am logged in
  And I have a draft market
  And I go the market page
  Then I can publish it

Scenario: When the market has coupon and I am regular user
  Given I am logged in
  And I have a draft market with a coupon
  And I go the market page
  When I publish the market
  Then I should see a warning about coupon visibility

Scenario: When the market has coupon and I am premium user
  Given I am logged in as premium
  And I have a draft market with a coupon
  And I go the market page
  When I publish the market
  Then I see a success publishing notification
  Then I see it in the published markets
  Then I cannot publish it again

Scenario: Notified when publishing
  Given I am logged in
  And I have a draft pro market
  And I go the market page
  When I publish the market
  Then I see a success publishing notification
  Then I see it in the published markets
  Then I cannot publish it again
