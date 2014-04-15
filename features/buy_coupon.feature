@coupons @buy_coupon
Feature: Buy market coupon
  In order to get extra services from a market
  As registered user
  I can buy coupons

  Background:
    Given I am logged in
    And There is a market with available coupons

  Scenario:
    And I buy some coupons
    Then I should be notified that the coupons has been bought
    And I should see the coupons in My Coupons

  Scenario:
    When I buy some coupons
    And I sign out
    Then The market owner should see that I bought some coupons

  Scenario:
    When I buy some coupons
    And I sign out
    Then The admin should see that I bought some coupons