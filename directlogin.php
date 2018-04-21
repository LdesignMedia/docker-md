<?php
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