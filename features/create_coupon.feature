@create_coupon
Feature: Market coupons
  In order to have sell extra services for my market
  As market owner
  I want to be able to generate coupons

  Background:
    Given I am logged in
    And I have one market

  Scenario: Create a coupon
    When I visit the market page
    And I create a coupon
    Then I should be notified that the coupon has been created
    And I should see the coupon status page


  Scenario: Create a coupon
    When I visit the market page
    And I create a coupon with no available items
    And I try to buy the coupon
    Then I should see that the coupon sold out

  Scenario: Delete a coupon
