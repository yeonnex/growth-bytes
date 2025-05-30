<!-- Date: 2025-01-23 -->
<!-- Update Date: 2025-01-24 -->
<!-- File ID: 39601548-9556-46dc-8a4a-f784cc7a8dc0 -->
<!-- Author: Seoyeon Jang -->

# 개요

WHERE 구를 설명할 때, 벤다이어그램을 사용한 집합 연산이라고 이야기했다. 이는 그냥 예로 들었던 것인데, SQL에는 정말로 테이블을 사용해 집합 연산을 하는 기능이 있다. address 테이블과 address2
테이블로 알아보자.

## **UNION**으로 합집합 구하기

집합 연산의 기본은 합집합과 교집합이다. WHERE 구에서는 합집합을 OR가, 교집합은 AND가 담당했었다. 하지만 집합 연산에서는 연산자가 다르다. address 테이블과 address2 테이블의 합집합을 구할
때는 UNION이라는 연산자를 사용한다.

```sql
select *
from address
UNION
select *
from address2;
```

결과를 보면, 총 13개의 레코드가 나온다. address 테이블에는 9개의 레코드가 있고, address2 테이블에는 6개의 레코드가 있다. 따라서 두 테이블을 합치면 15개의 레코드가 나와야 하는데 13개가
나오는 이유는 양쪽 테이블에 중복해서 존재하는 인성과 민의 중복을 없앴기 때문이다. 인성과 민은 모든 필드에 같은 값이 들어있으므로 완전히 중복된 레코드이다. UNION 은 합집합을 구할 때 이렇게 중복된 레코드를
제거한다. 이는 UNION만 그런게 아니라 이후에 살펴볼 INTERSECT 와 EXCEPT 등에서도 같다. 만약 중복을 제외하고 싶지 않다면 UNION ALL 처럼 ALL 옵션을 붙이면 된다.

## **INTERSECT**로 교집합 구하기

이어서 AND 에 해당하는 교집합을 구해보자. 교집합을 구할 때 사용하는 연산자는 INTERSECT로 '교차'라는 의미이다.

```sql
select *
from address intersect
select *
from address2;
```

양쪽 테이블에 공통으로 존재하는 레코드를 출력하므로 인성과 민만 출력된다. 이전과 마찬가지로 중복된 것이 있다면 해당 레코드는 제외된다는 것을 기억하자.

## **EXCEPT**로 차집합 구하기

마지막으로 소개할 연산자는 차집합을 수행하는 EXCEPT 연산자이다.

```sql
select *
from address except
select *
from address2;
```

이를 수식으로 나타내면 'address - address2' 가 된다. 결과적으로 address 테이블에서 인성과 민이라는 두개의 레코드가 제거된 결과를 얻을 수 있다.

이때 EXCEPT에는 UNION과 INTERSECT 에는 없는 주의사항이 있다. UNION과 INTERSECT 는 어떤 테이블을 먼저 적든 그 순서와 상관없이 결과가 같다. 하지만 EXCEPT는 다르다.

이는 숫자의 사칙연산과 같은 성질이다. 덧셈 연산은 '1+5'와 '5+1'의 결과가 같다. 즉 교환법칙이 성립한다. 그러나 뺄셈 연산은 '1-5'와 '5-1'의 결과가 다르다. 교환법칙이 성립하지 않기 때문이다.

# 정리


