#!/bin/bash

## ファイル名: generate-review-file.sh
## 処理内容: レビュー用のファイル生成を行う


ask_pull_req_name='プルリク名を入力してください'
ask_pull_req_url='プルリクのURLを入力してください'
review_dir_path="${HOME}/Desktop/AutoScale-for-me/review"

get_review_file_body() {
  cat <<EOS
pull req
${pull_req_name}

pull req url
${pull_req_url}

## 想定作業時間
時間:

## 実際作業時間と振り返り
時間:
振り返り:

## 動作確認


## コーディング関係


## DB


## その他

EOS
}

echo "${ask_pull_req_name}"

while :
do
  read -r pull_req_name
  if [[ -n "${pull_req_name}" ]]; then
    file_name="${pull_req_name}.md"
    # #以降の数字を取得
    pull_req_number="${pull_req_name##*\#}"
    break
  else
    echo '空文字列は無効です'
    echo "${ask_pull_req_name}"
  fi
done

echo "${ask_pull_req_url}"

abort () {
  echo "$@" 1>&2
  exit 1
}

while :
do
  read -r pull_req_url
  if [[ -n "${pull_req_url}" ]]; then
    # 「/」がファイル名に含まれているとファイルシステムにディレクトリとして見なされるため正常にファイル作成ができないので「-」に置換
    replaced_file_name="${pull_req_name//\//-}"
    file_name="${pull_req_number}${replaced_file_name}.md"
    file_body=$(get_review_file_body)
    echo "${file_body}" > "${review_dir_path}/${file_name}" || abort 'ファイルの生成に失敗しました'
    echo "${file_name}でファイルを作成しました"
    break
  else
    echo '空文字列は無効です'
    echo "${ask_pull_req_url}"
  fi
done