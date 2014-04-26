@coupons
Feature: Market coupons
  In order to have sell extra services for my market
  As market owner
  I want to be able to generate coupons

  Background:
    Given I am logged in
    And I have one market

  @create_coupon
  Scenario: Create a coupon
    When I visit the edit market page
    And I create a coupon
    And I should see the coupon in the market page

  Scenario: Buy no availablae a coupon
    When I visit the market page
    And I create a coupon with no available items
    And I try to buy the coupon
    Then I should see that the coupon sold out

  Scenario: Delete a coupon
