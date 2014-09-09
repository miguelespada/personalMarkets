@user_follow
Feature: User self follow
  As a registered user
  I cannot follow myself
    
    Scenario: follow myself
      When I am logged in
      And I go to my profile page
      Then I should not be able to follow myself