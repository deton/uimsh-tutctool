;;; * uimsh-tutctool: uim-tutcode��Ȥä����ޥ�ɥ饤��ġ��롣
;;; ɸ�����ϤγƹԤ��Ȥ˽�����¹ԡ������ϴ��������ɤ�EUC-JP��
;;; ��1�����ǽ������Ƥ���ꡣ
;;;   ��������:
;;;     bushuconv: ��������Ѵ�
;;;     bushucand: ��������Ѵ������ɽ��
;;;     help: uim-tutcode�Ǥ�ʸ�����Ǥ����Υإ�פ�ɽ��
;;;     kanji2seq: ������uim-tutcode�����������󥹤��Ѵ�
;;;     seq2kanji: uim-tutcode�����������󥹤�������Ѵ�
;;;
;;; * bushuconv: ��������Ѵ�
;;;   bushuconv�ϡ���������Ѵ�������������硢���ιԤΰʹߤ�ʸ����̵�뤷�ޤ���
;;; $ echo '����' | uim-sh $PWD/uimsh-tutctool.scm bushuconv
;;; ��
;;; $ echo '�����ڢ��Ϳ;���' | uim-sh $PWD/uimsh-tutctool.scm bushuconv
;;; ��
;;;
;;; * bushucand: ��������Ѵ������ɽ��
;;; $ echo '����' | uim-sh $PWD/uimsh-tutctool.scm bushucand
;;; ��۷����ܸ�������
;;; $ echo '���ڥ�' | uim-sh $PWD/uimsh-tutctool.scm bushucand
;;; ��˫������
;;;
;;;   bushucand�ϡ�uim-tutcode������Ū����������Ѵ���ǽ��ȤäƸ�����ä�
;;;   ����Τǡ��ʲ��Υե�����ξ���uim-pref�����ꤷ�Ƥ���ɬ�פ�����ޤ���
;;;   - bushu.help�ե�����(��������Ѵ��ѥ桼�����������)
;;;     bushu.help�ե������ͥ�褷�Ƹ������ޤ���
;;;   - bushu.index2��bushu.expand�ե�����
;;;     (tc-2.3.1�Υ��󥹥ȡ���������������󥹥ȡ��뤵���ե�����)
;;;
;;; * help: uim-tutcode�Ǥ�ʸ�����Ǥ����Υإ�פ�ɽ��
;;; $ echo 'ķ��'|uim-sh $PWD/uimsh-tutctool.scm help
;;;   |  |  |  |  ||  |     |  |           |  ||
;;;  3| b|  |  |  || 2|     |  |           |  ||
;;;   |  |  | d|  ||  |     |  |a(�¢�����)|  ||
;;;   |  |  |  | e||  |1(ķ)| f|           |  ||
;;;
;;; * seq2kanji: uim-tutcode�����������󥹤�������Ѵ�
;;; $ echo 'if.g'|uim-sh $PWD/uimsh-tutctool.scm seq2kanji
;;; ���
;;;
;;; * kanji2seq: ������uim-tutcode�����������󥹤��Ѵ�
;;; �������󥹤�����ư�̣�����ʴ���ʸ����ˤʤä���Τ���������:
;;; $ echo '���ϵ��ʬư�Ŀ�Ʊ ' | uim-sh $PWD/uimsh-tutctool.scm kanji2seq \
;;; | cut -b 2- | uim-sh $PWD/uimsh-tutctool.scm seq2kanji
;;; �����⤷��ޤ���
(require-extension (srfi 8))
(require "tutcode.scm")
(define (main args)
  (define (setup-im-stub)
    (let ((uc (context-new #f #f '() #f #f)))
      (context-set-uc! uc uc)
      (set! im-retrieve-context (lambda (uc) uc))
      (set! im-set-encoding (lambda (uc enc) #f))
      (set! im-convertible? (lambda (uc im-encoding) #t))
      (set! im-commit (lambda (uc str) #f))
      (set! im-clear-preedit (lambda (uc) #f))
      (set! im-pushback-preedit (lambda (uc attr str) #f))
      (set! im-update-preedit (lambda (uc) #f))
      (set! im-activate-candidate-selector (lambda (uc nr display-limit) #f))
      (set! im-select-candidate (lambda (uc idx) #f))
      (set! im-shift-page-candidate (lambda (uc dir) #f))
      (set! im-deactivate-candidate-selector (lambda (uc) #f))
      (set! im-delay-activate-candidate-selector (lambda (uc delay) #f))
      (set! im-delay-activate-candidate-selector-supported? (lambda (uc) #f))
      (set! im-acquire-text-internal
        (lambda (uc text-id origin former-len latter-len) #f))
      (set! im-delete-text-internal
        (lambda (uc text-id origin former-len latter-len) #f))
      (set! im-clear-mode-list (lambda (uc) #f))
      (set! im-pushback-mode-list (lambda (uc str) #f))
      (set! im-update-mode-list (lambda (uc) #f))
      (set! im-update-mode (lambda (uc mode) #f))
      (set! im-update-prop-list (lambda (uc prop) #f))
      (set! im-raise-configuration-change (lambda (uc) #t))
      (set! im-switch-app-global-im (lambda (uc name) #t))
      (set! im-switch-system-global-im (lambda (uc name) #t))
      uc))
  (define (setup-tutcode-context)
    (let* ((uc (setup-im-stub))
           (tc (create-context uc "ja" "tutcode")))
      (setup-context tc)
      tc))
  (let ((tc (setup-tutcode-context))
        (cmd (list-ref args 1)))
    (receive
      (cmd-setup cmd-exec) ; (�ǽ��1��Τ߼¹Ԥ���ؿ� �ƹԤ��Ȥ˼¹Ԥ���ؿ�)
      (case (string->symbol cmd)
        ((help)
          (values
            (lambda (tc)
              (set! im-commit (lambda (uc str) (display str)))
              (set! tutcode-use-auto-help-window? #t))
            (lambda (tc str)
              (tutcode-context-set-auto-help! tc '())
              (tutcode-reset-candidate-window tc)
              (tutcode-check-auto-help-window-begin tc
                (string-to-list str) '() #t)
              (if (pair? (tutcode-context-auto-help tc))
                (tutcode-auto-help-dump 'tutcode-state-on tc)
                (display (format "no help for '~a'~%" str))))))
        ((kanji2seq)
          (values
            (lambda (tc)
              (set! tutcode-verbose-stroke-key? (lambda (key key-state) #f)))
            (lambda (tc str)
              (display
                (string-list-concat
                  (tutcode-kanji-list->sequence tc (string-to-list str))))
              (newline))))
        ((seq2kanji)
          (values
            (lambda (tc) #f)
            (lambda (tc str)
              (display
                (string-list-concat
                  (tutcode-sequence->kanji-list tc (string-to-list str))))
              (newline))))
        ((bushuconv)
          (values
            (lambda (tc) #f)
            (lambda (tc str)
              (let ((res (tutcode-bushu-convert-on-list
                          (cons "��" (reverse (string-to-list str))) '())))
                (display
                  (if (string? res)
                    (format "~a~%" res)
                    (format "failed bushu conversion for '~a': ~a~%"
                      str (reverse res))))))))
        ((bushucand)
          (values
            (lambda (tc) #f)
            (lambda (tc str)
              (display
                (apply string-append
                  (tutcode-bushu-compose-interactively
                    (reverse (string-to-list str)))))
              (newline))))
        (else
          (raise (list 'unknown-command cmd))))
      (cmd-setup tc)
      (let loop ((line (read-line)))
        (and
          line
          (not (eof-object? line))
          (begin
            (cmd-exec tc line)
            (loop (read-line))))))))
