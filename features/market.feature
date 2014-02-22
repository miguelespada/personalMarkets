@markets

	Feature: Market creation
	  As user
	  I want to create markets

	Scenario: Access to markets
	  Given I am in the app
	  When I click "Markets"
	  Then I should see the link "Create new market" 

	Scenario: Market form
	  Given I am in Markets
	  When I click "Create new market" 
	  Then I should see the field "Market Name"
	  Then I should see the field "Description" 
	  Then I should see the button "Create Market" 

	Scenario: Create Market
	  Given I am in Create New Market
	   When I fill out the form with the following attributes:
      | Name    	| Magadalenas Federico       |
      | Description   | Rellenas de chocolate    |
      And I click the Create Market button
    Then I should see "Market was successfully created."
