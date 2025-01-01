#!/bin/bash
# 파일 내 'Update Date:' 부분을 현재 날짜로 변경하는 스크립트
# Intellij 의 File Watcher 플러그인이 cmd + s 키보드 트리거를 받으면 본 스크립트 실행

# 현재 날짜를 'yyyy-MM-dd' 형식으로 얻기
CURRENT_DATE=$(date "+%Y-%m-%d")

# Update Date 부분을 찾아서 현재 날짜로 갱신
sed -i '' "s/<!-- Update Date: [^}]* -->/<!-- Update Date: $CURRENT_DATE -->/" "$1"