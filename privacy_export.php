<?php
/**
 * File: privacy_export.php
 * Encoding: UTF8
 *
 * @package: docker-md
 *
 * @Version: 1.0.0
 * @Since  21-4-2018
 * @Author : MoodleFreak.com | Ldesign.nl - Luuk Verhoeven
 **/

/**
 * Testing the Privacy API - export
 * https://docs.moodle.org/dev/Privacy_API/Utilities
 */
define('CLI_SCRIPT', true);

require_once('config.php');

$user = \core_user::get_user(2);

\core\session\manager::init_empty_session();
\core\session\manager::set_user($user);

$manager = new \core_privacy\manager();

$approvedlist = new \core_privacy\local\request\contextlist_collection($user->id);

$contextlists = $manager->get_contexts_for_userid($user->id);
foreach ($contextlists as $contextlist) {
    $approvedlist->add_contextlist(new \core_privacy\local\request\approved_contextlist(
        $user,
        $contextlist->get_component(),
        $contextlist->get_contextids()
    ));
}

$exportedcontent = $manager->export_user_data($approvedlist);

echo "\n";
echo "== File was successfully exported to {$exportedcontent}\n";

$basedir = make_temp_directory('privacy');
$exportpath = make_unique_writable_directory($basedir, true);
$fp = get_file_packer();
$fp->extract_to_pathname($exportedcontent, $exportpath);

echo "== File export was uncompressed to {$exportpath}\n";
echo "============================================================================\n";