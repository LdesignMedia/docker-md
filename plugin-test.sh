#!/bin/bash
export PATH="$(cd ci/bin; pwd):$(cd ci/vendor/bin; pwd):$PATH"

if [ $# -eq 0 ]
  then
    echo "path to folder not given / usage: blocks/messages "
fi

echo "codecheck"
moodle-plugin-ci codecheck $1

echo "grunt"
moodle-plugin-ci grunt $1

echo "phpmd"
moodle-plugin-ci phpmd $1

echo "savepoints"
moodle-plugin-ci savepoints $1

echo "mustache"
moodle-plugin-ci mustache $1

echo "phplint"
moodle-plugin-ci phplint $1

echo "phpcpd"
moodle-plugin-ci phpcpd $1

echo "phpunit"
moodle-plugin-ci phpunit $1

echo "behat"
moodle-plugin-ci behat $1

echo "Build amd"
grunt amd

#eslint $1/amd/src/file.js