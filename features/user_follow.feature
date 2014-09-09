@user_follow
Feature: User Follow
  As a registered user
  I can follow some other users
  So that I can get their activities
    
    Background:
      When I am logged in
      Given there is another user
      And I go to the page of the other user

    Scenario: follow a user
      Then I should be able to follow the other user
      And I follow the other user
      Then I should see my name on the list of the followers
      Then I go to my profile page
      And I should see that I am following the other user

    Scenario: unfollow a user
      Given I am following the other user
      Then I should be able to unfollow the other user
      And I unfollow the other user
      Then I should not see my name on the list of the followers
      Then I go to my profile page
      And I should not see that I am following the other user


