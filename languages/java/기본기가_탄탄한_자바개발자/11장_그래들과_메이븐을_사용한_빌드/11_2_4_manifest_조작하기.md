<!-- Date: 2025-01-23 -->
<!-- Update Date: 2025-01-23 -->
<!-- File ID: 678d120e-8744-43c7-8d15-7c1824a0c340 -->
<!-- Author: Seoyeon Jang -->

# 개요

`mvn package`에서 생성된 JAR은 JVM에게 시작 시 메인 메서드를 어디에서 찾아야 하는지 알려주는 manifest가 빠져있었다. 다행히 메이븐은 manifest 작성 방법을 알고 있는 JAR 구성용
플러그인과 함께 제공된다. 이 플러그인은 다음과 같이 pom.xml에서 project 요소 내에 있는 `properties` 요소 다음 configuration 을 통해 구성을 노출한다.

```xml

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <version>2.4</version>
            <!--  각 플러그인은 자체적인 configuration 요소와 지원되는 다양한 하위요소 및 속성을 가지고 있다  -->
            <configuration>
                <archive>
                    <manifest>
                        <addClasspath>true</addClasspath>
                        <mainClass>com.wellgrounded.Main</mainClass>
                        <Automatic-Module-Name>
                            com.wellgrounded
                        </Automatic-Module-Name>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
    </plugins>
</build>
```

위 섹션을 추가하면 메인 클래스가 설정돼 자바 런처가 JAR를 직접 실행할 수 있다. 또한 자동 모듈 이름도 추가했다. 이것은 모듈화된 세계에서 좋은 구성원이 되게 하기 위한 것이다. 이전 장에서 논의했던 대로,
우리가 작성하는 코드가 모듈화돼있지 않더라도 (이경우와 같이) 명시적인 자동 모듈 이름을 제공하는 것은 모듈화된 애플리케이션이 우리의 코드를 더 쉽게 사용할 수 있게 해준다.

plugin 요소 아래에 configuration을 설정하는 이러한 패턴은 메이븐에서 매우 표준적이다. 대부분의 기본 플러그인은 지원되지 않거나 예상치 못한 구성 속성을 사용할 경우 친절하게 경고해주지만 세부적인
사항은 플러그인마다 다를 수 있다.

# 정리


