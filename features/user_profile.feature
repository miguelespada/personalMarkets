@user_profile
Feature: User profile
  As a new user
  I should be notified in my dashboard that I have to complete my profile

  Scenario: User profile dashboard notification
    Given I am a new user with profile photo
    Then I should see the notification of uncomplete profile in dashboard
    And I click the link to add nickname and description
    Then I should be notified that my profile has been updated
    And I should not see the notification of uncomplete profile in dashboard

  Scenario: User profile no photo dashboard notification
    Given I am a user without profile photo
    Then I should see the notification of uncomplete profile in dashboard
    And I click the link to add nickname and description
    Then I should be notified that my profile has been updated
    And I should see the notification of uncomplete profile in dashboard