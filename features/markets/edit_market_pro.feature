Feature: Edit market pro
  As a registered user
  I want to make my market PRO
  So that I can use the photo gallery

  Background:
    Given I am logged in
    And I have one market

  @edit_market_normal
  Scenario: Edit a normal market
    When I go to the edit market page
    Then I should see the link of photo gallery is disabled
	
	@edit_market_pro @javascript
  Scenario: Edit a pro market
    When I make it PRO
    Then I click on edit the market
    Then I should see the link of photo gallery is enabled