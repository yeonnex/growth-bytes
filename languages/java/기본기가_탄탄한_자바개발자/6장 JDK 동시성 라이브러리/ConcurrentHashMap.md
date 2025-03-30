
`ConcurrentHashMap` 클래스는 표준 `HashMap`의 동시성 버전을 제공한다. 일반적으로 맵은 동시 애플리케이션을 구축하는 데 매우 유용한, 그리고 일반적인 데이터 구조다.

### 간단하게 HashMap 이해하기

고전적인 자바의 `HashMap`은 해시 함수를 사용해 키-값 쌍을 저장할 **버킷**을 결정한다. 클래스 이름의 '해시' 부분은 여기에서 유래했다.

이 책의 깃헙 프로젝트에는 `Map<String, String>`을 단순화한 구현인 `Dictionary` 클래스가 있다. 이 클래스는 실제로 자바 7의 일부로 제공된 `HashMap`의 형태를 기반으로 한다.

>최신 자바 버전은 훨씬 더 복잡한 `HashMap`구현을 제공한다.

기본 클래스에는 다음과 같이 기본 데이터 구조와 성능상의 이유로 맵의 크기를 캐시하는 `size` 필드, 이렇게 두가지 필드만 있다.


```java
public class Dictionary implements Map<String, String> {
	private Node[] table = new Node[8];
	private int size;

	@Override
	public int size() {
		return this.size;
	}
	
	@Override
	public boolean isEmpty() {
		return size == 0;
	}
}
```

이것은 `Node` 라는 도우미 클래스에 의존한다. `Node` 클래스는 키-값 쌍을 나타내고 다음과 같이 `Map.Entry` 인터페이스를 구현한다.

```java
static class Node implements Map.Entry<String, String> {

	final int hash;
	final String key;
	String value;
	Node next;
	
	Node(int hash, String key, String value, Node next) {
		this.hash = hash;
		this.key = key;
		this.value = value;
		this.next = next;
	}
	
	public final int hashCode() {
		return Objects.hashCode(key) ^ Objects.hashCode(value);
	}
	
	public final String setValue(String newValue) {
		String oldValue = value;
		value = newValue;
		return oldValue;
	}
	
	public final boolean equals(Object o) {
		if (o == this) return true;
		if (o instanceof Node) {
			Node e = (Node) o;
			if (Objects.equals(key, e.getKey() && Objects.equals(value, e.getValue()))) {
				return true;
			}
			
		}
		return false;
	}
	
}
```


맵에서 값을 찾기 위해 다음과 같이 두 개의 도우미 메서드인 `hash()`와 `indexFor()`에 의존하는 `get()` 메서드를 사용한다.

```java

@Override
public String get(Object key) {

	if (key == null) return null;
	int hash = hash(key);
	for (Node e = table[indexFor(hash, table.length)]; e!= null; e= e.next) {
		...
	}
}
```


현재로서는 `Dictionary`가 스레드에 안전하지 않은 것은 분명하다. 특정 키를 삭제하려는 스레드와 해당 키와 연관된 값을 업데이트하려는 스레드, 이렇게 두가지를 생각해보자.

문제를 해결하기 위해 상대적으로 명백한 두가지 방법이 있다.

첫번째는 완전 동기화 접근법이다. `synchronized` 키워드를 사용하는 것이다. 그러나 이 접근 방식은 성능 오버헤드 때문에 대부분의 실제 시스템에서는 실행할 수 없다.

여기에는 또 두 가지 방법이 있다. 첫번째 방법은 `Dictionary` 클래스를 복사하여 `ThreadSafeDictionary` 라고 명명한 후 모든 메서드를 `synchronized`로 만드는 것이다. 이 방법은 동작하지만 중복된 코드를 많이 생성해야 한다.

또는 동기화된 래퍼를 사용하여 실제로 사전을 보유한 하위 객체에 대해 위임 또는 전달을 제공할 수 있다.

