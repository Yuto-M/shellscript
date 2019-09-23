#!/bin/bash

## ファイル名: generate-daily-repo.sh
## 処理内容: 日報の生成を行う

# ファイル名設定
# shellcheck disable=SC2154
today="$(date +%Y%m%d)" # 今日の日付取得
tomorrow="$(date -v+1d '+%Y%m%d')"
ask_create_tommorow_repo='明日の日報を作成しますか？[Y/n]: '
file_today="$(date +%Y-%m-%d)" # 日報の方で使用する日付(-付き)
file_tomorrow="$(date -v+1d +%Y-%m-%d)" # 日報の方で使用する日付(-付き)

# 引数で指定された曜日を返す
get_day_of_week() {
  local dow_arr=('日' '月' '火' '水' '木' '金' '土') # 曜日用の配列
	local dowIdx
	dowIdx="$1" # 引数
	echo "${dow_arr[${dowIdx}]}" # 曜日設定
	return 0
}

generate_tommorow_daily_repo() {
	local dowIdx
	dowIdx="$(date -v+1d '+%w')"
	echo "${dowIdx}"
	local dow
	# 曜日の決定
	dow="$(get_day_of_week "${dowIdx}")"
	echo "${dow}"
	# ファイルが存在していない時のみ作成
	if [[ -e "${HOME}/Desktop/AutoScale-for-me/daily-repo/${tomorrow}日報.md" ]]; then
		echo "${HOME}/Desktop/AutoScale-for-me/daily-repo/${tomorrow}日報.mdは存在しています"
		exit 1
	else
		cat << EOS > "${HOME}/Desktop/AutoScale-for-me/daily-repo/${tomorrow}日報.md"

${file_tomorrow} ($dow)

予定
${file_tomorrow} ($dow)
- 10:00 出社
- 10:00 - 13:00
- 13:00 - 14:00 休憩
- 18:30 - 19:00 次回の準備

実績
${file_tomorrow} ($dow)
- 10:00 出社
- 10:00 - 13:00
- 13:00 - 14:00 休憩
- 18:30 - 19:00 次回の準備

EOS
	fi
}

generate_today_daily_repo() {
	local dowIdx
	dowIdx="$(date '+%w')"
	echo "${dowIdx}"
	local dow
	# 曜日の決定
	dow="$(get_day_of_week "${dowIdx}")"
	echo "${dow}"
	# ファイルが存在していない時のみ作成
	if [[ -e "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.md" ]]; then
		echo "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.mdは存在しています"
		exit 1
	else
		cat << EOS > "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.md"

${file_today} ($dow)

予定
${file_today} ($dow)
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
}

# 明日or今日の日報どちらの日報を作成するか尋ねる
echo "${ask_create_tommorow_repo}"
read -r answer_create_tommorow_repo
case "${answer_create_tommorow_repo}" in
	'' | [Yy]* )
		echo '明日の日報を作成しました'
		generate_tommorow_daily_repo
		;;
	* )
		echo '今日の日報を作成しました'
		generate_today_daily_repo
		;;
esac
