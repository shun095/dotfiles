#!/bin/bash

# 色名とカラーコードのリスト（前景色と背景色）
color_names=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white" \
"bright_black" "bright_red" "bright_green" "bright_yellow" "bright_blue" \
"bright_magenta" "bright_cyan" "bright_white")

# 最大の色名の長さを取得して列幅を調整
max_length=0
for color in "${color_names[@]}"; do
    length=${#color}
    if ((length > max_length)); then
        max_length=$length
    fi
done

echo -e " 通常 前景色: normal  \033[0m"
echo -e "\033[7m 通常 背景色: reverse \033[0m"

# 表示ヘッダー
printf "%-${max_length}s | %-${max_length}s | %-${max_length}s | %-${max_length}s\n" "fg" "bg" "bright fg" "bright bg"
echo "---------------------------------------------------------------"

# 16色の表示
for i in {0..7}; do
    fg_color=$(printf "\033[38;5;${i}m%-${max_length}s\033[0m" "${color_names[$i]}")
    bg_color=$(printf "\033[48;5;${i}m%-${max_length}s\033[0m" "${color_names[$i]}")
    bright_fg_color=$(printf "\033[38;5;$((i+8))m%-${max_length}s\033[0m" "${color_names[$((i+8))]}")
    bright_bg_color=$(printf "\033[48;5;$((i+8))m%-${max_length}s\033[0m" "${color_names[$((i+8))]}")
    
    # 各色を4列で表示
    printf "%s | %s | %s | %s\n" "$fg_color" "$bg_color" "$bright_fg_color" "$bright_bg_color"
done



# ターミナル属性のテスト用スクリプト（declare 不使用）
echo "ターミナルの属性サポートチェック"

# 属性一覧をキーと値のペアとして保存
attributes=(
  "bold:1"
  "underline:4"
  "underdouble:4:2"    
  "undercurl:4:3"  
  "underdotted:4:4"    
  "underdashed:4:5"    
  "undercustom:4:6"    
  "strikethrough:9"  
  "reverse:7"
  "inverse:7"       
  "italic:3"
  "standout:7"      
  "NONE:0"          
)

# 各属性を出力して確認
for attr in "${attributes[@]}"; do
  key="${attr%%:*}"   # コロンの前をキーとして取得
  value="${attr#*:}"  # コロンの後を値として取得
  echo -e "属性 [$key] (\033[${value}mTest\033[0m)"
done
echo "アンダーラインの色チェック"
printf "\x1b[58:2::255:0:0m\x1b[4:1munderline\n\x1b[4:2munderdouble\n\x1b[4:3mundercurl\n\x1b[4:4munderdotted\n\x1b[4:5munderdashed\x1b[0m\n"

