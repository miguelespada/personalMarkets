@market_pro
@javascript
Feature: Make a market PRO
  As a registered user
  I want to make a market PRO
  In order to be able to show its coupons

  Scenario:
    Given I am logged in
    And I have a regular market with a coupon
    When I make it PRO
    Then Its coupon is visible

  @force_pro
  Scenario:
    Given I am logged in as an admin
    And There is a regular market
    When I force it PRO
    Then The market is PRO