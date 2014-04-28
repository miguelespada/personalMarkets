@create_coupon
Feature: Market coupons
  In order to have sell extra services for my market
  As market owner
  I want to be able to generate coupons

  Background:
    Given I am logged in
    And I have one market

  Scenario: Create a coupon
    When I visit the edit market page
    And I create a coupon
    Then I should see the coupon in the market page

  Scenario: Update a coupon

  Scenario: Delete a coupon