<!-- Date: 2025-02-16 -->
<!-- Update Date: 2025-02-16 -->
<!-- File ID: 1c03c7fb-3e59-4a55-9b98-163f8ebc913a -->
<!-- Author: Seoyeon Jang -->

# 📌 개념

handleInput 함수는 다섯줄 규칙 제한을 지키지 않는다.

```typescript
function handleInput(input: Input) {
    if (input === Input.LEFT) moveHorizontal(-1);
    else if (input === Input.Right) moveHorizontal(1);
    else if (input === Input.UP) moveVertical(-1);
    else if (input === Input.DOWN) moveVertial(1);
}
```

# 규칙 적용

handleInput 에서 if-else 를 제거하는 첫번째 단계는 Input을 열거형(enum)에서 인터페이스(interface)로 바꾸는 것이다. 그러면 **값들은 클래스로 바뀐다.** 마지막으로, 값이 이제
객체가 되었기 때문에 **if 구문 내의 코드를 각 클래스의 메서드로 옮길 수 있다.** 
