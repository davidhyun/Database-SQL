# 집계 함수(Aggregate Function)

> 집계 함수는 특정 컬럼의 여러 row의 값들을 동시에 고려해서 실행되는 함수
>
> NULL값은 제외하고 집계

- COUNT : 개수
- MAX : 최댓값
- MIN : 최솟값
- SUM : 합
- AVG : 평균값
- STD : 표준편차

```mysql
SELECT MAX(weight) FROM `member`;
SELECT MIN(weight) FROM `member`;
SELECT SUM(weight) FROM `member`;
SELECT AVG(weight) FROM `member`;
SELECT STD(weight) FROM `member`;
```

<br/>

# 산술 함수(Mathematical Function)

> 산술 함수는 특정 컬럼의 각 row의 값들에 대해 각각 실행될 뿐이다.

- ABS : 절대값
- SQRT : 제곱근
- CEIL : 올림
- FLOOR : 내림
- ROUND(반올림)

```mysql
SELECT ABS(height) FROM `member`; -- 절대값
SELECT SQRT(height) FROM `member`; -- 제곱근
SELECT CEIL(height) FROM `member`; -- 올림
SELECT FLOOR(height) FROM `member`; -- 내림
```

<br/>

# NULL

- `IS NULL`과 `= NULL`을 혼동하지 말아야한다. NULL은 숫자가 아니기 때문에 값과 비교할 수 없다.
- NULL에는 어떤 연산을 해도 결국 NULL이다.

```mysql
SELECT * FROM `member` WHERE address IS NULL;
SELECT * FROM `member` WHERE address IS NOT NULL;

SELECT * FROM `member`
WHERE height IS NULL
	OR weight IS NULL
	OR address IS NULL;

-- NULL이면 두번째 인자값을 return
SELECT 
	COALESCE(height, '####'),
	COALESCE(weight, '----'),
	COALESCE(address, '@@@@')
FROM `member`;
```

<br/>

# Outlier

```mysql
SELECT AVG(age) FROM `member` WHERE age BETWEEN 5 AND 100;
SELECT * FROM `member` WHERE address NOT LIKE '%호';
```

