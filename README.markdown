uimsh-tutctool
==============

uimsh-tutctoolはuim-tutcodeを使ったコマンドラインツールです。

標準入力の各行ごとに処理を実行。入出力漢字コードはEUC-JP。
第1引数で処理内容を指定。

  * bushuconv: 部首合成変換
  * bushucand: 部首合成変換候補を表示
  * tutchelp: uim-tutcodeでの文字の打ち方のヘルプを表示
  * kanji2seq: 漢字をuim-tutcodeキーシーケンスに変換
  * seq2kanji: uim-tutcodeキーシーケンスを漢字に変換
  * kcodeucs: Unicodeコードポイント(U+XXXX)に対応するEUC-JP文字を出力

bushuconv: 部首合成変換
-----------------------

    $ echo '木刀' | uim-sh $PWD/uimsh-tutctool.scm bushuconv
    梁
    $ echo '▲▲木▲人人条夫' | uim-sh $PWD/uimsh-tutctool.scm bushuconv
    麩

bushuconvは、部首合成変換に成功した場合、その行の以降の文字は無視します。

bushucand: 部首合成変換候補を表示
---------------------------------

    $ echo '木刀' | uim-sh $PWD/uimsh-tutctool.scm bushucand
    梁朷枌梛楔粱枴牀簗
    $ echo '口木イ' | uim-sh $PWD/uimsh-tutctool.scm bushucand
    保褒堡葆褓

bushucandは、uim-tutcodeの対話的な部首合成変換機能を使って候補を作って
いるので、以下のファイルの場所をuim-prefで設定しておく必要があります。

- bushu.helpファイル(部首合成変換用ユーザ辞書に相当)。
  bushu.helpファイルを優先して検索します。
- [bushu.index2とbushu.expandファイル](http://www1.interq.or.jp/~deton/tutcode/#bushudic)
  (tc-2.3.1のインストール時に生成・インストールされるファイル)

tutchelp: uim-tutcodeでの文字の打ち方のヘルプを表示
---------------------------------------------------

    $ echo '跳梁'|uim-sh $PWD/uimsh-tutctool.scm tutchelp
      |  |  |  |  ||  |     |  |           |  ||
     3| b|  |  |  || 2|     |  |           |  ||
      |  |  | d|  ||  |     |  |a(梁▲木刀)|  ||
      |  |  |  | e||  |1(跳)| f|           |  ||

seq2kanji: uim-tutcodeキーシーケンスを漢字に変換
------------------------------------------------

    $ echo 'if.g'|uim-sh $PWD/uimsh-tutctool.scm seq2kanji
    中古

交ぜ書き変換や部首合成変換も使用可能。
交ぜ書き変換で「どとう」を変換(△どとう{変換キー(スペース)}{確定キー(^M)})
して、部首合成変換で「捗」を変換(▲才歩)する例:

    $ echo 'aljdljdjru ^Mfjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji
    怒濤の進捗

kanji2seq: 漢字をuim-tutcodeキーシーケンスに変換
------------------------------------------------

シーケンスがずれて意味不明な漢字文字列になったものを修復する例:

    $ echo '電地給月分動田新同 ' | uim-sh $PWD/uimsh-tutctool.scm kanji2seq \
    | cut -b 2- | uim-sh $PWD/uimsh-tutctool.scm seq2kanji
    うかもしれません。

kcodeucs: Unicodeコードポイント(U+XXXX)に対応するEUC-JP文字を出力
-----------------------------------------------------------------

    $ echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm kcodeucs
    △

関連
====

* uim-fmt-ja https://github.com/deton/uim-fmt-ja
* uim-wordcount https://github.com/deton/uim-wordcount
