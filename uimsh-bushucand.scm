;;; uimsh-bushucand: ��������Ѵ������ɽ�����륳�ޥ�ɥ饤��ġ��롣
;;; ɸ�����ϤγƹԤ��Ȥ���������Ѵ������ɽ�����ޤ���
;;; �����ϴ��������ɤ�EUC-JP��
;;;
;;; �¹���:
;;; $ echo '����' | uim-sh $PWD/uimsh-bushucand.scm
;;; ��۷����ܸ�������
;;;
;;; uim-tutcode������Ū����������Ѵ���ǽ��ȤäƸ�����äƤ���Τǡ�
;;; bushu.index2��bushu.expand�ե�����(tc-2.3.1�Υ��󥹥ȡ������
;;; ���������󥹥ȡ��뤵���)���Ѱդ��ơ��ƥե�����ξ���uim-pref��
;;; ���ꤷ�Ƥ���ɬ�פ�����ޤ���
;;;
;;; ��������Ѵ��ѥ桼���������������bushu.help�ե����뤬���ꤵ��Ƥ���С�
;;; bushu.help�ե������ͥ�褷�Ƹ������ޤ���
(require "tutcode.scm")
(define (main args)
  (let loop ((line (read-line)))
    (and
      line
      (not (eof-object? line))
      (begin
        (display
          (format "~a~%"
            (apply string-append
              (tutcode-bushu-compose-interactively
                (reverse (string-to-list line))))))
        (loop (read-line))))))
