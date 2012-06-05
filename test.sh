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

actual=`echo '¢¥¢¥ÌÚ¢¥¿Í¿Í¾òÉ×' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "óÏ" "$actual"

actual=`echo 'ÌÚÅá' | $PWD/uimsh-tutctool.scm bushucand`
testsame "ÎÂÛ·ÛÃÛëÜ¸äíÛÊà®äÌ" "$actual"

actual=`echo '¸ıÌÚ¥¤' | $PWD/uimsh-tutctool.scm bushucand`
testsame "ÊİË«ÔÈèŞêğ" "$actual"

actual=`echo 'Ä·ÎÂ'|$PWD/uimsh-tutctool.scm tutchelp`
expect="  |  |  |  |  ||  |     |  |           |  ||
 3| b|  |  |  || 2|     |  |           |  ||
  |  |  | d|  ||  |     |  |a(ÎÂ¢¥ÌÚÅá)|  ||
  |  |  |  | e||  |1(Ä·)| f|           |  ||"
testsame "$expect" "$actual"

actual=`echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji`
testsame "Ãæ¸Å" "$actual"

actual=`echo 'aljdljdjru fjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji`
testsame "ÅÜŞ¹¤Î¿ÊÄ½" "$actual"

actual=`echo 'ÅÅÃÏµë·îÊ¬Æ°ÅÄ¿·Æ± ' | $PWD/uimsh-tutctool.scm kanji2seq \
| cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji`
testsame "¤¦¤«¤â¤·¤ì¤Ş¤»¤ó¡£" "$actual"
