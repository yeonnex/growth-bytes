<!-- Date: 2025-01-04 -->
<!-- Update Date: 2025-01-04 -->
<!-- File ID: 8a1f01d4-993d-4a71-be33-ed529ed52e97 -->
<!-- Author: Seoyeon Jang -->

# 개요

멀티 스테이지 빌드가 적용된 Dockerfile 스크립트를 한 가지 더 살펴보자.
이번에는 Node.js 애플리케이션을 빌드하는 스크립트다.
최근에는 조직의 기술 스택이 점점 다양해지는 만큼, 도커를 이용한 서로 다른 빌드 방식을 살펴보는 것도 도움이 될 것이다.
Node.js는 자바와는 다른 스크립트 언어이다. 이 빌드 패턴 역시 파이썬, PHP, 루비 등 여타 스크립트 언어에 그대로 적용 가능하다.
노드 프로젝트는 diamol 프로젝트의 `ch04/exercises/access-log`에서 볼 수 있다.

자바 애플리케이션은 **컴파일**을 거쳐야 하기 때문에 빌드 단계에서 소스코드를 복사한 다음 패키징 과정을 통해 JAR 파일을 생성했었다.
JAR 파일은 컴파일된 애플리케이션을 담은 파일로 이 파일이 다시 최종 애플리케이션 이미지에 복사되며 소스코드는 여기에 포함되지 않는다. 닷넷 코어 마찬가지다.
컴파일된 바이너리는 DLL(dynamic link library)포맷이다. 그러나 Node.js는 이와는 조금 다르다.
Node.js 애플리케이션은 자바스크립트로 구현된다. 자바스크립트는 인터프리터형 언어로 별도의 컴파일 절차가 필요 없다
**컨테이너화된 Node.js 애플리케이션을 실행하려면 Node.js 런타임과 소스코드가 애플리케이션 이미지에 포함**돼야 한다.

그렇다고 멀티 스테이지 빌드가 필요하지 않은 것은 아니다. 멀티 스테이지 빌드를 통해 의존 모듈 로딩을 최적화할 수 있다.
Node.js는 npm(node package manager)이라는 패키지 관리자를 사용해 의존 모듈을 관리한다.

다음은 Node.js 애플리케이션을 빌드하는 전체 Dockerfile 스크립트다.

```dockerfile
FROM diamol/node AS builder

WORKDIR /src
COPY src/package.json .

RUN npm install

# app
FROM diamol/node
EXPOSE 80
CMD ["node", "server.js"]

WORKDIR /app
COPY --from=builder /src/node_modules/ /app/node_modules/
COPY src/ .
```

이 스크립트의 목표 역시 앞서와 마찬가지로, 애플리케이션을 패키징하고 다른 도구 없이 도커만 설치된 환경에서 애플리케이션을 실행하는 것이다.
두 이미지 모두 `diamol/node`를 기반 이미지로 사용한다. 이 이미지는 Node.js 런타임과 npm이 설치된 이미지다.
builder 단계에서 애플리케이션의 의존 모듈이 정의된 package.json 파일을 복사한 다음, npm install 명령을 통해 의존 모듈을 내려받는다.
별도의 컴파일이 필요치 않으므로 빌드 과정은 이것이 전부다.

이 Node.js 애플리케이션 역시 REST API다. 최종 단계에서 공개할 HTTP포트와 애플리케이션 시작 명령을 지정한다.
**최종 단계는 작업 디렉터리를 만들고 호스트 컴퓨터로부터 애플리케이션 아티팩트를 모두 복사해 넣는 것으로 끝난다.**
src 디렉토리는 애플리케이션의 진입점 역할을 하는 server.js 파일을 비롯해 여러 자바스크립트 파일을 담고 있다.

이번 애플리케이션은 앞서 본 자바 앱의 예제와 기술 스택, 패키징 패턴이 모두 다르다. 기반 이미지, 빌드 도구, 실행 명령 또한 자바 애플리케이션과는 모두
차이가 있다. **하지만 이런 차이점에도 불구하고 Dockerfile 스크립트를 통해 같은 방식으로 애플리케이션을 빌드하고 실행할 수 있다.**

> 실습
> Node.js 애플리케이션의 소스코드를 훑어보고 이미지를 빌드하라.

```shell
$ docker image build -t access-log .
```

> 실습
> 지금 빌드한 access-log 이미지로 컨테이너를 실행하되, 이 컨테이너를 nat 네트워크에 연결하며 80번 포트를 공개하라.

```shell
$ docker container run --name=accesslog -d -p 801:80 --network=nat access-log
```

이 로그 API는 Node.js 버전 10.16으로 구동된다. 그러나 앞서 본 자바 애플리케이션과 마찬가지로, 특정한 버전의 Node.js 런타임이나 여타 도구를 호스트 컴퓨터에
설치할 필요가 없다. Dockerfile 스크립트에 정의된 빌드 절차에서 모든 의존 모듈과 스크립트를 최종 이미지에 복사했기 때문이다. `pip`를 사용하는 파이썬,
`gems`를 사용하는 루비도 같은 방식이 적용된다.

# 정리


