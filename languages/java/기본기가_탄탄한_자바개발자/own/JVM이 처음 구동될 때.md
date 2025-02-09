<!-- Date: 2025-02-09 -->
<!-- Update Date: 2025-02-09 -->
<!-- File ID: c4df479e-5671-4377-a81e-f86049d0d21d -->
<!-- Author: Seoyeon Jang -->

# 개요

JVM이 시작되는 프로세스 초기라는 건 `java` 명령어를 실행할 때를 의미한다.

```shell
$ java -jar app.jar
```

이렇게 하면 JVM이 시작되면서 가장 먼저 **부트스트랩 클래스 로더**가 동작한다.

## JVM 실행과정

1. JVM 실행(`java MyApp`)
    - OS가 자바 실행파일(`java`)을 실행하면, JVM프로세스가 시작된다.
2. 부트스트랩 클래스로더 시작
    - `java.base` 모듈에 있는 핵심 클래스들(java.lang.Object, String)을 메모리에 올린다
3. 플랫폼 클래스 로더 실행
    - `java.sql` 같은 표준 라이브러리들이 필요한 경우 추가적으로 로드된다
4. 애플리케이션 클래스 로더 실행
    - 우리가 만든 `Main` 클래스를 찾아서 실행
5. `main()` 실행
    - `public static void main(String[] args)`가 실행되면서 애플리케이션이 본격적으로 시작

즉 JVM이 시작하는 순간은 내가 `java` 명령어를 입력해서 실행하는 바로 그 순간이다.

# 정리


