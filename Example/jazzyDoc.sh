#!/bin/bash



# 获取当前shell地址，在cd到当前地址
#filepath=$(cd "$(dirname "$0")"; pwd)
#cd $filepath

#bundle exec jazzy \
#-o VTools_SDK_iOS/Docs \
#--swift \
#--umbrella-header VTools_SDK_iOS/SDK/VTools.framework/Headers/VTools-umbrella.h \
#--module VTools \
#--author 广州市威士丹利智能科技有限公司 \
#--author_url http://www.vensi.cn/ \
#--module-version 1.0.0 \
#--title VTools \
#--theme fullwidth \
#--github_url https://gitee.com/deanMr \
#--readme VToolsREADME.md

bundle exec jazzy \
  --clean \
  --author 广州市威士丹利智能科技有限公司 \
  --author_url https://realm.io \
  --source-host http://www.vensi.cn/ \
  --source-host-url https://gitee.com/deanMr \
  --source-host-files-url https://gitee.com/deanMr \
  --module-version 0.1.0 \
  --build-tool-arguments -scheme,RealmSwift \
  --module VTools \
  --root-url VTools_SDK_iOS/SDK/VTools.framework/ \
  --output VTools_SDK_iOS/Docs \
  --theme docs/themes


# --umbrella-header 最好是 .framework 里面的 xxx-umbrella.h
# 因为当所有的头文件能同级的时候，才能完全的链接各种跳转
