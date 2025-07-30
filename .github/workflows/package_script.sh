#!/bin/bash
# 修正执行顺序的脚本
echo "生成 MD5 校验列表..."
# 先生成 MD5 校验列表
find . -maxdepth 1 -type f ! -name "md5.md5" ! -name "opt-script.tgz" -exec md5sum {} \; > md5.md5
find ./script -type f -exec md5sum {} \; >> md5.md5
find ./www_sh -type f -exec md5sum {} \; >> md5.md5
echo "MD5 校验列表已生成，保存在 md5.md5 文件中。"

# 对比并更新 scriptsh.txt 中的 MD5 值
md5_file="md5.md5"
scriptsh_file="scriptsh.txt"
temp_file="${scriptsh_file}.tmp"
cp "$scriptsh_file" "$temp_file"

while IFS= read -r line; do
    md5_value=$(echo "$line" | awk '{print $1}')
    file_path=$(echo "$line" | awk '{print $2}')
    
    file_name=$(basename "$file_path")
    key_name=$(echo "$file_name" | sed 's/\.sh$//')
    
    if grep -q "^$key_name=" "$temp_file"; then
        current_md5=$(grep "^$key_name=" "$temp_file" | cut -d '=' -f 2)
        
        if [ "$current_md5" != "$md5_value" ]; then
            sed -i "s/^$key_name=.*/$key_name=$md5_value/" "$temp_file"
        fi
    fi
done < "$md5_file"

mv "$temp_file" "$scriptsh_file"
echo "MD5 值已更新，未映射的内容保持不变。"

# 最后进行打包，这样压缩包中包含的是更新后的文件
echo "开始打包..."
tar --exclude=".github" -czf opt-script.tgz --transform 's,^,opt-script/,' *
echo "打包完成。"
