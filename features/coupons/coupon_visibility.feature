@coupons
@coupon_visibility

Feature: Coupon visibility
  In order to get extra services from a market
  As registered user
  I can buy coupons

  Scenario: Regular user non pro market with coupon
    Given a regular user's non pro market with a coupon
    When I visit the market page
    Then I cannot see the coupon

  Scenario: Regular user pro market with coupon
    Given a regular user's pro market with a coupon
    When I visit the market page
    Then I can see the coupon