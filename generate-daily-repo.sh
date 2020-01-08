#!/bin/bash

## ファイル名: generate-daily-repo.sh
## 処理内容: 日報の生成を行う

echo '生成する日報を選択してください'
select daily_repo_type in '明日' '来週月曜' '今日'
do
	echo '出勤タイプを選択してください'
	select work_type in '出社' 'リモート'
	do
		if [[ $work_type == '出社' || $work_type == 'リモート' ]]; then
			break;
		else
			echo '正しい出勤タイプが選択されなかったため日報を生成しないで終了します'
			exit 1
		fi
	done
	echo "【${daily_repo_type}】の日報を【${work_type}タイプ】で作成しますか？[Y/n]: "
	read -r confirm
	if [[ ($confirm =~ [Yy]) || ($confirm == '') ]]; then
		break
	else
		echo '日報を生成しないで終了します'
		exit 1
	fi
done

# ファイル名設定
# shellcheck disable=SC2154
today="$(date +%Y%m%d)" # 今日の日付取得
tomorrow="$(date -v+1d '+%Y%m%d')"
next_monday="$(date -v-monday -v+7d +'%Y%m%d')" # 来週の月曜

# 日報の方で使用する日付(-付き)
file_today="$(date +%Y-%m-%d)"
file_tomorrow="$(date -v+1d +%Y-%m-%d)"
file_next_monday="$(date -v-monday -v+7d +'%Y-%m-%d')"

# 引数で指定された曜日を返す
get_day_of_week() {
  local dow_arr=('日' '月' '火' '水' '木' '金' '土') # 曜日用の配列
	local dowIdx
	dowIdx="$1" # 引数
	echo "${dow_arr[${dowIdx}]}" # 曜日設定
	return 0
}

get_start_datetime() {
	local datetime_list=('9:00' '10:00')
	if [[ $work_type == 'リモート' ]]; then
		echo "${datetime_list[0]}"
	else
		echo "${datetime_list[1]}"
	fi
	return 0
}

generate_tommorow_daily_repo() {
	local dowIdx
	dowIdx="$(date -v+1d '+%w')"

	local dow
	# 曜日の決定
	dow="$(get_day_of_week "${dowIdx}")"
	echo "${dow}"
	# 開始時刻の設定
	start_datetime="$(get_start_datetime)"
	# ファイルが存在していない時のみ作成
	if [[ -e "${HOME}/Desktop/AutoScale-for-me/daily-repo/${tomorrow}日報.md" ]]; then
		echo "${HOME}/Desktop/AutoScale-for-me/daily-repo/${tomorrow}日報.mdは存在しています"
		exit 1
	else
		cat << EOS > "${HOME}/Desktop/AutoScale-for-me/daily-repo/${tomorrow}日報.md"

${file_tomorrow} ($dow)

予定
${file_tomorrow} ($dow)
- ${start_datetime} ${work_type}
- ${start_datetime} - 13:00
- 13:00 - 14:00 休憩
- 16:00 - 17:00 (PRたまっていたら)PRレビュー


実績
${file_tomorrow} ($dow)
- ${start_datetime} ${work_type}
- ${start_datetime} - 13:00
- 13:00 - 14:00 休憩


# 後で調べる・疑問点


EOS
	fi
}

generate_next_monday_daily_repo() {
	local dowIdx
	dowIdx="$(date -v-monday -v+7d '+%w')"

	local dow
	# 曜日の決定
	dow="$(get_day_of_week "${dowIdx}")"
	echo "${dow}"
	# 開始時刻の設定
	start_datetime="$(get_start_datetime)"
	# ファイルが存在していない時のみ作成
	if [[ -e "${HOME}/Desktop/AutoScale-for-me/daily-repo/${next_monday}日報.md" ]]; then
		echo "${HOME}/Desktop/AutoScale-for-me/daily-repo/${next_monday}日報.mdは存在しています"
		exit 1
	else
		cat << EOS > "${HOME}/Desktop/AutoScale-for-me/daily-repo/${next_monday}日報.md"

${file_next_monday} ($dow)

予定
${file_next_monday} ($dow)
- ${start_datetime} ${work_type}
- ${start_datetime} - 13:00
- 13:00 - 14:00 休憩
- 16:00 - 17:00 (PRたまっていたら)PRレビュー


実績
${file_next_monday} ($dow)
- ${start_datetime} ${work_type}
- ${start_datetime} - 13:00
- 13:00 - 14:00 休憩


# 後で調べる・疑問点


EOS
	fi
}

generate_today_daily_repo() {
	local dowIdx
	dowIdx="$(date '+%w')"

	local dow
	# 曜日の決定
	dow="$(get_day_of_week "${dowIdx}")"
	echo "${dow}"
	# 開始時刻の設定
	start_datetime="$(get_start_datetime)"
	# ファイルが存在していない時のみ作成
	if [[ -e "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.md" ]]; then
		echo "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.mdは存在しています"
		exit 1
	else
		cat << EOS > "${HOME}/Desktop/AutoScale-for-me/daily-repo/${today}日報.md"

${file_today} ($dow)

予定
${file_today} ($dow)
- ${start_datetime} ${work_type}
- ${start_datetime} - 13:00
- 13:00 - 14:00 休憩
- 16:00 - 17:00 (PRたまっていたら)PRレビュー


実績
${file_today} ($dow)
- ${start_datetime} ${work_type}
- ${start_datetime} - 13:00
- 13:00 - 14:00 休憩


# 後で調べる・疑問点


EOS
	fi
}

# 選択されたタイプの日報を作成する
case "${daily_repo_type}" in
	'明日' )
		echo '明日の日報を作成しました'
		generate_tommorow_daily_repo
		;;
	'来週月曜' )
		echo '来週月曜の日報を作成しました'
		generate_next_monday_daily_repo
		;;
	'今日' )
		echo '今日の日報を作成しました'
		generate_today_daily_repo
		;;
	* )
		echo '予期しない動作です。'
		exit 1
		;;
esac
