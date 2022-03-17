<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Upgrade tasks.
 *
 * @package    local_lae
 * @copyright  2018 CLAMP
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * Upgrade tasks for existing installations.
 *
 * @param int $oldversion the current version
 *
 * @return boolean
 */
function xmldb_local_lae_upgrade($oldversion) {
    global $CFG, $DB;
    $dbman = $DB->get_manager();

    if ($oldversion < 2013061200) {
        // Update course table to support display defaults.
        $table = new xmldb_table('course');
        $field = new xmldb_field('filedisplaydefault', XMLDB_TYPE_INTEGER, '2', null, null, null, null, null);
        if (!$dbman->field_exists($table, $field)) {
            $dbman->add_field($table, $field);
        }
        upgrade_plugin_savepoint(true, 2013061200, 'local', 'lae');
    }

    if ($oldversion < 2014010900) {
        // Add mnethostid and email address to Anonymous User.
        $user = $DB->get_record('user', array('id' => $CFG->anonymous_userid));
        if (empty($user->email)) {
            $user->email = get_string('auser_email', 'local_lae');
        }
        $user->mnethostid = $CFG->mnet_localhost_id;
        $DB->update_record('user', $user);
        upgrade_plugin_savepoint(true, 2014010900, 'local', 'lae');
    }

    if ($oldversion < 2014041600) {
        // Set context for Anonymous User.
        $user = $DB->get_record('user', array('id' => $CFG->anonymous_userid));
        context_user::instance($user->id);
        upgrade_plugin_savepoint(true, 2014041600, 'local', 'lae');
    }

    if ($oldversion < 2019062500) {
        // Backfill hiddenuserid.
        $sql = "UPDATE {forum_posts} SET hiddenuserid=0 WHERE hiddenuserid IS NULL";
        $DB->execute($sql);

        // Do not allow null values for hiddenuserid.
        $table = new xmldb_table('forum_posts');
        $field = new xmldb_field('hiddenuserid', XMLDB_TYPE_INTEGER, '10', XMLDB_UNSIGNED, XMLDB_NOTNULL, null, '0', 'mailnow');
        $dbman->change_field_notnull($table, $field);
        upgrade_plugin_savepoint(true, 2019062500, 'local', 'lae');
    }

    return true;
}
