
1. 메인 스레드가 여러 개의 작업자 스레드(Thread)를 실행
2. 각 작업자 스레드는 작업을 수행한 후 `countDown()` 호출하여 래치 값 감소
3. 메인 스레드는 `await()` 을 호출한 상태에서 모든 작업이 끝날때까지 블록됨
4. 모든 스레드가 `countDown()`을 호출해 래치값이 0이 되면 메인 스레드가 진행됨

```text
[초기 상태] Latch(Count) = 3

Main Thread   ───▶ T1 실행 ───▶ (작업) ───▶ countDown() 호출  Latch = 2
              ───▶ T2 실행 ───▶ (작업) ───▶ countDown() 호출  Latch = 1
              ───▶ T3 실행 ───▶ (작업) ───▶ countDown() 호출  Latch = 0
              
              ───▶ Latch 값이 0이 되면서 await() 해제 → 메인 스레드 진행
```

`CountDownLatch`의 새 인스턴스를 생성할 때 int값(`count`) 을 제공하여 구현된다. 이후에는 `countDown()`과 `await()` 두 메서드를 사용하여 래치를 제어한다. `countDown()`메서드는 카운트를 1만큼 감소시키고, `await()` 메서드는 호출한 스레드가 카운트가 0이 될 때까지 블록되게끔 한다.

다음 예시는 각 `Runnable` 이 할당된 작업을 완료했음을 나타내기 위해 래치를 사용한다.

```java
public static class Counter implements Runnable {

	private final CountDownLatch latch;
	private final int value;
	private final AtomicInteger count;
	
	public Counter(CountDownLatch latch, int value, AtomicInteger count) {
		this.latch = latch;
		this.value = value;
		this.count - count;
	}
	
	@Override
	public void run() {
		try {
			Thread.sleep(100);
		} catch (InterruptedException e) {
			Thread.currentThread().interrupt();
		}
		// count 값을 아토믹하게 업데이트한다
		count.addAndGet(value);
		// 래치의 값을 감소시킨다
		latch.countDown();
	}
	
}
```

>`countDown()` 메서드는 논블록 방식으로 동작한다는 것에 유의하자.

메인 스레드는 래치가 0이 되기 전까지 진행되지 않는다.

`CountDownLatch`를 사용한 또 다른 좋은 사례는, 서버가 들어오는 요청을 수신할 준비가 되기 전에 여러 개의 캐시를 참조 데이터로 미리 채워야 하는 애플리케이션이 있을 수 있다. 이를 쉽게 구현할 수 있도록 각 캐시 생성 스레드가 참조하는 공유된 래치를 사용할 수 있다.

각 캐시가 로드를 완료하면 해당 캐시를 로드하는 `Runnable`은 래치를 카운트다운하고 종료한다. 모든 캐시가 로드되면 래치를 기다리던 메인 스레드의 진행으로 서비스를 시작하고 요청을 처리할 준비가 된다.