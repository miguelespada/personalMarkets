@list_coupons
Feature: List market coupon
  In order to admin my coupons
  As registered user
  I can see the coupons that have been sold


  Background:
    Given there are some users
    And I have some coupons
    Given Someonelse buys one of my coupons

  Scenario:
    When I sign in
    And I visit the market's Coupon Transactions
    Then I should see the coupons that have been sold

  Scenario:
    When I am logged in as an admin
    And I go to Coupon Transactions
    Then I should see the coupons that have been sold