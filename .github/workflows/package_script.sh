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
