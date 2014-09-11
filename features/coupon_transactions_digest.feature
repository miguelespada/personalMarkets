@transaction_digest @javascript

Feature: Transactions digest
  In order to see the transactions
  As admin 
  I can see the transactions of the markets the has passed

  Background:
    And Some users buy coupons
    And The market finishes

  Scenario: See transactions of a passed market
    Then As admin I can see the transactions digest