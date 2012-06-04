#! /usr/bin/env uim-sh
;;; * uimsh-tutctool: uim-tutcode��Ȥä����ޥ�ɥ饤��ġ��롣
;;; ɸ�����ϤγƹԤ��Ȥ˽�����¹ԡ������ϴ��������ɤ�EUC-JP��
;;; ��1�����ǽ������Ƥ���ꡣ
;;;   ��������:
;;;     bushuconv: ��������Ѵ�
;;;     bushucand: ��������Ѵ������ɽ��
;;;     tutchelp: uim-tutcode�Ǥ�ʸ�����Ǥ����Υإ�פ�ɽ��
;;;     kanji2seq: ������uim-tutcode�����������󥹤��Ѵ�
;;;     seq2kanji: uim-tutcode�����������󥹤�������Ѵ�
;;;     kcodeucs: Unicode�����ɥݥ����(U+XXXX)���б�����EUC-JPʸ�������
;;;
;;; * bushuconv: ��������Ѵ�
;;;   bushuconv�ϡ���������Ѵ�������������硢���ιԤΰʹߤ�ʸ����̵�뤷�ޤ���
;;; $ echo '����' | $PWD/uimsh-tutctool.scm bushuconv
;;; ��
;;; $ echo '�����ڢ��Ϳ;���' | $PWD/uimsh-tutctool.scm bushuconv
;;; ��
;;;
;;; * bushucand: ��������Ѵ������ɽ��
;;; $ echo '����' | $PWD/uimsh-tutctool.scm bushucand
;;; ��۷����ܸ�������
;;; $ echo '���ڥ�' | $PWD/uimsh-tutctool.scm bushucand
;;; ��˫������
;;;
;;;   bushucand�ϡ�uim-tutcode������Ū����������Ѵ���ǽ��ȤäƸ�����ä�
;;;   ����Τǡ��ʲ��Υե�����ξ���uim-pref�����ꤷ�Ƥ���ɬ�פ�����ޤ���
;;;   - bushu.help�ե�����(��������Ѵ��ѥ桼�����������)
;;;     bushu.help�ե������ͥ�褷�Ƹ������ޤ���
;;;   - bushu.index2��bushu.expand�ե�����
;;;     (tc-2.3.1�Υ��󥹥ȡ���������������󥹥ȡ��뤵���ե�����)
;;;
;;; * tutchelp: uim-tutcode�Ǥ�ʸ�����Ǥ����Υإ�פ�ɽ��
;;; $ echo 'ķ��'|$PWD/uimsh-tutctool.scm tutchelp
;;;   |  |  |  |  ||  |     |  |           |  ||
;;;  3| b|  |  |  || 2|     |  |           |  ||
;;;   |  |  | d|  ||  |     |  |a(�¢�����)|  ||
;;;   |  |  |  | e||  |1(ķ)| f|           |  ||
;;;
;;; * seq2kanji: uim-tutcode�����������󥹤�������Ѵ�
;;; $ echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji
;;; ���
;;;
;;; * kanji2seq: ������uim-tutcode�����������󥹤��Ѵ�
;;; �������󥹤�����ư�̣�����ʴ���ʸ����ˤʤä���Τ���������:
;;; $ echo '���ϵ��ʬư�Ŀ�Ʊ ' | $PWD/uimsh-tutctool.scm kanji2seq \
;;; | cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji
;;; �����⤷��ޤ���
;;;
;;; * kcodeucs: Unicode�����ɥݥ����(U+XXXX)���б�����EUC-JPʸ�������
;;; $ echo U+25b3 | $PWD/uimsh-tutctool.scm kcodeucs
;;; ��
;;;
;;; Copyright (c) 2012 KIHARA Hideto https://github.com/deton/uimsh-tutctool
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.
;;; 3. Neither the name of authors nor the names of its contributors
;;;    may be used to endorse or promote products derived from this software
;;;    without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.
;;;;
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
  (define (setup-stub-context lang name)
    (let* ((uc (setup-im-stub))
           (c (create-context uc lang name)))
      (setup-context c)
      c))
  (define cmd-alist
    `(("tutchelp"
        ,(lambda (tc)
          (set! im-commit (lambda (uc str) (display str)))
          (set! tutcode-use-auto-help-window? #t))
        ,(lambda (tc str)
          (tutcode-context-set-auto-help! tc '())
          (tutcode-reset-candidate-window tc)
          (tutcode-check-auto-help-window-begin tc
            (string-to-list str) '() #t)
          (if (pair? (tutcode-context-auto-help tc))
            (tutcode-auto-help-dump 'tutcode-state-on tc)
            (display (format "no help for '~a'~%" str)))))
      ("kanji2seq"
        ,(lambda (tc)
          (set! tutcode-verbose-stroke-key? (lambda (key key-state) #f)))
        ,(lambda (tc str)
          (display
            (string-list-concat
              (tutcode-kanji-list->sequence tc (string-to-list str))))
          (newline)))
      ("seq2kanji"
        ,(lambda (tc) #f)
        ,(lambda (tc str)
          (display
            (string-list-concat
              (tutcode-sequence->kanji-list tc (string-to-list str))))
          (newline)))
      ("bushuconv"
        ,(lambda (tc) #f)
        ,(lambda (tc str)
          (let ((res (tutcode-bushu-convert-on-list
                      (cons "��" (reverse (string-to-list str))) '())))
            (display
              (if (string? res)
                (format "~a~%" res)
                (format "failed bushu conversion for '~a': ~a~%"
                  str (reverse res)))))))
      ("bushucand"
        ,(lambda (tc) #f)
        ,(lambda (tc str)
          (display
            (apply string-append
              (tutcode-bushu-compose-interactively
                (reverse (string-to-list str)))))
          (newline)))
      ("kcodeucs"
        ,(lambda (tc) #f)
        ,(lambda (tc str)
          (display (ja-kanji-code-input-ucs (string-to-list str)))
          (newline)))))
  (let*
    ((mybasename (last (string-split (list-ref args 0) "/")))
     (cmds (or (assoc mybasename cmd-alist)
               (and (< 1 (length args))
                    (assoc (list-ref args 1) cmd-alist)))))
    (if (not cmds)
      (display (format "Usage: ~a ~a~%" mybasename (map car cmd-alist)))
      (let ((cmd-setup (list-ref cmds 1)) ; �ǽ��1��Τ߼¹Ԥ���ؿ�
            (cmd-action (list-ref cmds 2)) ; �ƹԤ��Ȥ˼¹Ԥ���ؿ�
            (tc (setup-stub-context "ja" "tutcode")))
        (cmd-setup tc)
        (let loop ((line (read-line)))
          (and
            line
            (not (eof-object? line))
            (begin
              (cmd-action tc line)
              (loop (read-line)))))))))
