;;; uimsh-bushucand: 部首合成変換候補を表示するコマンドラインツール。
;;; 標準入力の各行ごとに部首合成変換候補を表示します。
;;; 入出力漢字コードはEUC-JP。
;;;
;;; 実行例:
;;; $ echo '木刀' | uim-sh $PWD/uimsh-bushucand.scm
;;; 梁朷枌梛楔粱枴牀簗
;;;
;;; uim-tutcodeの対話的な部首合成変換機能を使って候補を作っているので、
;;; 以下のファイルの場所をuim-prefで設定しておく必要があります。
;;; - bushu.helpファイル(部首合成変換用ユーザ辞書に相当)
;;;   bushu.helpファイルを優先して検索します。
;;; - bushu.index2とbushu.expandファイル
;;;   (tc-2.3.1のインストール時に生成・インストールされるファイル)
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
