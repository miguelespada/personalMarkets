@coupons 
@javascript

Feature: Buy market coupon
  In order to get extra services from a market
  As registered user
  I can buy coupons

  Background:
    Given I am logged in
    And There is a market with available coupons

  Scenario:
    When I buy some coupons
    Then I should be notified that the coupons has been bought
    And I should see the coupon transactions in my coupon transactions

  @on
  Scenario:
    When I buy some coupons
    Then I should be notified that the coupons has been bought
    Then I sign in as the market owner  
    Then I should see the coupon transactions in the market transactions

  @buy_coupon 
  Scenario: Buy no available a coupon
      When All the coupons are sold
      Then I should see that the coupon sold out