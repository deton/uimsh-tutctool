#!/bin/sh
testsame () {
	if [ "$1" = "$2" ]; then
		echo OK
	else
		echo "NG (expected: $1, actual: $2)"
	fi
}

actual=`echo 'ÌÚÅá' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "ÎÂ" "$actual"

ln -s uimsh-tutctool.scm bushuconv
actual=`echo 'ÌÚÅá' | $PWD/bushuconv`
testsame "ÎÂ" "$actual"

actual=`echo '¢¥¢¥ÌÚ¢¥¿Í¿Í¾òÉ×' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "óÏ" "$actual"

actual=`echo 'ÌÚÅá' | $PWD/uimsh-tutctool.scm bushucand`
testsame "ÎÂÛ·ÛÃÛëÜ¸äíÛÊà®äÌ" "$actual"

actual=`echo '¸ıÌÚ¥¤' | $PWD/uimsh-tutctool.scm bushucand`
testsame "ÊİË«ÔÈèŞêğ" "$actual"

ln -s uimsh-tutctool.scm bushucand
actual=`echo '¸ıÌÚ¥¤' | $PWD/bushucand`
testsame "ÊİË«ÔÈèŞêğ" "$actual"

actual=`echo 'Ä·ÎÂ'|$PWD/uimsh-tutctool.scm tutchelp`
expect="  |  |  |  |  ||  |     |  |           |  ||
 3| b|  |  |  || 2|     |  |           |  ||
  |  |  | d|  ||  |     |  |a(ÎÂ¢¥ÌÚÅá)|  ||
  |  |  |  | e||  |1(Ä·)| f|           |  ||"
testsame "$expect" "$actual"

ln -s uimsh-tutctool.scm tutchelp
actual=`echo 'Ä·ÎÂ'|$PWD/tutchelp`
testsame "$expect" "$actual"

actual=`echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji`
testsame "Ãæ¸Å" "$actual"

actual=`echo 'aljdljdjru fjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji`
testsame "ÅÜŞ¹¤Î¿ÊÄ½" "$actual"

ln -s uimsh-tutctool.scm seq2kanji
actual=`echo 'if.g'|$PWD/seq2kanji`
testsame "Ãæ¸Å" "$actual"

actual=`echo 'ÅÅÃÏµë·îÊ¬Æ°ÅÄ¿·Æ± ' | $PWD/uimsh-tutctool.scm kanji2seq \
| cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji`
testsame "¤¦¤«¤â¤·¤ì¤Ş¤»¤ó¡£" "$actual"

ln -s uimsh-tutctool.scm kanji2seq
actual=`echo 'ÅÅÃÏµë·îÊ¬Æ°ÅÄ¿·Æ± ' | $PWD/kanji2seq \
| cut -b 2- | $PWD/seq2kanji`
testsame "¤¦¤«¤â¤·¤ì¤Ş¤»¤ó¡£" "$actual"

actual=`echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm kcodeucs`
testsame "¢¤" "$actual"

ln -s uimsh-tutctool.scm kcodeucs
actual=`echo U+25b3 | $PWD/kcodeucs`
testsame "¢¤" "$actual"
