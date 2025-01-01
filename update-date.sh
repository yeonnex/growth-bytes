#!/bin/bash
# 파일 내 'Update Date:' 부분을 현재 날짜로 변경하는 스크립트

# 현재 날짜를 'yy. MM. dd.' 형식으로 얻기
CURRENT_DATE=$(date "+%y. %m. %d.")

# Update Date 부분을 찾아서 현재 날짜로 갱신
sed -i '' "s/<!-- Update Date: [^}]* } -->/<!-- Update Date: $CURRENT_DATE } -->/" "$1"