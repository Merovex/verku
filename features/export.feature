Feature: Food
  In order to portray or pluralize food
  As a CLI
  I want to be as objective as possible

  Scenario: Create a PDF
    When I run "bookmaker export --only html"
    Then the output should contain "Bookmaker version"