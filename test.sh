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

if [ ! -e bushuconv ]; then
	ln -s uimsh-tutctool.scm bushuconv
fi
actual=`echo '����' | $PWD/bushuconv`
testsame "��" "$actual"

actual=`echo '�����ڢ��Ϳ;���' | $PWD/uimsh-tutctool.scm bushuconv`
testsame "��" "$actual"

actual=`$PWD/uimsh-tutctool.scm bushuconv '����' '�����ڢ��Ϳ;���'`
expect='��
��'
testsame "$expect" "$actual"
actual=`$PWD/bushuconv '����' '�����ڢ��Ϳ;���'`
testsame "$expect" "$actual"

actual=`echo '����' | $PWD/uimsh-tutctool.scm bushucand`
testsame "��۷����ܸ�������" "$actual"

actual=`echo '���ڥ�' | $PWD/uimsh-tutctool.scm bushucand`
testsame "��˫������" "$actual"

if [ ! -e bushucand ]; then
	ln -s uimsh-tutctool.scm bushucand
fi
actual=`echo '���ڥ�' | $PWD/bushucand`
testsame "��˫������" "$actual"

actual=`$PWD/uimsh-tutctool.scm bushucand '����' '���ڥ�'`
expect='��۷����ܸ�������
��˫������'
testsame "$expect" "$actual"
actual=`$PWD/bushucand '����' '���ڥ�'`
testsame "$expect" "$actual"

actual=`echo 'ķ��'|$PWD/uimsh-tutctool.scm tutchelp`
expect="  |  |  |  |  ||  |     |  |           |  ||
 3| b|  |  |  || 2|     |  |           |  ||
  |  |  | d|  ||  |     |  |a(�¢�����)|  ||
  |  |  |  | e||  |1(ķ)| f|           |  ||"
testsame "$expect" "$actual"
actual=`$PWD/uimsh-tutctool.scm tutchelp 'ķ��'`
testsame "$expect" "$actual"

if [ ! -e tutchelp ]; then
	ln -s uimsh-tutctool.scm tutchelp
fi
actual=`echo 'ķ��'|$PWD/tutchelp`
testsame "$expect" "$actual"
actual=`$PWD/tutchelp 'ķ��'`
testsame "$expect" "$actual"

actual=`echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji`
testsame "���" "$actual"

actual=`echo 'aljdljdjru fjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji`
testsame "��޹�ο�Ľ" "$actual"

if [ ! -e seq2kanji ]; then
	ln -s uimsh-tutctool.scm seq2kanji
fi
actual=`echo 'if.g'|$PWD/seq2kanji`
testsame "���" "$actual"

actual=`$PWD/uimsh-tutctool.scm seq2kanji 'if.g' 'aljdljdjru fjxiala/.;f'`
expect='���
��޹�ο�Ľ'
testsame "$expect" "$actual"
actual=`$PWD/seq2kanji 'if.g' 'aljdljdjru fjxiala/.;f'`
testsame "$expect" "$actual"

actual=`echo '���ϵ��ʬư�Ŀ�Ʊ ' | $PWD/uimsh-tutctool.scm kanji2seq \
| cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji`
testsame "�����⤷��ޤ���" "$actual"

if [ ! -e kanji2seq ]; then
	ln -s uimsh-tutctool.scm kanji2seq
fi
actual=`echo '���ϵ��ʬư�Ŀ�Ʊ ' | $PWD/kanji2seq \
| cut -b 2- | $PWD/seq2kanji`
testsame "�����⤷��ޤ���" "$actual"

actual=`$PWD/uimsh-tutctool.scm kanji2seq '���ϵ��ʬư�Ŀ�Ʊ '`
testsame "jruekwjsighwkshflf " "$actual"
actual=`$PWD/kanji2seq '���ϵ��ʬư�Ŀ�Ʊ '`
testsame "jruekwjsighwkshflf " "$actual"

actual=`echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm kcodeucs`
testsame "��" "$actual"

if [ ! -e kcodeucs ]; then
	ln -s uimsh-tutctool.scm kcodeucs
fi
actual=`echo U+25b3 | $PWD/kcodeucs`
testsame "��" "$actual"

actual=`uim-sh $PWD/uimsh-tutctool.scm kcodeucs U+25b3`
testsame "��" "$actual"
actual=`uim-sh $PWD/kcodeucs U+25b3`
testsame "��" "$actual"
