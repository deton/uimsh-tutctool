;;; * uimsh-tutctool: uim-tutcode$B$r;H$C$?%3%^%s%I%i%$%s%D!<%k!#(B
;;; $BI8=`F~NO$N3F9T$4$H$K=hM}$r<B9T!#F~=PNO4A;z%3!<%I$O(BEUC-JP$B!#(B
;;; $BBh(B1$B0z?t$G=hM}FbMF$r;XDj!#(B
;;;   $B=hM}FbMF(B:
;;;     help: uim-tutcode$B$G$NJ8;z$NBG$AJ}$N%X%k%W$rI=<(!#(B
;;;     kanji2seq: $B4A;z$r(Buim-tutcode$B%-!<%7!<%1%s%9$KJQ49!#(B
;;;     seq2kanji: uim-tutcode$B%-!<%7!<%1%s%9$r4A;z$KJQ49!#(B
;;;
;;; * help$B$N<B9TNc(B:
;;; $ echo '$BD7NB(B'|uim-sh $PWD/uimsh-tutctool.scm help
;;;   |  |  |  |  ||  |     |  |           |  ||
;;;  3| b|  |  |  || 2|     |  |           |  ||
;;;   |  |  | d|  ||  |     |  |a($BNB"%LZEa(B)|  ||
;;;   |  |  |  | e||  |1($BD7(B)| f|           |  ||
;;;
;;; * seq2kanji$B$N<B9TNc(B:
;;; $ echo 'if.g'|uim-sh $PWD/uimsh-tutctool.scm seq2kanji
;;; $BCf8E(B
;;;
;;; * kanji2seq$B$N<B9TNc(B
;;;   ($B%7!<%1%s%9$,$:$l$F0UL#ITL@$J4A;zJ8;zNs$K$J$C$?$b$N$r=$I|(B):
;;; $ echo '$BEECO5k7nJ,F0ED?7F1(B ' | uim-sh $PWD/uimsh-tutctool.scm kanji2seq \
;;; | cut -b 2- | uim-sh $PWD/uimsh-tutctool.scm seq2kanji
;;; $B$&$+$b$7$l$^$;$s!#(B
(require-extension (srfi 8))
(require "tutcode.scm")
(define (main args)
  (define (setup-im-stub)
    (let ((uc (context-new #f #f '() #f #f)))
      (context-set-uc! uc uc)
      (set! im-retrieve-context (lambda (uc) uc))
      (set! im-set-encoding (lambda (uc enc) #f))
      (set! im-convertible? (lambda (uc im-encoding) #t))
      (set! im-commit
        (lambda (uc str)
          (display str)
          #f))
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
      (cmd-setup cmd-exec) ; ($B:G=i$K(B1$B2s$N$_<B9T$9$k4X?t(B $B3F9T$4$H$K<B9T$9$k4X?t(B)
      (case (string->symbol cmd)
        ((help)
          (values
            (lambda (tc)
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
                (format "~a~%"
                  (string-list-concat
                    (tutcode-kanji-list->sequence tc (string-to-list str))))))))
        ((seq2kanji)
          (values
            (lambda (tc) #f)
            (lambda (tc str)
              (display
                (format "~a~%"
                  (string-list-concat
                    (tutcode-sequence->kanji-list tc (string-to-list str))))))))
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
