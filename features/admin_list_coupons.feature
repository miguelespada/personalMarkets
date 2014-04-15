@coupons @list_coupons
Feature: Admin list market coupons
  In order to admin the coupons
  As admin
  I can see the coupons 

  Background:
    Given There is a market with available coupons
    And I am logged in as an admin
  
  Scenario:
    And I go to Coupons
    Then I should see all the coupons that are emitted
