#!/bin/bash

# 打包当前目录下的所有文件到 opt-script.tgz
# 并将其内容放置在 opt-script/ 文件夹中，排除 .github 文件夹

echo "开始打包..."

tar --exclude=".github" -czf opt-script.tgz --transform 's,^,opt-script/,' *

echo "打包完成。"
