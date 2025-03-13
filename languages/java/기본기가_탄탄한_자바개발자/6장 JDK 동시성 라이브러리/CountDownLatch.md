## CountDownLatch 가 없었다면?

`CountDownLatch`는 **여러 스레드들이 특정 조건이 만족될 때까지 기다리게 해주는 유용한 도구이다.** 만약 `CountDownLatch`가 없다면, 이러한 동기화를 구현하기 위해 수동으로 다른 방법들을 적용해야 한다.

### 1. `Thread.join()`을 사용한 방법

`join()` 메서드는 **각 스레드가 끝날때까지 기다리게 할 수 있다.** 만약 `CountDownLatch`가 없다면, 여러 스레드를 실행한 후 각 스레드에 대해 `join()`을 호출하여 각 작업이 끝날때까지 기다릴 수 있다.

```java
public class ThreadJoinExample {
	
	
	public static void main(String[] args) throws InterruptedException {
	
		Thread thread1 = new Thread(new Task());
		Thread thread2 = new Thread(new Task());
		Thread thread3 = new Thread(new Task());
		
			
		thread1.start();
		thread2.start();
		thread2.start();
		
		// 모든 스레드가 끝날때까지 기다림 (동기 방식)
		thread1.join();
		thread2.join();
		thread3.join();
		
		System.out.println("모든 작업 완료!");
	}
	
	static class Task implements Runnable {
		@Override
		public void run() {
			try {
				Thread.sleep((long) (Math.random() * 3000)); // 랜덤 시간 대
				System.out.println(Thread.currentThread().getName() + "작업 완료!");
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
	
}
```

위 방식은 동기적인 (`waiting`) 방식이다. 즉, **각 스레드가 종료될 때까지 메인 스레드(main thread)가 기다렸다가 다음으로 넘어간다.**

## 📌 `join()` 방식의 실행 흐름
1. `thread1.join();` → `thread1` 이 끝날때까지 `main` 스레드는 기다림
2. `thread2.join();` → `thread2` 가 끝날때까지 `main` 스레드는 기다림
3. `thread2.join();` → `thread3` 가 끝날때까지 `main` 스레드는 기다림
4. 모든 스레드가 종료되면 `"모든 작업 완료!"` 출력

**즉, 스레드가 "순차적으로" 끝날때까지 기다리는 방식이라, 병렬성이 제한된다.**

## 🚨 이 방식의 문제점

- `thread1`이 끝나야 `thread2`를 기다리고, `thread2`가 끝나야 `thread3` 를 기다림
	→ 병렬처리가 아니라 사실상 순차 실행과 다름없음
- 스레드 개수가 많아지면 코드가 지저분해짐
	→ 스레드 개수만큼 `.join()`을 호출해야 함

## ✅ `CountDownLatch`를 사용하면?


이 문제를 해결하기 위해 `CountDownLatch`를 사용하면 **병렬성을 유지하면서도 모든 스레드가 끝날때까지 기다릴 수 있다.**

```java
public class Main{

	public static void main(String[] args) throws InterruptedException {
		CountDownLatch latch = new CountDownLatch(3);
		
		Thread thread1 = new Thread(new Task(latch));
		Thread thread2 = new Thread(new Task(latch));
		Thread thread3 = new Thread(new Task(latch));
		
		thread1.start();
		thread2.start();
		thread3.start();
		
		latch.await(); // 모든 스레드가 끝날때까지 대기 (병렬성 유지!)
		
		System.out.println("모든 작업 완료!");
		
	}
}
```

```java
class Task implements Runnable {

	private final CountDownLatch latch;
	
	public Task(CountDownLatch latch) {
		this.latch = latch;
	}
	
	@Override
	public void run() {
		System.out.println(Thread.currentThread().getName() + " 작업 수행중...");
		try {
			Thread.sleep((int) (Math.random() * 1000)); 
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		System.out.println(Thread.currentThread().getName() + " 작업 완료!");
		// 스레드 종료 후 count 감소
		this.latch.countDown();
	}
}
```

### 📌 실행 흐름
1. 세 개의 스레드가 동시에 실행됨 (병렬 실행)
2. `latch.await();` 가 모든 스레드가 끝날때까지 기다림
3. 모든 스레드가 종료되면 `"모든 작업 완료!"` 출력

→ 병렬성을 유지하면서도 모든 스레드가 끝날때까지 기다리는 깔끔한 방식!

## 📝 정리


| 방식               | 특징                         | 특이사항                          |
| ---------------- | -------------------------- | ----------------------------- |
| `join()`         | 각 스레드가 끝날때까지 순차적으로 기다림(동기) | 병렬성이 제한됨, 코드가 지저분해질 수 있음      |
| `CountDownLatch` | 모든 스레드를 병렬 실행하면서도 대기 가능    | `CountDownLath`객체를 추가로 사용해야 함 |

### 결론

✅ 단순히 2~3개의 스레드만 기다릴 때 → `.join()` 도 가능
✅ 스레드가 많거나 병렬 실행을 유지하면서 기다릴 때 → `CountDownLatch` 가 훨씬 유용!