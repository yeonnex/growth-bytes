#!/bin/bash
# 파일 내 'Update Date:' 부분을 현재 날짜로 변경하는 스크립트

# 현재 날짜를 'yyyy-MM-dd' 형식으로 얻기
CURRENT_DATE=$(date "+%Y-%m-%d")

# 파일에서 현재 Update Date 확인 (확장 정규식 사용)
FILE_DATE=$(grep -oE '<!-- Update Date: [^<]* -->' "$1" | sed -E 's/<!-- Update Date: (.*) -->/\1/')

# 디버깅 출력
echo "현재 날짜: $CURRENT_DATE"
echo "파일 날짜: $FILE_DATE"

# 현재 날짜와 다를 경우에만 파일 수정
if [ "$CURRENT_DATE" != "$FILE_DATE" ]; then
  echo "날짜가 다릅니다. 파일을 수정합니다."
  sed -i '' "s/<!-- Update Date: [^<]* -->/<!-- Update Date: $CURRENT_DATE -->/" "$1"
else
  echo "파일이 최신 상태입니다."
fi