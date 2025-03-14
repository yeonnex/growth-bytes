<!-- Date: 2025-01-19 -->
<!-- Update Date: 2025-01-19 -->
<!-- File ID: c0fa35d5-4b69-4ab6-8256-5817edeca4ea -->
<!-- Author: Seoyeon Jang -->

# 개요

OSI 7계층의 4계층인 전송계층에서 사용하는 프로토콜에는 대표적으로 TCP(Transmission Control Protocol)와 UDP(User Diagram Protocol)가 있으며, 데이터 전송을
담당한다.

## TCP

TCP는 송수신 대상간 연결을 맺고 데이터 전송 여부를 **하나씩 확인**하며 전송하는 연결형 프로토콜로, 신뢰성 있는 데이터 전송을 보장한다. 연결을 맺고 확인하는 작업에 따라 신뢰성은 높아지겠지만 아무래도
전송속도는 느릴 수밖에 없다. 이런 측면에서 TCP는 속도보다 안정적인 데이터 전송을 보장하는 응용 서비스에 활용된다.

## UDP

UDP는 TCP와 반대로 송수신 대상 간 연결 없이 전달하는 비연결형 프로토콜이다. 연결이나 제어를 위한 작업이 없어 신뢰성 있는 전송을 보장할 수는 없지만, 빠르게 데이터를 전송할 수는 있다. 데이터 유실에 큰
지장이 없고 빠른 데이터 전송을 위한 응용 서비스에 활용된다.

| 구분       | TCP        | UDP         |
|----------|------------|-------------|
| OSI 7 계층 | 전송계층       | 전송계층        |
| 연결성      | 연결 포로토콜    | 비연결 프로토콜    |
| 신뢰성      | 높음         | 낮음          |
| 제어       | 혼잡제어, 흐름제어 | 제어에 관여하지 않음 |
| 속도       | 느림         | 빠름          |
| 주요 서비스   | HTTP, SSH등 | DNS, DHCP 등 |

## 포트 번호
TCP와 UDP를 사용하는 응용 서비스는 서로 구분할 수 있도록 **포트 번호**를 사용한다. 이런 포트 번호는 IANA(Internet Assigned Numbers Authority)라는 인터넷 할당 번호 관리 기관에서 정의한다. 예를 들어 **HTTP 프로토콜은 TCP 80번 포트를 사용**하며, DNS 서비스는 UDP 53번 포트를 사용한다.

>IANA에서 정의하는 포트 번호 범위는 다음과 같다.
> - 잘 알려진 포트 번호(well known port): 0 ~ 1023
> - 등록된 포트 번호(registered port): 1014 ~ 49159
> - 동적 포트(dymanic port): 49152 ~ 65535


# 정리


