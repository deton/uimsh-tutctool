#! /usr/bin/env uim-sh
;;; * uimsh-tutctool: uim-tutcodeを使ったコマンドラインツール。
;;; 第1引数のコマンド種別(以下の7種類。かっこ内は短縮コマンド名)で
;;; 処理内容を指定。
;;; (uimsh-tutctool.scmのファイル名をコマンド種別名(seq2kanji等)にしておけば
;;; (例:`ln -s uimsh-tutctool.scm seq2kanji`)、第1引数は省略可能)
;;;     bushuconv (b): 部首合成変換
;;;     bushucand (c): 部首合成変換候補を表示
;;;     tutchelp (h): uim-tutcodeでの文字の打ち方のヘルプを表示
;;;     kanji2seq (k): 漢字をuim-tutcodeキーシーケンスに変換
;;;     seq2kanji (s): uim-tutcodeキーシーケンスを漢字に変換
;;;     kcodeucs (u): Unicodeコードポイント(U+XXXX)に対応するEUC-JP文字を出力
;;;     kuten (t): 区点番号に対応するEUC-JP文字を出力
;;; コマンド種別より後に引数が有る場合は、各引数に対して、
;;; コマンド種別によって指定された処理を実行。
;;; 無い場合は、標準入力の各行ごとに処理を実行。
;;; 入出力漢字コードはEUC-JP。
;;;
;;; * bushuconv: 部首合成変換 (入力:部首合成シーケンス、出力:合成される漢字)
;;;   bushuconvは、部首合成変換に成功した場合、その行の以降の文字は無視します。
;;; $ echo '木刀' | $PWD/uimsh-tutctool.scm bushuconv
;;; 梁
;;; $ echo '▲▲木▲人人条夫' | $PWD/uimsh-tutctool.scm bushuconv
;;; 麩
;;;
;;; * bushucand: 部首合成変換候補を表示
;;;   (入力:部首リスト、出力:合成される漢字の候補)
;;; $ echo '木刀' | $PWD/uimsh-tutctool.scm bushucand
;;; 梁朷枌梛楔粱枴牀簗
;;; $ echo '口木イ' | $PWD/uimsh-tutctool.scm bushucand
;;; 保褒堡葆褓
;;;
;;;   bushucandは、uim-tutcodeの対話的な部首合成変換機能を使って候補を作って
;;;   いるので、以下のファイルの場所をuim-prefで設定しておく必要があります。
;;;   - bushu.helpファイル(部首合成変換用ユーザ辞書に相当)
;;;     bushu.helpファイルを優先して検索します。
;;;   - bushu.index2とbushu.expandファイル
;;;     (tc-2.3.1のインストール時に生成・インストールされるファイル)
;;;
;;; * tutchelp: uim-tutcodeでの文字の打ち方のヘルプを表示
;;;   (入力:漢字リスト、出力:uim-tutcodeでの打ち方ヘルプ)
;;; $ echo '跳梁'|$PWD/uimsh-tutctool.scm tutchelp
;;;   |  |  |  |  ||  |     |  |           |  ||
;;;  3| b|  |  |  || 2|     |  |           |  ||
;;;   |  |  | d|  ||  |     |  |a(梁▲木刀)|  ||
;;;   |  |  |  | e||  |1(跳)| f|           |  ||
;;;
;;; * seq2kanji: uim-tutcodeキーシーケンスを漢字に変換
;;;   (入力:uim-tutcodeキーシーケンス、出力:漢字文字列)
;;; $ echo 'if.g'|$PWD/uimsh-tutctool.scm seq2kanji
;;; 中古
;;;
;;; 交ぜ書き変換や部首合成変換も使用可能。
;;; 交ぜ書き変換で「どとう」を変換(△どとう{変換キー(スペース)}{確定キー(^M)})
;;; して、部首合成変換で「捗」を変換(▲才歩)する例:
;;; $ echo 'aljdljdjru ^Mfjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji
;;; 怒濤の進捗
;;;
;;; * kanji2seq: 漢字をuim-tutcodeキーシーケンスに変換
;;;   (入力:漢字文字列、出力:uim-tutcodeキーシーケンス)
;;; シーケンスがずれて意味不明な漢字文字列になったものを修復する例:
;;; $ echo '電地給月分動田新同 ' | $PWD/uimsh-tutctool.scm kanji2seq \
;;; | cut -b 2- | $PWD/uimsh-tutctool.scm seq2kanji
;;; うかもしれません。
;;;
;;; * kcodeucs: Unicodeコードポイント(U+XXXX)に対応するEUC-JP文字を出力
;;;   (入力:Unicodeコードポイント(U+XXXX)、出力:EUC-JP文字)
;;; $ echo U+25b3 | $PWD/uimsh-tutctool.scm kcodeucs
;;; △
;;;
;;; * kuten: 区点番号に対応するEUC-JP文字を出力
;;;   (入力:-で区切った、面-区-点番号(面区点それぞれ10進数)、出力:EUC-JP文字)
;;; 1面の場合、面-は省略可能。(例:1-48-13または48-13)
;;; $ echo 1-48-13 | $PWD/uimsh-tutctool.scm kuten
;;; 亅
;;;;
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
(require-extension (srfi 1))
(require "tutcode.scm")
(define (main args)
  (define (setup-im-stub)
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
    (set! im-switch-system-global-im (lambda (uc name) #t)))
  (define (setup-stub-context lang name)
    (let ((uc (context-new #f #f '() #f #f)))
      (context-set-uc! uc uc)
      (let ((c (create-context uc lang name)))
        (setup-context c)
        c)))
  (define cmd-alist
    `((("tutchelp" "h")
        ,(lambda ()
          (set! im-commit (lambda (uc str) (display str)))
          (set! tutcode-use-auto-help-window? #t)
          (setup-stub-context "ja" 'tutcode))
        ,(lambda (tc str)
          (tutcode-context-set-auto-help! tc '())
          (tutcode-reset-candidate-window tc)
          (tutcode-check-auto-help-window-begin tc
            (string-to-list str) '() #t)
          (if (pair? (tutcode-context-auto-help tc))
            (tutcode-auto-help-dump 'tutcode-state-on tc)
            (display (format "no help for '~a'~%" str)))))
      (("kanji2seq" "k")
        ,(lambda ()
          (set! tutcode-verbose-stroke-key? (lambda (key key-state) #f))
          (setup-stub-context "ja" 'tutcode))
        ,(lambda (tc str)
          (display
            (string-list-concat
              (tutcode-kanji-list->sequence tc (string-to-list str))))
          (newline)))
      (("seq2kanji" "s")
        ,(lambda ()
          (setup-stub-context "ja" 'tutcode))
        ,(lambda (tc str)
          (display
            (string-list-concat
              (tutcode-sequence->kanji-list tc (string-to-list str))))
          (newline)))
      (("bushuconv" "b")
        ,(lambda () #f)
        ,(lambda (tc str)
          (let ((res (tutcode-bushu-convert-on-list
                      (cons "▲" (reverse (string-to-list str))) '())))
            (display
              (if (string? res)
                (format "~a~%" res)
                (format "failed bushu conversion for '~a': ~a~%"
                  str (reverse res)))))))
      (("bushucand" "c")
        ,(lambda () #f)
        ,(lambda (tc str)
          (display
            (apply string-append
              (tutcode-bushu-compose-interactively
                (reverse (string-to-list str)))))
          (newline)))
      (("kcodeucs" "u")
        ,(lambda () #f)
        ,(lambda (tc str)
          (display (ja-kanji-code-input-ucs (string-to-list str)))
          (newline)))
      (("kuten" "t")
        ,(lambda () #f)
        ,(lambda (tc str)
          (display (ja-kanji-code-input-kuten (string-to-list str)))
          (newline)))))
  (define (usage mybasename)
    (display
      (format "Usage: ~a <~a> [str]...~%" mybasename
        (apply string-append
          (cdr
            (append-map
              (lambda (x)
                (list "|" (caar x)))
              cmd-alist))))))
  (setup-im-stub)
  (let*
    ((mybasename (last (string-split (list-ref args 0) "/")))
     (cmd0 (assoc mybasename cmd-alist member))
     (cmd (or cmd0
              (and (< 1 (length args))
                   (assoc (list-ref args 1) cmd-alist member)))))
    (if (not cmd)
      (usage mybasename)
      (let ((tc ((list-ref cmd 1))) ; setup関数の戻り値がcontext
            (cmd-action (list-ref cmd 2)) ; 各行ごとに実行する関数
            (rest (if cmd0 (cdr args) (cddr args))))
        (if (pair? rest)
          (let loop ((rest rest))
            (if (pair? rest)
              (begin
                (cmd-action tc (car rest))
                (loop (cdr rest)))))
          (let loop ((line (read-line)))
            (and
              line
              (not (eof-object? line))
              (begin
                (cmd-action tc line)
                (loop (read-line))))))))))
