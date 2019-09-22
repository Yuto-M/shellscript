#!/bin/bash

## ファイル名: generate-daily-repo.sh
## 処理内容: 日報の生成を行う

# ファイル名設定
# shellcheck disable=SC2154
today="$(date +%Y%m%d)" # 今日の日付取得
file_today="$(date +%Y-%m-%d)" # 日報の方で使用する日付(-付き)

# 今日の曜日を返す
get_day_of_week() {
  local dow_arr=('日' '月' '火' '水' '木' '金' '土') # 曜日用の配列
	local dowIdx
	dowIdx="$(date +%w)" # 今日の曜日のインデックス取得
	echo "${dow_arr[${dowIdx}]}" # 曜日設定
	return 0
}

# 曜日の決定
dow=$(get_day_of_week)
echo "${dow}"
# ファイルが存在していない時のみ作成
if [[ -e "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.md" ]]; then
	echo "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.mdは存在しています"
	exit 1
else
	cat << EOS > "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.md"

${file_today} ($dow)

予定
- 10:00 出社
- 10:00 - 13:00
- 13:00 - 14:00 休憩
- 18:30 - 19:00 次回の準備

実績
${file_today} ($dow)
- 10:00 出社
- 10:00 - 13:00
- 13:00 - 14:00 休憩
- 18:30 - 19:00 次回の準備

EOS
fi
