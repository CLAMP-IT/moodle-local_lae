@local @local_lae
Feature: Add an anonymous forum
  In order to create an anonymous forum
  As a teacher
  I need to add anonymous forum activities to moodle courses

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | student1 | Student   | 1        | student1@example.com |
      | student2 | Student   | 2        | student2@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
      | student2 | C1     | student        |
    And I log in as "admin"
    And I navigate to "Plugins > Activity modules > Forum" in site administration
    And I set the following fields to these values:
      | Post anonymously | 1 |
    And I press "Save changes"
    And I am on site homepage
    And I log out
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I turn editing mode on

  @javascript
  Scenario: Set anonymous forums option to always and create one
    Given I add a forum activity to course "C1" section "1" and I fill the form with:
      | Forum name       | Test forum name        |
      | Description      | Test forum description |
      | Anonymize posts? | Yes, always            |
    And I log out
    And I log in as "student1"
    And I am on "Course 1" course homepage
    And I follow "Test forum name"
    And I follow "Add discussion topic"
    Then "input[name=anonymous]" "css_element" should not be visible
    And I set the field "subject" to "Post 1 subject"
    And I set the field "id_message" to "Body 1 content"
    And the "input[id=id_anonymous]" "css_element" should be disabled
    And I press "Post to forum"
    Then I should see "Anonymous User"
    And I follow "Post 1 subject"
    Then I should see "by Anonymous User"
    And I log out
    And I log in as "student2"
    And I am on "Course 1" course homepage
    And I follow "Test forum name"
    Then I should see "Anonymous User"
    And I follow "Post 1 subject"
    Then I should see "Anonymous User"

  @javascript
  Scenario: Set anonymous forums option to optional and create one
    Given I add a forum activity to course "C1" section "1" and I fill the form with:
      | Forum name       | Test forum 2 name        |
      | Description      | Test forum 2 description |
      | Anonymize posts? | Yes, let the user decide |
    And I log out
    And I log in as "student1"
    And I am on "Course 1" course homepage
    And I follow "Test forum 2 name"
    Then "input[name=anonymous]" "css_element" should not be visible
    And I follow "Add discussion topic"
    Then "input[name=anonymous]" "css_element" should be visible
    And I set the field "subject" to "Post 2 subject"
    And I set the field "id_message" to "Body 2 content"
    And the "input[name=anonymous]" "css_element" should be enabled
    And I click on "input[name=anonymous]" "css_element"
    And I press "Post to forum"
    Then I should see "Anonymous User"
    And I log out
    And I log in as "student2"
    And I am on "Course 1" course homepage
    And I follow "Test forum 2 name"
    Then I should see "Anonymous User"
    And I follow "Post 2 subject"
    Then I should see "by Anonymous User"
    And I reply "Post 2 subject" post from "Test forum 2 name" forum with:
      | Subject          | This is the post content |
      | Message          | This is the body         |
      | Post anonymously | 0                        |
    Then I should see "by Student 2"
    And I should see "Anonymous User"
