;;; uimsh-bushucand: 部首合成変換候補を表示するコマンドラインツール。
;;; 標準入力の各行ごとに部首合成変換候補を表示します。
;;; 入出力漢字コードはEUC-JP。
;;;
;;; 実行例:
;;; $ echo '木刀' | uim-sh $PWD/uimsh-bushucand.scm
;;; 梁朷枌梛楔粱枴牀簗
;;;
;;; uim-tutcodeの対話的な部首合成変換機能を使って候補を作っているので、
;;; bushu.index2とbushu.expandファイル(tc-2.3.1のインストール時に
;;; 生成・インストールされる)を用意して、各ファイルの場所をuim-prefで
;;; 設定しておく必要があります。
;;;
;;; 部首合成変換用ユーザ辞書に相当するbushu.helpファイルが設定されていれば、
;;; bushu.helpファイルを優先して検索します。
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
