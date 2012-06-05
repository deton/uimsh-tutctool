#!/bin/sh
testsame () {
	if [ "$1" = "$2" ]; then
		echo OK
	else
		echo "NG (expected: $1, actual: $2)"
	fi
}

actual=`echo '木刀' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "梁" "$actual"

ln -s uimsh-tutctool.scm bushuconv
actual=`echo '木刀' | $PWD/bushuconv`
testsame "梁" "$actual"

actual=`echo '▲▲木▲人人条夫' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "麩" "$actual"

actual=`echo '木刀' | $PWD/uimsh-tutctool.scm bushucand`
testsame "梁朷枌梛楔粱枴牀簗" "$actual"

actual=`echo '口木イ' | $PWD/uimsh-tutctool.scm bushucand`
testsame "保褒堡葆褓" "$actual"

ln -s uimsh-tutctool.scm bushucand
actual=`echo '口木イ' | $PWD/bushucand`
testsame "保褒堡葆褓" "$actual"

actual=`echo '跳梁'|$PWD/uimsh-tutctool.scm tutchelp`
expect="  |  |  |  |  ||  |     |  |           |  ||
 3| b|  |  |  || 2|     |  |           |  ||
  |  |  | d|  ||  |     |  |a(梁▲木刀)|  ||
  |  |  |  | e||  |1(跳)| f|           |  ||"
testsame "$expect" "$actual"

ln -s uimsh-tutctool.scm tutchelp
actual=`echo '跳梁'|$PWD/tutchelp`
testsame "$expect" "$actual"

actual=`echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji`
testsame "中古" "$actual"

actual=`echo 'aljdljdjru fjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji`
testsame "怒濤の進捗" "$actual"

ln -s uimsh-tutctool.scm seq2kanji
actual=`echo 'if.g'|$PWD/seq2kanji`
testsame "中古" "$actual"

actual=`echo '電地給月分動田新同 ' | $PWD/uimsh-tutctool.scm kanji2seq \
| cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji`
testsame "うかもしれません。" "$actual"

ln -s uimsh-tutctool.scm kanji2seq
actual=`echo '電地給月分動田新同 ' | $PWD/kanji2seq \
| cut -b 2- | $PWD/seq2kanji`
testsame "うかもしれません。" "$actual"

actual=`echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm kcodeucs`
testsame "△" "$actual"

ln -s uimsh-tutctool.scm kcodeucs
actual=`echo U+25b3 | $PWD/kcodeucs`
testsame "△" "$actual"
