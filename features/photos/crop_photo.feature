@crop_photo
Feature: Crop photo
  In order to have nice galleries
  I would like to crop de photos

  Scenario:
    Given I have a market with photo
    When I crop the photo
    Then I should see the cropped photo