@payback
Feature: retrieving coupons money to users
  As an admin
  I want to retrieve coupons sold money to users
  In order to get them paid

  Scenario: some coupons sold but no money retrieved yet
    Given There is a user with some coupons sold
    When I pay him back
    Then the money owed to him decreases