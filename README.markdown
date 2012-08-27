uimsh-tutctool
==============

uimsh-tutctoolは、
[uim-tutcode](http://code.google.com/p/uim-doc-ja/wiki/UimTutcode)
を使ったコマンドラインツールです。

第1引数のコマンド種別(以下の7種類。かっこ内は短縮コマンド名)で
処理内容を指定してください。
(uimsh-tutctool.scmのファイル名をコマンド種別名(seq2kanji等)にしておけば
(例:`ln -s uimsh-tutctool.scm seq2kanji`)、第1引数は省略可能)

  * bushuconv (b): 部首合成変換
  * bushucand (c): 部首合成変換候補を表示
  * tutchelp (h): uim-tutcodeでの文字の打ち方のヘルプを表示
  * kanji2seq (k): 漢字をuim-tutcodeキーシーケンスに変換
  * seq2kanji (s): uim-tutcodeキーシーケンスを漢字に変換
  * kcodeucs (u): Unicodeコードポイント(U+XXXX)に対応するEUC-JP文字を出力
  * kuten (t): 区点番号に対応するEUC-JP文字を出力

コマンド種別より後に引数が有る場合は、各引数に対して、
コマンド種別によって指定された処理を実行します。
無い場合は、標準入力の各行ごとに処理を実行します。

入出力漢字コードはEUC-JP。
なお、入力漢字コードがEUC-JPでない場合(UTF-8等)、以下のエラーが出ます。

    Error: scm_charcodec_read_char: invalid char sequence

この場合は、以下の例のように、
nkf -eやlv -Oejやiconv -t euc-jp等でEUC-JPに変換した文字列を、
uimsh-tutctoolに渡してください。

    $ tail -1 readme.utf-8 | nkf -e | $PWD/uimsh-tutctool.scm kanji2seq

bushuconv: 部首合成変換
-----------------------
* 入力: 部首合成シーケンス
* 出力: 合成される漢字

実行例:

    $ echo '木刀' | uim-sh $PWD/uimsh-tutctool.scm bushuconv
    梁
    $ echo '▲▲木▲人人条夫' | $PWD/uimsh-tutctool.scm bushuconv
    麩

bushuconvは、部首合成変換に成功した場合、その行の以降の文字は無視します。

bushucand: 部首合成変換候補を表示
---------------------------------
* 入力: 部首リスト
* 出力: 合成される漢字の候補

実行例:

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
* 入力: 漢字リスト
* 出力: uim-tutcodeでの打ち方ヘルプ

実行例:

    $ echo '跳梁'|uim-sh $PWD/uimsh-tutctool.scm tutchelp
      |  |  |  |  ||  |     |  |           |  ||
     3| b|  |  |  || 2|     |  |           |  ||
      |  |  | d|  ||  |     |  |a(梁▲木刀)|  ||
      |  |  |  | e||  |1(跳)| f|           |  ||

seq2kanji: uim-tutcodeキーシーケンスを漢字に変換
------------------------------------------------
* 入力: uim-tutcodeキーシーケンス
* 出力: 漢字文字列

実行例:

    $ echo 'jsnf'|uim-sh $PWD/uimsh-tutctool.scm seq2kanji
    月光
    $ grep `seq2kanji jsnf` ~/data/audio/sacd

交ぜ書き変換や部首合成変換も使用可能。
交ぜ書き変換で「どとう」を変換(△どとう{変換キー(スペース)}{確定キー(^M)})
して、部首合成変換で「捗」を変換(▲才歩)する例:

    $ echo 'aljdljdjru ^Mfjxiala/.;f' | uim-sh $PWD/uimsh-tutctool.scm seq2kanji
    怒濤の進捗

kanji2seq: 漢字をuim-tutcodeキーシーケンスに変換
------------------------------------------------
* 入力: 漢字文字列
* 出力: uim-tutcodeキーシーケンス

シーケンスがずれて意味不明な漢字文字列になったものを修復する例:

    $ echo '電地給月分動田新同 ' | uim-sh $PWD/uimsh-tutctool.scm kanji2seq \
    | cut -b 2- | uim-sh $PWD/uimsh-tutctool.scm seq2kanji
    うかもしれません。

kcodeucs: Unicodeコードポイント(U+XXXX)に対応するEUC-JP文字を出力
-----------------------------------------------------------------
* 入力: Unicodeコードポイント(U+XXXX)
* 出力: EUC-JP文字

実行例:

    $ echo U+25b3 | uim-sh $PWD/uimsh-tutctool.scm kcodeucs
    △

kuten: 区点番号に対応するEUC-JP文字を出力
-----------------------------------------
* 入力: -で区切った、面-区-点番号(面区点それぞれ10進数)。1面の場合、面-は省略可能。(例:1-48-13または48-13)
* 出力: EUC-JP(EUC-JISX0213)文字

実行例:

    $ echo 1-48-13 | $PWD/uimsh-tutctool.scm kuten
    亅

関連
====

* [uim-bushuconv](https://github.com/deton/uim-bushuconv)

    UTF-8対応の部首合成変換IM。
    また、文字列内のUnicodeコードポイントのU+XXXXX表記の置換をして
    UTF-8文字列を出力するコマンドラインツールあり。

* [tcfilter](http://www1.interq.or.jp/~deton/tcfilter/)

    標準入力に対するフィルターとして使うことで、
    コマンドラインでTUT-Codeシーケンスから漢字への変換可能。

* [tutstroke](http://www1.interq.or.jp/~deton/tcfilter/#tutstroke)

    [tclib](http://www.tcp-ip.or.jp/~tagawa/archive/)のshow_stroke()関数を
    使って、漢字の打ち方ヘルプを表示するコマンドラインツール。
