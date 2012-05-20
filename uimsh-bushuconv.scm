;;; uimsh-bushuconv: ��������Ѵ���Ԥ����ޥ�ɥ饤��ġ��롣
;;; ɸ�����ϤγƹԤ��Ȥ���������Ѵ���Ԥ��ޤ���
;;; (��������Ѵ�������������硢���ιԤΰʹߤ�ʸ����̵�뤷�ޤ���)
;;; �����ϴ��������ɤ�EUC-JP��
;;;
;;; �¹���:
;;; $ echo '����' | uim-sh $PWD/uimsh-bushuconv.scm
;;; ��
(require "tutcode.scm")
(define (main args)
  (let loop ((line (read-line)))
    (and
      line
      (not (eof-object? line))
      (let ((res (tutcode-bushu-convert-on-list
                  (cons "��" (reverse (string-to-list line))) '())))
        (display
          (if (string? res)
            (format "~a~%" res)
            (format "failed bushu conversion for '~a': ~a~%"
              line (reverse res))))
        (loop (read-line))))))
