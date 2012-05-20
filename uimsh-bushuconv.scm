;;; uimsh-bushuconv: 部首合成変換を行うコマンドラインツール。
;;; 標準入力の各行ごとに部首合成変換を行います。
;;; (部首合成変換に成功した場合、その行の以降の文字は無視します。)
;;; 入出力漢字コードはEUC-JP。
;;;
;;; 実行例:
;;; $ echo '木刀' | uim-sh $PWD/uimsh-bushuconv.scm
;;; 梁
(require "tutcode.scm")
(define (main args)
  (let loop ((line (read-line)))
    (and
      line
      (not (eof-object? line))
      (let ((res (tutcode-bushu-convert-on-list
                  (cons "▲" (reverse (string-to-list line))) '())))
        (display
          (if (string? res)
            (format "~a~%" res)
            (format "failed bushu conversion for '~a': ~a~%"
              line (reverse res))))
        (loop (read-line))))))
