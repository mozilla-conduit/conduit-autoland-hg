#!/bin/bash

if [ ! -e /repos/test-repo ]; then
    echo initing test-repo
    mkdir -p /repos
    hg init /repos/test-repo
    cd /repos/test-repo
    echo 'test/demo repo' > README
    hg commit -A -m 'initial commit'
fi

echo Starting hg web server
cd /repos/test-repo
exec hg serve --port 80 --accesslog /dev/null
