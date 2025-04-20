#!/bin/bash

# 打包当前目录下的所有文件到 opt-script.tgz
# 并将其内容放置在 opt-script/ 文件夹中，排除 .github 文件夹

echo "开始打包..."

tar --exclude=".github" -czf opt-script.tgz --transform 's,^,opt-script/,' *

echo "打包完成。"

echo "生成 MD5 校验列表..."

# 生成 MD5 校验列表并保存到 md5.md5 文件，仅包含根目录文件以及 script 和 www_sh 两个文件夹中的文件
find . -maxdepth 1 -type f ! -name "md5.md5" ! -name "opt-script.tgz" -exec md5sum {} \; > md5.md5
find ./script -type f -exec md5sum {} \; >> md5.md5
find ./www_sh -type f -exec md5sum {} \; >> md5.md5

echo "MD5 校验列表已生成，保存在 md5.md5 文件中。"

# 对比 md5.md5 和 scriptsh.txt 文件，更新冲突的 MD5 值
md5_file="md5.md5"
scriptsh_file="scriptsh.txt"

# 创建一个临时文件存储更新后的内容
temp_file="${scriptsh_file}.tmp"
cp "$scriptsh_file" "$temp_file"

# 将 md5.md5 文件中的路径转换为 scriptsh.txt 的键名格式
while IFS= read -r line; do
    md5_value=$(echo "$line" | awk '{print $1}')
    file_path=$(echo "$line" | awk '{print $2}')
    
    # 提取文件名并转换为键名格式
    file_name=$(basename "$file_path")
    key_name=$(echo "$file_name" | sed 's/\.sh$//')

    # 检查 scriptsh.txt 中是否存在相同的键名
    if grep -q "^$key_name=" "$temp_file"; then
        # 获取 scriptsh.txt 中的 MD5 值
        current_md5=$(grep "^$key_name=" "$temp_file" | cut -d '=' -f 2)
        
        # 如果 MD5 值不同，更新为新的 MD5 值
        if [ "$current_md5" != "$md5_value" ]; then
            sed -i "s/^$key_name=.*/$key_name=$md5_value/" "$temp_file"
        fi
    fi

done < "$md5_file"

# 将更新后的内容写回 scriptsh.txt
mv "$temp_file" "$scriptsh_file"

echo "MD5 值已更新，未映射的内容保持不变。"
