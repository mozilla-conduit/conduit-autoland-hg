#!/bin/sh
set -e
REPO=${REOP:-test-repo}
case "${1:-start}" in
    "init")
        if [ -d /repos/$REPO ]; then
            exit
        fi
        echo "Initialising $REPO"
        mkdir -p /repos
        hg init /repos/$REPO
        cd /repos/$REPO
        echo $REPO > README
        hg commit -A -m 'initial commit'
        ;;
    "start")
        echo Starting hg web server on port ${PORT:-8000}
        cd /repos/$REPO
        exec hg serve --port ${PORT:-8000} --accesslog /dev/null
        ;;
    *)
        exec $*
        ;;
esac
