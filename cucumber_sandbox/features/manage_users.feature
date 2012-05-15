@focus
Feature: Manage users
  In order to manage user details
  security enthusiast
  wants to edit user profiles only when authorized


  Scenario Outline: Show or hide edit link
    Given the following user records
      | email             | password | admin |
      | bob@example.com   | secret   | false |
      | admin@example.com | secret   | true  |
    Given I am logged in as "<login>" with password "secret"
    When I visit profile for "<profile>"
    Then I should <action>

    Examples:
      | login             | profile           | action                 |
      | admin@example.com | bob@example.com   | see "Edit Profile"     |
      | bob@example.com   | bob@example.com   | see "Edit Profile"     |
      |                   | bob@example.com   | not see "Edit Profile" |
      | bob@example.com   | admin@example.com | not see "Edit Profile" |
