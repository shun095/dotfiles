#!/bin/bash

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
