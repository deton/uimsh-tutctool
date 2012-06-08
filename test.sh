#!/bin/sh
testsame () {
	if [ "$1" = "$2" ]; then
		echo OK
	else
		echo "NG (expected: $1, actual: $2)"
	fi
}

actual=`$PWD/uimsh-tutctool.scm`
testsame "Usage: uimsh-tutctool.scm <tutchelp|kanji2seq|seq2kanji|bushuconv|bushucand|kcodeucs> [str]..." "$actual"

actual=`echo 'ÌÚÅá' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "ÎÂ" "$actual"
actual=`echo 'ÌÚÅá' | $PWD/uimsh-tutctool.scm b`
testsame "ÎÂ" "$actual"

if [ ! -e bushuconv ]; then
	ln -s uimsh-tutctool.scm bushuconv
fi
actual=`echo 'ÌÚÅá' | $PWD/bushuconv`
testsame "ÎÂ" "$actual"

actual=`echo '¢¥¢¥ÌÚ¢¥¿Í¿Í¾òÉ×' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "óÏ" "$actual"

actual=`$PWD/uimsh-tutctool.scm bushuconv 'ÌÚÅá' '¢¥¢¥ÌÚ¢¥¿Í¿Í¾òÉ×'`
expect='ÎÂ
óÏ'
testsame "$expect" "$actual"
actual=`$PWD/uimsh-tutctool.scm b 'ÌÚÅá' '¢¥¢¥ÌÚ¢¥¿Í¿Í¾òÉ×'`
testsame "$expect" "$actual"
actual=`$PWD/bushuconv 'ÌÚÅá' '¢¥¢¥ÌÚ¢¥¿Í¿Í¾òÉ×'`
testsame "$expect" "$actual"

actual=`echo 'ÌÚÅá' | $PWD/uimsh-tutctool.scm bushucand`
testsame "ÎÂÛ·ÛÃÛëÜ¸äíÛÊà®äÌ" "$actual"
actual=`echo 'ÌÚÅá' | $PWD/uimsh-tutctool.scm c`
testsame "ÎÂÛ·ÛÃÛëÜ¸äíÛÊà®äÌ" "$actual"

actual=`echo '¸ıÌÚ¥¤' | $PWD/uimsh-tutctool.scm bushucand`
testsame "ÊİË«ÔÈèŞêğ" "$actual"

if [ ! -e bushucand ]; then
	ln -s uimsh-tutctool.scm bushucand
fi
actual=`echo '¸ıÌÚ¥¤' | $PWD/bushucand`
testsame "ÊİË«ÔÈèŞêğ" "$actual"

actual=`$PWD/uimsh-tutctool.scm bushucand 'ÌÚÅá' '¸ıÌÚ¥¤'`
expect='ÎÂÛ·ÛÃÛëÜ¸äíÛÊà®äÌ
ÊİË«ÔÈèŞêğ'
testsame "$expect" "$actual"
actual=`$PWD/bushucand 'ÌÚÅá' '¸ıÌÚ¥¤'`
testsame "$expect" "$actual"

actual=`echo 'Ä·ÎÂ'|$PWD/uimsh-tutctool.scm tutchelp`
expect="  |  |  |  |  ||  |     |  |           |  ||
 3| b|  |  |  || 2|     |  |           |  ||
  |  |  | d|  ||  |     |  |a(ÎÂ¢¥ÌÚÅá)|  ||
  |  |  |  | e||  |1(Ä·)| f|           |  ||"
testsame "$expect" "$actual"
actual=`echo 'Ä·ÎÂ'|$PWD/uimsh-tutctool.scm h`
testsame "$expect" "$actual"
actual=`$PWD/uimsh-tutctool.scm tutchelp 'Ä·ÎÂ'`
testsame "$expect" "$actual"

if [ ! -e tutchelp ]; then
	ln -s uimsh-tutctool.scm tutchelp
fi
actual=`echo 'Ä·ÎÂ'|$PWD/tutchelp`
testsame "$expect" "$actual"
actual=`$PWD/tutchelp 'Ä·ÎÂ'`
testsame "$expect" "$actual"

actual=`echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji`
testsame "Ãæ¸Å" "$actual"

actual=`echo 'aljdljdjru fjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji`
testsame "ÅÜŞ¹¤Î¿ÊÄ½" "$actual"

if [ ! -e seq2kanji ]; then
	ln -s uimsh-tutctool.scm seq2kanji
fi
actual=`echo 'jsnf'|$PWD/seq2kanji`
testsame "·î¸÷" "$actual"

actual=`$PWD/uimsh-tutctool.scm seq2kanji 'if.g' 'aljdljdjru fjxiala/.;f'`
expect='Ãæ¸Å
ÅÜŞ¹¤Î¿ÊÄ½'
testsame "$expect" "$actual"
actual=`$PWD/uimsh-tutctool.scm s 'if.g' 'aljdljdjru fjxiala/.;f'`
testsame "$expect" "$actual"
actual=`$PWD/seq2kanji 'if.g' 'aljdljdjru fjxiala/.;f'`
testsame "$expect" "$actual"

actual=`echo 'ÅÅÃÏµë·îÊ¬Æ°ÅÄ¿·Æ± ' | $PWD/uimsh-tutctool.scm kanji2seq \
| cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji`
testsame "¤¦¤«¤â¤·¤ì¤Ş¤»¤ó¡£" "$actual"

if [ ! -e kanji2seq ]; then
	ln -s uimsh-tutctool.scm kanji2seq
fi
actual=`echo 'ÅÅÃÏµë·îÊ¬Æ°ÅÄ¿·Æ± ' | $PWD/kanji2seq \
| cut -b 2- | $PWD/seq2kanji`
testsame "¤¦¤«¤â¤·¤ì¤Ş¤»¤ó¡£" "$actual"

actual=`$PWD/uimsh-tutctool.scm kanji2seq 'ÅÅÃÏµë·îÊ¬Æ°ÅÄ¿·Æ± '`
testsame "jruekwjsighwkshflf " "$actual"
actual=`$PWD/uimsh-tutctool.scm k 'ÅÅÃÏµë·îÊ¬Æ°ÅÄ¿·Æ± '`
testsame "jruekwjsighwkshflf " "$actual"
actual=`$PWD/kanji2seq 'ÅÅÃÏµë·îÊ¬Æ°ÅÄ¿·Æ± '`
testsame "jruekwjsighwkshflf " "$actual"

actual=`echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm kcodeucs`
testsame "¢¤" "$actual"
actual=`echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm u`
testsame "¢¤" "$actual"

if [ ! -e kcodeucs ]; then
	ln -s uimsh-tutctool.scm kcodeucs
fi
actual=`echo U+25b3 | $PWD/kcodeucs`
testsame "¢¤" "$actual"

actual=`uim-sh $PWD/uimsh-tutctool.scm kcodeucs U+25b3`
testsame "¢¤" "$actual"
actual=`uim-sh $PWD/kcodeucs U+25b3`
testsame "¢¤" "$actual"
