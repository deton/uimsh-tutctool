#!/bin/sh
testsame () {
	if [ "$1" = "$2" ]; then
		echo OK
	else
		echo "NG (expected: $1, actual: $2)"
	fi
}

actual=`$PWD/uimsh-tutctool.scm`
testsame "Usage: uimsh-tutctool.scm <tutchelp|kanji2seq|seq2kanji|bushuconv|bushucand|kcodeucs|kuten> [str]..." "$actual"

actual=`echo '木刀' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "梁" "$actual"
actual=`echo '木刀' | $PWD/uimsh-tutctool.scm b`
testsame "梁" "$actual"

if [ ! -e bushuconv ]; then
	ln -s uimsh-tutctool.scm bushuconv
fi
actual=`echo '木刀' | $PWD/bushuconv`
testsame "梁" "$actual"

actual=`echo '▲▲木▲人人条夫' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "麩" "$actual"

actual=`$PWD/uimsh-tutctool.scm bushuconv '木刀' '▲▲木▲人人条夫'`
expect='梁
麩'
testsame "$expect" "$actual"
actual=`$PWD/uimsh-tutctool.scm b '木刀' '▲▲木▲人人条夫'`
testsame "$expect" "$actual"
actual=`$PWD/bushuconv '木刀' '▲▲木▲人人条夫'`
testsame "$expect" "$actual"

actual=`echo '木刀' | $PWD/uimsh-tutctool.scm bushucand`
testsame "梁朷枌梛楔粱枴牀簗" "$actual"
actual=`echo '木刀' | $PWD/uimsh-tutctool.scm c`
testsame "梁朷枌梛楔粱枴牀簗" "$actual"

actual=`echo '口木イ' | $PWD/uimsh-tutctool.scm bushucand`
testsame "保褒堡葆褓" "$actual"

if [ ! -e bushucand ]; then
	ln -s uimsh-tutctool.scm bushucand
fi
actual=`echo '口木イ' | $PWD/bushucand`
testsame "保褒堡葆褓" "$actual"

actual=`$PWD/uimsh-tutctool.scm bushucand '木刀' '口木イ'`
expect='梁朷枌梛楔粱枴牀簗
保褒堡葆褓'
testsame "$expect" "$actual"
actual=`$PWD/bushucand '木刀' '口木イ'`
testsame "$expect" "$actual"

actual=`echo '跳梁'|$PWD/uimsh-tutctool.scm tutchelp`
expect="  |  |  |  |  ||  |     |  |           |  ||
 3| b|  |  |  || 2|     |  |           |  ||
  |  |  | d|  ||  |     |  |a(梁▲木刀)|  ||
  |  |  |  | e||  |1(跳)| f|           |  ||"
testsame "$expect" "$actual"
actual=`echo '跳梁'|$PWD/uimsh-tutctool.scm h`
testsame "$expect" "$actual"
actual=`$PWD/uimsh-tutctool.scm tutchelp '跳梁'`
testsame "$expect" "$actual"

if [ ! -e tutchelp ]; then
	ln -s uimsh-tutctool.scm tutchelp
fi
actual=`echo '跳梁'|$PWD/tutchelp`
testsame "$expect" "$actual"
actual=`$PWD/tutchelp '跳梁'`
testsame "$expect" "$actual"

actual=`echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji`
testsame "中古" "$actual"

actual=`echo 'aljdljdjru fjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji`
testsame "怒濤の進捗" "$actual"

if [ ! -e seq2kanji ]; then
	ln -s uimsh-tutctool.scm seq2kanji
fi
actual=`echo 'jsnf'|$PWD/seq2kanji`
testsame "月光" "$actual"

actual=`$PWD/uimsh-tutctool.scm seq2kanji 'if.g' 'aljdljdjru fjxiala/.;f'`
expect='中古
怒濤の進捗'
testsame "$expect" "$actual"
actual=`$PWD/uimsh-tutctool.scm s 'if.g' 'aljdljdjru fjxiala/.;f'`
testsame "$expect" "$actual"
actual=`$PWD/seq2kanji 'if.g' 'aljdljdjru fjxiala/.;f'`
testsame "$expect" "$actual"

actual=`echo '電地給月分動田新同 ' | $PWD/uimsh-tutctool.scm kanji2seq \
| cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji`
testsame "うかもしれません。" "$actual"

if [ ! -e kanji2seq ]; then
	ln -s uimsh-tutctool.scm kanji2seq
fi
actual=`echo '電地給月分動田新同 ' | $PWD/kanji2seq \
| cut -b 2- | $PWD/seq2kanji`
testsame "うかもしれません。" "$actual"

actual=`$PWD/uimsh-tutctool.scm kanji2seq '電地給月分動田新同 '`
testsame "jruekwjsighwkshflf " "$actual"
actual=`$PWD/uimsh-tutctool.scm k '電地給月分動田新同 '`
testsame "jruekwjsighwkshflf " "$actual"
actual=`$PWD/kanji2seq '電地給月分動田新同 '`
testsame "jruekwjsighwkshflf " "$actual"

actual=`echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm kcodeucs`
testsame "△" "$actual"
actual=`echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm u`
testsame "△" "$actual"

if [ ! -e kcodeucs ]; then
	ln -s uimsh-tutctool.scm kcodeucs
fi
actual=`echo U+25b3 | $PWD/kcodeucs`
testsame "△" "$actual"

actual=`uim-sh $PWD/uimsh-tutctool.scm kcodeucs U+25b3`
testsame "△" "$actual"
actual=`uim-sh $PWD/kcodeucs U+25b3`
testsame "△" "$actual"

actual=`echo 1-48-13 | uim-sh $PWD/uimsh-tutctool.scm kuten`
testsame "亅" "$actual"
actual=`echo 1-48-13 | uim-sh $PWD/uimsh-tutctool.scm t`
testsame "亅" "$actual"

if [ ! -e kuten ]; then
	ln -s uimsh-tutctool.scm kuten
fi
actual=`echo 1-48-13 | $PWD/kuten`
testsame "亅" "$actual"

actual=`uim-sh $PWD/uimsh-tutctool.scm kuten 1-48-13`
testsame "亅" "$actual"
actual=`uim-sh $PWD/kuten 1-48-13`
testsame "亅" "$actual"
