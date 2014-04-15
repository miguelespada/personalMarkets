@coupons @buy_coupon
Feature: Buy market coupon
  In order to get extra services from a market
  As registered user
  I can buy coupons

  Background:
    Given I am logged in
    And There is a market with available coupons

  Scenario:
    When I visit the market page
    And I buy some coupons
    Then I should be notified that the coupons has been bought
    And I should see the coupons in My coupons [BUY]