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

1. COALESCE 함수
2. IFNULL 함수
3. IF 함수
4. CASE 함수

```mysql
SELECT * FROM `member` WHERE address IS NULL;
SELECT * FROM `member` WHERE address IS NOT NULL;

SELECT * FROM `member`
WHERE height IS NULL
	OR weight IS NULL
	OR address IS NULL;

-- COALESCE 함수
SELECT 
	COALESCE(height, '####') AS 'NULL(####)',
	COALESCE(weight, '----') AS 'NULL(----)',
	COALESCE(address, '@@@@') AS 'NULL(@@@@)'
FROM `member`;

-- height에만 NULL 값이 있고 weight에는 값이 있다면 
-- height 값에 (weight *2.3) 값을 넣고 
-- height, weight열 모두 NULL값이면 'N/A'
SELECT COALESCE(height, weight * 2.3, 'N/A') AS 'NULL_check' FROM `member`;

-- IFNULL 함수(MySQL)
SELECT IFNULL(height, 'N/A') AS 'NULL_check' FROM `member`;

-- IF 함수
-- IF(조건식, True일 경우, False일 경우)
SELECT IF(height IS NOT NULL, height, 'N/A') AS 'NULL_check' FROM `member`;

-- CASE 함수
SELECT
	(CASE
     	WHEN height IS NOT NULL THEN height
     	ELSE 'N/A'
     END) AS 'NULL_check'
FROM `member`;
```

<br/>

# Outlier

```mysql
SELECT AVG(age) FROM `member` WHERE age BETWEEN 5 AND 100;
SELECT * FROM `member` WHERE address NOT LIKE '%호';
```

<br/>

# Calculate with columns

- NULL이 포함된 계산식의 결과는 항상 NULL

```mysql
-- BMI지수 계산
SELECT email, height, weight, weight / ((height/100) * (height/100)) FROM `member`;

-- AS, alias(별명) 
SELECT 
	email, 
	height AS 키, 
    weight AS 몸무게, 
    weight / ((height/100) * (height/100)) AS BMI
FROM `member`;

-- 여러 컬럼값을 연결하기
SELECT 
	email, 
	CONCAT(height, 'cm', ', ', weight, 'kg') AS '키와 몸무게',
    weight / ((height/100) * (height/100)) AS BMI
FROM `member`;
```

<br/>

# CASE 함수

### 1. 단순 CASE 함수

```mysql
SELECT 
	email,
    CASE age
        WHEN 29 THEN '스물아홉'
        WHEN 30 THEN '서른'
        ELSE age
    END
FROM `member`;
```

<br/>

### 2. 검색 CASE 함수

```mysql
SELECT
	email, 
	CONCAT(height, 'cm', ', ', weight, 'kg') AS '키와 몸무게',
    weight / ((height/100) * (height/100)) AS BMI,
	(CASE
		WHEN weight IS NULL OR height IS NULL THEN '비만 여부 알 수 없음'
		WHEN weight / ((height/100) * (height/100)) >= 25 THEN '과체중 또는 비만'
		WHEN weight / ((height/100) * (height/100)) >= 18.5
			AND weight / ((height/100) * (height/100)) < 25 THEN '정상'
		ELSE '저체중'
	END) AS obesity_check
FROM `member`
ORDER BY obesity_check ASC;
```

<br/>

# 고유값 함수 DISTINCT

```mysql
SELECT DISTINCT(gender) FROM `member`;
SELECT DISTINCT(SUBSTRING(address, 1, 2)) FROM `member`; -- 첫번째 문자부터 2개
SELECT COUNT(DISTINCT(gender)) FROM `member`; -- 고유값 개수
SELECT COUNT(DISTINCT(SUBSTRING(address, 1, 2))) AS region_count FROM `member`; -- 고유값 개수
```

<br/>

# 문자열 함수

- LENGTH()

  > 문자열 길이를 구해주는 함수

  ```mysql
  SELECT *, LENGTH(address) FROM `member`;
  ```

- UPPER(), LOWER()

  > 문자열을 모두 대/소문자로 바꿔주는 함수

  ```mysql
  SELECT email, UPPER(email) FROM `member`;
  ```

- LAPD(), RAPD()

  > 문자열의 왼쪽/오른쪽을 특정 문자열로 채워주는 함수

  ```mysql
  SELECT email, LAPD(age, 10, '0') FROM `member`;
  ```

- TRIM(), LTRIM(), RTRIM()

  > 