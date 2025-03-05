자바는 현존하는 주류 언어들 중 최초로 멀티스레드 프로그래밍을 지원했다. 그러나 이건 그것만의 부작용도 낳았다.
동시성 프로그램이과 관련된 많은 문제들을 자바 개발자들이 처음으로 경험했다.

스레드 API 에 있는 몇가지 메서드가 안전하지 않고 사용하기에 부적절하다는 것이다. 특히 `Thread.stop()` 메서드는 안전하게 사용하기가 사실상 불가능하다.

이 메서드는 경고 없이 다른 스레드를 종료시키며, 종료된 스레드가 잠긴 객체를 안전하게 처리할 수 있는 방법은 없다.

## 1. `stop()` 메서드의 문제점

- 예전에는 스레드를 강제로 멈추는 `stop()` 메서드가 있었음.
- 하지만 **어디에서 실행 중인지 모르고 갑자기 멈춰버려서** 프로그램이 엉망이 될 수 있음
- 예를 들어 `finally` 블록을 실행하는 도중 스레드가 멈춰버리면 정말 예상치 못한 오류가 생길 수 있음

## 2. `suspend()`와 `resume()`도 위험함

- `suspend()`는 스레드를 일시 정지하는데, 모니터(잠금)를 풀지 않고 멈춰버림.
- 이 때문에 다른 스레드가 해당 잠금을 기다리다가 영원히 멈출 수 있음(데드락).
- 그래서 사용하면 안됨.

## 3. 해결책은 `shutdown` 패턴

- 위험한 메서드들은 자바 1.2 이후 사용 금지(deprecated)됨.
- 대신 `volatile` 같은 변수를 사용해 안전하게 스레드를 종료하는 shutdown 패턴을 사용하는 것이 좋음

## `volatile`이 어떻게 `shutdown`패턴에 안전하게 적용되는지?

`volatile` 키워드는 멀티스레드 환경에서 변수의 변경 사항이 모든 스레드에서 즉시 반영되도록 보장하는 역할을 한다.

이를 활용하면 스레드가 안전하게 종료되도록 유도할 수 있다.

### 1. 왜 `volatile`이 필요한가?

자바의 CPU 최적화 기법 중 하나인 "스레드 별 캐싱" 때문에, 스레드 내부에서는 공유 변수의 변경을 즉시 감지하지 못할 수도 있다.

```java
public class UnsafeThread extends Thread {

    private boolean running = true; // volatile 이 없음!  

    public static void main(String[] args) throws InterruptedException {
        UnsafeThread unsafeThread = new UnsafeThread();
        unsafeThread.start();
        Thread.sleep(1000);
        unsafeThread.shutdown();
    }

    @Override
    public void run() {
        while (this.running) { // running 이 변경되지 않으면 무한루프!  

        }
        System.out.println("worker 스레드 종료!");
    }

    public void shutdown() {
        this.running = false; // 이 변경을 다른 스레드가 즉시 인식하지 못할 수도 있음  
    }
}
```