@add_photo
Feature: Create market with photo
  As a registered user
  I want to create a market with photo

  Background:
    Given I am logged in

  Scenario: Add Market with market
    When I create a market with photo
    Then I should see the photo in my media library
