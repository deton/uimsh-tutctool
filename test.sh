#!/bin/sh
testsame () {
	if [ "$1" = "$2" ]; then
		echo OK
	else
		echo "NG (expected: $1, actual: $2)"
	fi
}

actual=`echo '����' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "��" "$actual"

ln -s uimsh-tutctool.scm bushuconv
actual=`echo '����' | $PWD/bushuconv`
testsame "��" "$actual"

actual=`echo '�����ڢ��Ϳ;���' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "��" "$actual"

actual=`echo '����' | $PWD/uimsh-tutctool.scm bushucand`
testsame "��۷����ܸ�������" "$actual"

actual=`echo '���ڥ�' | $PWD/uimsh-tutctool.scm bushucand`
testsame "��˫������" "$actual"

ln -s uimsh-tutctool.scm bushucand
actual=`echo '���ڥ�' | $PWD/bushucand`
testsame "��˫������" "$actual"

actual=`echo 'ķ��'|$PWD/uimsh-tutctool.scm tutchelp`
expect="  |  |  |  |  ||  |     |  |           |  ||
 3| b|  |  |  || 2|     |  |           |  ||
  |  |  | d|  ||  |     |  |a(�¢�����)|  ||
  |  |  |  | e||  |1(ķ)| f|           |  ||"
testsame "$expect" "$actual"

ln -s uimsh-tutctool.scm tutchelp
actual=`echo 'ķ��'|$PWD/tutchelp`
testsame "$expect" "$actual"

actual=`echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji`
testsame "���" "$actual"

actual=`echo 'aljdljdjru fjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji`
testsame "��޹�ο�Ľ" "$actual"

ln -s uimsh-tutctool.scm seq2kanji
actual=`echo 'if.g'|$PWD/seq2kanji`
testsame "���" "$actual"

actual=`echo '���ϵ��ʬư�Ŀ�Ʊ ' | $PWD/uimsh-tutctool.scm kanji2seq \
| cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji`
testsame "�����⤷��ޤ���" "$actual"

ln -s uimsh-tutctool.scm kanji2seq
actual=`echo '���ϵ��ʬư�Ŀ�Ʊ ' | $PWD/kanji2seq \
| cut -b 2- | $PWD/seq2kanji`
testsame "�����⤷��ޤ���" "$actual"

actual=`echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm kcodeucs`
testsame "��" "$actual"

ln -s uimsh-tutctool.scm kcodeucs
actual=`echo U+25b3 | $PWD/kcodeucs`
testsame "��" "$actual"
