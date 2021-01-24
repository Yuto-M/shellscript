# shellscript
自作したシェルスクリプトをまとめるためのrepository。

コマンド化する場合は、/usr/local/binディレクトリ(pathが通っているところ)にシンボリックリンクを作成して対応する。
https://qiita.com/genya0228/items/01b63d449a6c1956df7d

シンボリックリンクの貼り方例
```
ln -s ~/develop/shellscript/generate-review-file.sh /usr/local/bin/generate-review-file
```
### 配布用補足
- chmod 700 calcurate-leaving-company-time.sh で実行権限与える
