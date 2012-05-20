;;; * uimsh-tutctool: uim-tutcodeを使ったコマンドラインツール。
;;; 標準入力の各行ごとに処理を実行。入出力漢字コードはEUC-JP。
;;; 第1引数で処理内容を指定。
;;;   処理内容:
;;;     bushuconv: 部首合成変換
;;;     bushucand: 部首合成変換候補を表示
;;;     help: uim-tutcodeでの文字の打ち方のヘルプを表示
;;;     kanji2seq: 漢字をuim-tutcodeキーシーケンスに変換
;;;     seq2kanji: uim-tutcodeキーシーケンスを漢字に変換
;;;
;;; * bushuconv: 部首合成変換
;;;   bushuconvは、部首合成変換に成功した場合、その行の以降の文字は無視します。
;;; $ echo '木刀' | uim-sh $PWD/uimsh-tutctool.scm bushuconv
;;; 梁
;;; $ echo '▲▲木▲人人条夫' | uim-sh $PWD/uimsh-tutctool.scm bushuconv
;;; 麩
;;;
;;; * bushucand: 部首合成変換候補を表示
;;; $ echo '木刀' | uim-sh $PWD/uimsh-tutctool.scm bushucand
;;; 梁朷枌梛楔粱枴牀簗
;;; $ echo '口木イ' | uim-sh $PWD/uimsh-tutctool.scm bushucand
;;; 保褒堡葆褓
;;;
;;;   bushucandは、uim-tutcodeの対話的な部首合成変換機能を使って候補を作って
;;;   いるので、以下のファイルの場所をuim-prefで設定しておく必要があります。
;;;   - bushu.helpファイル(部首合成変換用ユーザ辞書に相当)
;;;     bushu.helpファイルを優先して検索します。
;;;   - bushu.index2とbushu.expandファイル
;;;     (tc-2.3.1のインストール時に生成・インストールされるファイル)
;;;
;;; * help: uim-tutcodeでの文字の打ち方のヘルプを表示
;;; $ echo '跳梁'|uim-sh $PWD/uimsh-tutctool.scm help
;;;   |  |  |  |  ||  |     |  |           |  ||
;;;  3| b|  |  |  || 2|     |  |           |  ||
;;;   |  |  | d|  ||  |     |  |a(梁▲木刀)|  ||
;;;   |  |  |  | e||  |1(跳)| f|           |  ||
;;;
;;; * seq2kanji: uim-tutcodeキーシーケンスを漢字に変換
;;; $ echo 'if.g'|uim-sh $PWD/uimsh-tutctool.scm seq2kanji
;;; 中古
;;;
;;; * kanji2seq: 漢字をuim-tutcodeキーシーケンスに変換
;;; シーケンスがずれて意味不明な漢字文字列になったものを修復する例:
;;; $ echo '電地給月分動田新同 ' | uim-sh $PWD/uimsh-tutctool.scm kanji2seq \
;;; | cut -b 2- | uim-sh $PWD/uimsh-tutctool.scm seq2kanji
;;; うかもしれません。
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
      (cmd-setup cmd-exec) ; (最初に1回のみ実行する関数 各行ごとに実行する関数)
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
        ((bushuconv)
          (values
            (lambda (tc) #f)
            (lambda (tc str)
              (let ((res (tutcode-bushu-convert-on-list
                          (cons "▲" (reverse (string-to-list str))) '())))
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
                (format "~a~%"
                  (apply string-append
                    (tutcode-bushu-compose-interactively
                      (reverse (string-to-list str)))))))))
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
