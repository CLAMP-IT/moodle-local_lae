@anon_forum @local_lae @anon_forum_recent_activity
Feature: Print Anonymous Forum Recent Activity
  In order to view recent activity from an anonymous forum
  As a teacher
  I need to add a Recent Activities block to the course page

  @javascript
  Scenario: Recent anonymous forum activity displays in the Recent Activities block
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
    And the following config values are set as admin:
      | forum_enableanonymousposts | 1 |
    And the following "activities" exist:
      | activity | course | idnumber | name            | intro     | grade |
      | forum    | C1     | f1       | Anonymous Forum | Anonymous | 10    |
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I turn editing mode on
    And I add the "Recent activity" block if not present
    And I follow "Anonymous Forum"
    And I follow "Add a new discussion topic"
    And I set the field "subject" to "Post 1 subject"
    And I set the field "id_message" to "Body 1 content"
    And I press "Post to forum"
    When I am on "Course 1" course homepage
    Then I should see "New forum posts"
    And I should see "Post 1 subject"
