```java
class UnsafeVolatileCounter {  
  
  private static volatile int count = 0;  
  
  public static void main(String[] args) throws InterruptedException {  
    Thread t1 =  
        new Thread(  
            () -> {  
              for (int i = 0; i < 1000; i++) {  
                count++;  
              }  
            });  
  
    Thread t2 =  
        new Thread(  
            () -> {  
              for (int i = 0; i < 1000; i++) {  
                count++;  
              }  
            });  
  
    t1.start();  
    t2.start();  
    t1.join();  
    t2.join();  
  
    System.out.println("count: " + count);  
  }  
}
```

실행 결과 내 컴퓨터에서는,

```text
count: 1728
```
가 나왔다.

### 🚨 문제 발생!
- `count++`는 내부적으로 **읽기 -> 증가 -> 쓰기** 세 단계 작업을 수행한다.
- `volatile`이 있어도 동시에 실행되는 스레드들이 최신 값을 읽지 못하고 덮어쓰는 문제(race condition)가 발생할 수 있다.
- 실행할 때마다 결과값이 2000이 아니라 달라진다는 것이다. -> `volatile`만으로는 문제가 해결되지 않는다!


그렇다면 이전 예제에서는 왜 `volatile` 을 사용해도 안전했던 걸까?

```java
class VolatileExample {
	private static volatile boolean running = true; // 스레드 간 최신 값을 공유

	public static void main(String[] args) throws InterruptedException {
		Thread worker = new Thread(() -> {
			while(running) { // running 값이 true인 동안 실행됨
				System.out.println("작업 실행 중...");
				try {
					Thread.sleep(500);
				} catch(Exception e) {}
				System.out.println("작업 종료.");
			}
		});
		
		worker.start();
		Thread.sleep(2000); // 2초 후
		
		System.out.println("작업을 중지합시다.");
		running = false; // 다른 스레드에서 변경된 값이 즉시 반영됨
		worker.join();
	}
}
```

- 이 코드에서는 `volatile`을 사용하면 `running` 값이 변경되었을 때 모든 스레드에서 즉시 반영된다.
- 단순한 플래그 값 변경이므로 `volatile`이 적절한 경우이다.

### 🔑 핵심 포인트
- `volatile`은 단순한 변수 값 공유에는 적합하지만, 값을 읽고 변경하는 복합 연산에는 안전하지 않음
- 복합 연산이 필요하면 `synchronized`나 **Lock**, **AtomicInteger** 등을 사용해야 함