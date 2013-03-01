Feature: Food
  In order to portray or pluralize food
  As a CLI
  I want to be as objective as possible

  Scenario: Do I work
    When I run "bookmaker --version"
    Then the output should contain "bookmaker version"
