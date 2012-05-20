#!/bin/sh
case "$1" in
bushucand|bushuconv|help|kanji2seq|seq2kanji)
	;;
*)
	echo "Usage: $0 <bushucand|bushuconv|help|kanji2seq|seq2kanji>"
	exit 1
	;;
esac

# $scmfile must be absolute path
dir=$(cd "$(dirname $0)"; pwd)
# or use realpath (FreeBSD) or readlink -f (Linux)
scmfile="$dir/uimsh-tutctool.scm"
uim-sh "$scmfile" $@
