@create_vim @javascript

Feature: Create VIM market
  As a registered user
  I want to create a VIM market
  So that I can add a coupon to my market

  Background:
    Given I am logged in

  Scenario: Add VIM Market
    When I create a VIM market
    Then I should see the new VIM market page
    And I edit the VIM market
    Then I should be able to create a vim gallery
    Then I should be able to add a coupon for the market
    And I create a coupon
    Then I should see the coupon I added
