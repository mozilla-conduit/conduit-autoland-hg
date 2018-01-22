#!/bin/sh
set -e
REPO_NAME=${REPO_NAME:-test-repo}
case "${1:-start}" in
    "init")
        if [ -d /repos/$REPO_NAME ]; then
            exit
        fi
        echo "Initialising $REPO_NAME"
        mkdir -p /repos
        hg init /repos/$REPO_NAME
        cd /repos/$REPO_NAME
        echo $REPO_NAME > README
        hg commit -A -m 'initial commit'
        hg phase --public -r .
        ;;
    "start")
        echo Starting hg web server on port ${PORT:-8000}
        cd /repos/$REPO_NAME
        exec hg serve --port ${PORT:-8000} --accesslog /dev/null
        ;;
    *)
        exec $*
        ;;
esac
