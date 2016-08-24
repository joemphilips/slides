#!/usr/bin/env bash
set -u

readonly VERSION="1.0"
readonly SCRIPT_DIR_PATH=$(dirname $(readlink -f $0))

usage() {
    [ $# -ne 0 ] && echo -e $@
    cat << _EOT_
    Usage:
    $0 contentsdir
    Desctription:
        hoge
    Options:
        contentsdir: directory containing contents for webpage.
            must include index.html

_EOT_

    exit 1
}

REVISION=$(git rev-parse --short HEAD) || REVISION="first"

if [ -n "$(git status --porcelain)" ]; then
    usage "working directory should be clean before pushing !!";
fi


rm -rf gh-pages 2> /dev/null
git worktree prune
git branch -D gh-pages

git checkout -b gh-pages origin/gh-pages
# git reset --hard && git checkout master
git worktree add gh-pages
cp -r $1 gh-pages || usage
cd gh-pages
git add . && git commit -m "published at $REVISION"
git push -u origin gh-pages
git checkout master
