Feature: Markets
  In order to other users can see my market
  As a user
  I want to add a market

	Scenario: Add Market
	  Given I am in the add market page
	  When I fill in the name and description
	  And I click on the save market button
	  Then I should see my personal market page
	  And I should be notified that the market has been added

#	 Scenario: Add featured photo
#	 	Given I am in my personal market page
#	 	When I upload a photo
 #	    Then I should see the photo
 #	    And I should be notified that the featured photo has been added