```java
public final class SynchronizedDictionary extends Dictionary {
	
	private final Dictionary d;
	
	private SynchronizedDictionary(Dictionary delegate) {
		d = delegate;
	}
	
	public static SynchronizedDictionary of(Dictionary delegate) {
		return new SynchronizedDictionary(delegate);
	}
	
	@Override
	public synchronized int size() {
		return d.size();
	}
	
	@Override
	public synchronized boolean isEmpty() {
		return d.isEmpty();
	}
	
	// ... 다른 메서드들
}
```

근데 이 예제에는 몇가지 문제가 있다. 가장 중요한 문제는 이미 존재하는 객체 `d` 가 동기화되지 않았다는 점이다. 이렇게 되면 다른 코드가 `synchronized` 블록이나 메서드 외부에서 `d`를 수정할 수 있기 때문이다.

사실 JDK는 이러한 구현, 즉 `Collections` 클래스에 제공되는 `synchronizedMap()` 메서드를 제공한다. 

```java
Map<String, String> original = new HashMap<>();
Map<String, String> syncMap = Collections.synchronizedMap(original);
```

`synchMap`을 사용하면 모든 메서드가 `synchronized`가 된 채로 작동하게 되어 스레드에 안전해진다. 하지만 이 또한 원본 `original` 맵을 수정하면 동기화가 깨진다는 위험성이 있다.

두번째 접근방식은 불변성을 활용하는 것이다. 자바 Collections 는 크고 복잡한 인터페이스이다. 가변성은 자바 Collections 의 전반에 녹아있는 가정 중 하나다. 어떤 구현이 구현할지 말지 분리할 수 있는 문제가 아니며, `Map`과 `List`의 모든 구현은 인터페이스가 정의한 모든 메서드를 구현해야 한다.

이러한 제한 때문에 자바에서 자바 Collections API 를 준수하면서 변경할 수 없는(immutable) 데이터 구조를 모델링할 방법이 없는 것처럼 보일 수 있다. 즉 API를 준수하는 경우, 클래스는 가변성을 가진 메서드의 구현도 제공해야 한다는 뜻이다. 물론 이 문제를 해결하기 위한 만족스럽지 않은 편법이 존재한다. 인터페이스의 구현체는 특정 메서드를 구현하지 않았을 경우 `UnsupportedOperationException`을 던질 수 있다. 이것은 언어 설계 관점에서는 좋지 않은 방법이다. 인터페이스의 게약은 예외없이 지켜져야 한다.

안타깝게도 자바 8 이전에 `UnsupportedOperationException`을 사용하는 관례가 있었으며(디폴트 메서드의 도입 전), 자바 언어에서 실제로 그러한 구분이 없을 때 필수 메서드와 선택적 메서드를 구분하려는 시도로 나타났다. 그러나 `UnsupportedOperationException`은 런타임예외이기 때문에 사용하기에는 적절하지 않다.

## ConcurrentHashMap 사용하기

`ConcurrentHashMap`의 핵심은 여러 스레드가 한 번에 업데이트해도 안전하다는 것이다. 대부분의 경우 `HashMap`과 대체하여 사용할 수 있다.

두 개의 스레드가 동시에 `HashMap` 에 항목을 추가할 때 보통 업데이트 손실이 나타나게 된다.

반면 `HashMap`을 `ConcurrentHashMap` 으로 바꾸면 제대로 잘 동작하는 것을 볼 수 있다. 즉 업데이트 손실이 발생하지 않는 것이다.

이것을 어떻게 달성하는지 살펴보자면, 다음과 같은 통찰력이 기반이다. 

>변경할 때 전체 구조를 잠글 필요없이 변경하거나 읽는 해시 체인(일명 버킷)만 잠그면 된다.

![[Pasted image 20250317124805.png]]

물론 두 개의 스레드가 동일한 체인에서 작동해야하는 경우에는 여전히 서로를 배제하지만, 일반적으로 **전체 맵을 동기화하는 것보다 처리량이 좋다.**
