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
 * Directlogin
 *
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 *
 * @package   MoodleServe
 * @copyright 2017 MoodleFreak.com
 * @author    Luuk Verhoeven
 **/
require_once 'config.php';
$userid = optional_param('id', '', PARAM_INT);
$action = optional_param('action', '', PARAM_MULTILANG);
$value = optional_param('value', '', PARAM_RAW);
$type = optional_param('type', '', PARAM_RAW);
if (!empty($action)) {
	
    switch ($type) {
        case 'boolean':
            if (isset($CFG->$action)) {
                if (empty($CFG->$action)) {
                    set_config($action, 1);
                } else {
                    set_config($action, 0);
                }
            }
            break;
        case 'debug':
            if (isset($CFG->$action)) {
                if (empty($CFG->$action)) {
                    set_config($action, 6143);
                } else {
                    set_config($action, 0);
                }
            }
            break;
    }
	
	// Dont forget purchase the cache.
    purge_all_caches();
}

echo '<h1>Moodle Information:</h1><br/>';
$url = $CFG->wwwroot . '/' . basename(__FILE__) . '?action=%s&type=%s&value=%s';
echo 'Moodle settings:<br/>';
echo '<strong>Hostname: ' . php_uname("n") . '</strong> Path: ' . $CFG->dirroot . '<br/><br/>';
echo 'Debug value: <a href="' . sprintf($url, 'debug', 'debug', $CFG->debug) . '">' . $CFG->debug . '</a><br/>';
echo 'Cache javascript: <a href="' . sprintf($url, 'cachejs', 'boolean', $CFG->cachejs) . '">' . $CFG->cachejs . '</a><br/>';
echo 'Debug display: <a href="' . sprintf($url, 'debugdisplay', 'boolean', $CFG->debugdisplay) . '">' . $CFG->debugdisplay . '</a><br/>';
echo 'Designer mode: <a href="' . sprintf($url, 'themedesignermode', 'boolean', $CFG->themedesignermode) . '">' . $CFG->themedesignermode . '</a><br/>';
echo 'Lang cache: <a href="' . sprintf($url, 'langcache', 'boolean', $CFG->langcache) . '">' . $CFG->langcache . '</a><br/>';
echo '<h1>Moodle user:</h1><br/>';
echo "Moodle 2.x detected... Logging you in...<br/><br/>";
if (is_numeric($userid)) {
    $USER = $DB->get_record('user', array('id' => $userid));
    if ($USER == false) {
        die("No user found.");
    } else {
        echo 'Completed!<br />';
        echo "<a href='" . $CFG->wwwroot . "'>Enter</a>";
    }
    die();
}
$role = $DB->get_record('role_assignments', array('roleid' => 1, 'contextid' => 1));
if ($role == false) {
    if (function_exists('get_admin')) {
        $ruser = get_admin();
        $role = (object)array('userid' => $ruser->id);
    } else {
        die("No admin role found.");
    }
}
$USER = $DB->get_record('user', array('id' => $role->userid));
if ($USER == false) {
    die("No user found.");
}

echo "<a href='" . $CFG->wwwroot . "'>Enter Moodle</a>";