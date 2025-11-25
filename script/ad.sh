#!/bin/bash
# 定义一个函数，用于下载和处理文件
download_and_process() {
    # 接收三个参数，分别是下载的URL，保存的文件路径，和处理的命令
    URL=$1
    OUTPUT_FILE=$2
    PROCESS_CMD=$3
    # 下载文件并保存到临时文件
    TMP_FILE="/tmp/$(basename $OUTPUT_FILE)_temp.txt"
    wget -O "$TMP_FILE" "$URL"
    # 检查文件是否下载成功
    if [ $? -eq 0 ]; then
        # 根据处理命令，提取并重新生成列表，保存到目标文件
        cat "$TMP_FILE" | eval "$PROCESS_CMD" > "$OUTPUT_FILE"
        echo "Updated $(basename $OUTPUT_FILE) successfully."
    else
        echo "Failed to download the file from $URL."
    fi
    # 删除临时文件
    rm -f "$TMP_FILE"
}
# 第一部分：下载和处理各种文件
download_and_process "https://bitcion.github.io/zaixiantuoguan/cn.txt" "/opt/cn.txt" "cat"
download_and_process "https://bitcion.github.io/zaixiantuoguan/ipv4.txt" "/opt/ipv4.txt" "cat"
download_and_process "https://anti-ad.net/domains.txt" "/opt/ad.txt" "cat"
download_and_process "https://anti-ad.net/anti-ad-for-smartdns.conf" "/opt/anti-ad-for-smartdns.conf" "sed '/^[^#]/s/\/#/\/#4/g'"
# 第二部分：更新aria2的BT追踪器列表

list=`wget -qO- https://cf.trackerslist.com/best.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
echo ${list}
if [ -z "`grep "bt-tracker" /etc/storage/aria2_conf.sh`" ]; then
    sed -i '$a bt-tracker='${list} /etc/storage/aria2_conf.sh
    echo 添加"bt-tracker="前缀...
else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" /etc/storage/aria2_conf.sh
    echo 升级完成...
fi
