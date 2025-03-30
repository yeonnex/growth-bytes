
- ## **파이썬 모듈 경로 이해**
	- 파이썬은  `sys.path` 변수에서 모듈의 위치를 검색
	- ![[Pasted image 20250326161932.png]]
	- `sys.path`에 값을 추가하는 방법?
		- 1. 명시적으로 추가
			- `sys.path.append('/home/yeonnex')`
		- 2. OS 환경변수 PYTHONPATH 에 값을 추가
		- 그러나 위 두 방법은 상당히 번거롭다.
		- 그렇다면?
		- 3. **Airflow는 자동적으로 dags 폴더와 plugins 폴더를 `sys.path`에 추가해준다!**
	- airflow 가 실행중인 컨테이너 터미널에서 `$ airflow info` 를 호출해보자.
		![[Pasted image 20250326163514.png]]
## **파이썬 데코레이터**

	- 데코레이터(Decorator): 장식하다, 꾸미다
	- What? 함수를 장식!
	- 원래의 함수를 감싸서 바깥에 추가 기능을 덧붙이는 방법
	- 함수를 감싼다?
		- 파이썬은 함수 안에 함수를 선언하는 것이 가능하고,
		- 함수의 인자로 함수를 전달하는 것이 가능하며,
		- 함수 자체를 리턴하는 것이 가능하다.
```python
def outer_func(target_func):
	def inner_func():
		print('target 함수 실행 전 입니다.')
		target_func()
		print('target 함수 실행 후 입니다.')
	return inner_func


def get_data():
	print('함수를 시작합니다')

a = outer_func(get_data)

a()
```

**데코레이터를 쓴다면?**

```python
def outer_func(target_func):

	def inner_func():
		print('target 함수 실행 전 입니다')
		target_func()
		print('target 함수 실행 후 입니다')
	
	return inner_func

@outer_func
def get_data()
	print('func 함수를 시작합니다.')
```

### Task 데코레이터

- 파이썬 함수 정의만으로 쉽게 task 생성!

**AS-IS**
```python
def python_func1():
	...

py_task_1 = PythonOperator(
	task_id = "py_task_1",
	python_callable=python_func_1
)
```

**TO_BE**
```python

@task(task_id = 'py_task_1')
def python_func1():
	...

py_task_1 = python_func()
```

**TO_BE** 에서는 PythonOperator 를 가져올 필요도 없이 훨씬 간결하게 task 를 선언할 수 있는 것을 볼 수 있다.

## **파이썬 함수 파라미터**

- 파이썬 함수 인자 `*arg`
- 파이썬 함수 인자 `**kwargs`
