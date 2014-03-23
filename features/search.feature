Feature: Search markets
  As a user
  I want to search markets

  Background:
  Given There are some indexed markets
  And I go to Search

  @search
  Scenario: All the markets
    When I search with empty fields
    Then I should see all the markets

  @search
  Scenario: Search with query
    When I search with a query
    Then I should see the markets that match my search

  @search
  Scenario: Filter the search
    When I filter my search
    Then I should see the markets that match my filtered search

  @search
  Scenario: Search by date
    When I search with a date range
    Then I should see the markets that match my search with date