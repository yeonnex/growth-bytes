자바는 초창기(자바 1.0)부터 `volatile` 키워드를 사용해왔으며, 원시 요소를 포함한 객체 필드의 동시성 처리를 하는 간단한 방법으로 사용됐다. 다음 규칙이 `volatile` 필드에 적용된다.

- 스레드가 보는 값은 사용하기 전에 항상 주 메모리에서 다시 읽는다.
- 바이트코드 명령이 완료되기 전에 스레드가 쓴 모든 값은 항상 주 메모리로 플러시된다.

>이걸 쉽게 풀어보면, `volatile` 키워드는 화이트보드(메인 메모리)를 강제로 참고하게 만드는 기능이라고 볼 수 있다.
>
>**설명을 위한 비유:**
>여러 명의 개발자가 같은 화이트보드(메인 메모리)를 공유한다고 해보자. 각 개발자(A, B)는 자기 책상 위 메모지(캐시)에도 정보를 적을 수 있다. 보통 개발자는 화이트보드를 안 보고 자기 메모지만 참고하면서 작업한다. 하지만 `volatile` 을 사용하면?
>
>→ 항상 화이트보드(메인 메모리)에서 최신 정보를 가져오고, 수정한 내용도 즉시 반영해야 한다!


## 코드로 이해하기

### `volatile`없이 문제가 발생하는 경우

```java  
public class VolatileTest {  
  
  
    static class SharedData {  
        int flag = 0; // 화이트보드(메인메모리)  
    }  
  
    static class Worker extends Thread {  
  
        private SharedData data;  
  
  
        Worker(SharedData data) {  
            this.data = data;  
        }  
        @Override  
        public void run() {  
            while (data.flag == 0) { // 캐시된 값만 보고 반복  
                // 작업을 계속함  
            }  
      // 여기까지 도달할 수 없음  
      System.out.println("flag 가 1로 변경됨! 종료!");  
    }  }  
  
  public static void main(String[] args) throws InterruptedException {  
      SharedData data = new SharedData();  
      Worker worker = new Worker(data);  
  
      worker.start();  
  
      Thread.sleep(1000); // 1초 후 값 변경  
  
      data.flag = 1; // 메인 메모리에 반영되지 않을 수도 있음!  
  
      System.out.println("flag 를 1로 변경함");  
  
  }  
}
```

### 🚨 예상 문제
- `flag = 1`로 설정했지만, 다른 스레드(Worker)가 화이트보드를 안보고 자기 캐시만 참고해서 값이 변하지 않는 것처럼 보일 수 있음
- 따라서 `while (data.flat == 0)`에서 무한 루프가 발생

### ✅ `volatile`을 사용한 해결 방법
```java
class SharedData {
	volatile int flag = 0; // 화이트보드(메인 메모리) 강제 사용
}

class Worker extends Thread {
	private SharedData data;

	Worker(SharedData data) {
		this.data = data;
	}

	@Override
	public void run() {
		while(data.flag == 0) {
			// 메인 메모리에서 항상 최신 값을 읽음	
		}
		System.out.println("flag 가 1로 변경됨! 종료");
	}
}

public class VolatileTest {
	public static void main(String[] args) throws InterruptedException {
		SharedData data = new SharedData();
		Worker worker = new Workder(data);
		
		worker.start();
		
		Thread.sleep(1000);
		
		// 즉시 메인 메모리에 반영됨
		data.flag = 1;
		
		System.out.println("flag를 1로 변경");
	}
}
```

### 👍 해결됨!
- `volatile`을 사용하면 `flag`가 항상 메인 메모리에서 읽히고, 변경 즉시 반영됨.
- 따라서 `while(data.flag == 0)`이 값이 변하는 걸 바로 감지하고 루프를 빠져나올 수 있음.

### 📌 결론

| 키워드        | 캐시 사용 여부         | 메인 메모리 즉시 업데이트 | 언제 유용한가?          |
| ---------- | ---------------- | -------------- | ----------------- |
| 일반 변수      | ✅ (캐시 사용)        | ❌ (바로 반영 안됨)   | 동기화 필요 없는 경우      |
| `volatile` | ❌ (항상 메인 메모리 참고) | ✅ (바로 반영됨)     | 플래그 체크 같은 간단한 동기화 |
즉, `volatile`을 사용하면 화이트보드를 강제 참고하게 만들기 때문에 최신 정보를 놓치지 않게 된다!