#!/bin/bash

## ファイル名: calcurate-leaving-company-time
## 処理内容: 出社時間・休憩開始時間・休憩終了時間を入力したら自動で退社時間を計算して、clipboardに設定してくれる

today_date=`date +%Y-%m-%d`
# NOTE: 8時間労働の設定
work_time=$((8 * 60 * 60))

# NOTE: 出社時間の入力待ち
while :
do
  # TODO: 0埋めされていないときは自動で0埋めしたい。
  read -r -p '出社時間を入力してください(先頭0埋め): ' coming_to_work_time
  # 日時がhh:mm形式で入力されているかのチェック
  if [[ ${coming_to_work_time} =~ ^([01][0-9]|2[0-3]):([0-5][0-9])$ ]]; then
    coming_to_work_unix_time=`date -j -f '%Y-%m-%d %H:%M:%S' "${today_date} ${coming_to_work_time}:00" +%s`
    break
  else
    echo '入力された値は、指定された時間形式ではありません。(入力例: 01:00や13:00で形式で入力してください。)'
    echo "実際に入力された値: ${coming_to_work_time}"
  fi
done

# NOTE: 休憩開始時間の入力待ち
while :
do
  # TODO: 0埋めされていないときは自動で0埋めしたい
  read -r -p '休憩開始時間を入力してください(先頭0埋め): ' break_start_time
  # 日時がhh:mm形式で入力されているかのチェック
  if [[ ${break_start_time} =~ ^([01][0-9]|2[0-3]):([0-5][0-9])$ ]]; then
    break_start_unix_time=`date -j -f '%Y-%m-%d %H:%M:%S' "${today_date} ${break_start_time}:00" +%s`
    break
  else
    echo '入力された値は、指定された時間形式ではありません。(入力例: 01:00や13:00で形式で入力してください。)'
    echo "実際に入力された値: ${break_start_time}"
  fi
done


# 休憩後の残り作業時間を秒数で取得
rest_time=$((work_time - (break_start_unix_time - coming_to_work_unix_time)))

# NOTE: 休憩終了時間の入力待ち
while :
do
  # TODO: 0埋めされていないときは自動で0埋めしたい
  read -r -p '休憩終了時間を入力してください(先頭0埋め): ' break_end_time
  # 日時がhh:mm形式で入力されているかのチェック
  if [[ ${break_end_time} =~ ^([01][0-9]|2[0-3]):([0-5][0-9])$ ]]; then
    break_end_unix_time=`date -j -f '%Y-%m-%d %H:%M:%S' "${today_date} ${break_end_time}:00" +%s`
    break
  else
    echo '入力された値は、指定された時間形式ではありません。(入力例: 01:00や13:00で形式で入力してください。)'
    echo "実際に入力された値: ${break_end_time}"
  fi
done

leaving_office_unix_time=$((break_end_unix_time + rest_time))

leaving_office_time=`date -r ${leaving_office_unix_time} +"%H:%M"`

# TODO: 分岐で書きたい
echo "今日の退社時間: ${leaving_office_time} をclipboardに保存しました。"
echo "${leaving_office_time}" | pbcopy
