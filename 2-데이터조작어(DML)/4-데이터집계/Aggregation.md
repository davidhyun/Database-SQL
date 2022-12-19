# 집계 함수(Aggregate Function)

> 집계 함수는 특정 컬럼의 여러 row의 값들을 동시에 고려해서 실행되는 함수
>
> NULL값은 제외하고 집계

- `COUNT()` : 개수
- `MAX()` : 최댓값
- `MIN()` : 최솟값
- `SUM()` : 합
- `AVG()` : 평균값
- `STD()` : 표준편차

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

- `ABS()` : 절대값
- `SQRT()` : 제곱근
- `CEIL()` : 올림
- `FLOOR()` : 내림
- `ROUND()` : 반올림

```mysql
SELECT ABS(height) FROM `member`; -- 절대값
SELECT SQRT(height) FROM `member`; -- 제곱근
SELECT CEIL(height) FROM `member`; -- 올림
SELECT FLOOR(height) FROM `member`; -- 내림
```

<br/>

# NULL

> `IS NULL`과 `= NULL`을 혼동하지 말아야한다. NULL은 숫자가 아니기 때문에 값과 비교할 수 없다.
>
> NULL에는 어떤 연산을 해도 결국 NULL이다.

- `COALESCE()`

- `IFNULL()`

- `IF()`

- `CASE()`

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

-- 고유값 개수
SELECT COUNT(DISTINCT(gender)) FROM `member`;
SELECT COUNT(DISTINCT(SUBSTRING(address, 1, 2))) AS region_count FROM `member`;
```

<br/>

# 문자열 함수

- `LENGTH()`

  > 문자열 길이를 구해주는 함수

  ```mysql
  SELECT address, LENGTH(address) FROM `member`;
  ```

- `UPPER()`, `LOWER()`

  > 문자열을 모두 대/소문자로 바꿔주는 함수

  ```mysql
  SELECT email, UPPER(email) FROM `member`;
  ```

- `LPAD()`, `RPAD()`

  > 문자열의 왼쪽/오른쪽을 특정 문자열로 채워주는 함수
  >
  > column type이 숫자이더라도 자동으로 문자열로 형변환되어 함수가 적용된다.

  ```mysql
  -- age 컬럼의 값 왼쪽에 문자 0을 붙여서 총 10자리로 만드는 함수
  SELECT age, LPAD(age, 10, '0') FROM `member`;
  ```

- `TRIM()`, `LTRIM()`, `RTRIM()`

  > 문자열 좌우에 존재하는 공백을 제거하는 함수(문자열 내부 공백은 제거X)
  
  ```mysql
  SELECT LTRIM(word) FROM trim_test;
  SELECT RTRIM(word) FROM trim_test;
  SELECT TRIM(word) FROM trim_test;
  ```

<br/>

# GROUP BY

<img src="https://user-images.githubusercontent.com/64063767/111066203-0fb65080-8501-11eb-979b-14b3a1e52a85.png" alt="image" style="zoom: 33%;" />

> 집계함수(Aggregate function)는 그룹별로 적용되어 결과값을 보여준다. (COUNT, AVG, MIN)
>
> ---
>
> `WHERE` VS `HAVING`
>
> 조건을 걸어 조회한다는 의미는 비슷하지만,
>
> `WHERE`는 테이블에서 맨처음 row들을 조회할 때 조건을 설정하기 위한 구문이다.
>
> `HAVING`은 이미 조회된 row들을 그루핑했을 때 생성된 그룹들 중에서 다시 필터링을 할 때 쓰는 구문이다.
>
> ---
>
> `GROUP BY`를 사용할 때는 `SELECT` 절에 `GROUP BY` 뒤에서 사용한 컬럼이거나 그 컬럼들에 대한 집계함수만 사용할 수 있다. 그루핑 기준으로 사용되지 않은 컬럼(nonaggregated column)은 SELECT 절에 존재하면 안된다는 뜻이다.
>
> `Error Code: 1055. Expression #3 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'copang_main.member.age' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by`
>
> `SELECT` 절 뒤에 age 컬럼을 바로 쓰는건 안되지만, AVG(age)처럼 **집계 함수의 인자로 사용하는 것은 허용**된다.  각 그룹에서 특정 row의 age 값을 보여주는 것이 아니라 각 그룹 내 모든 row들의 age 컬럼 값의 평균을 구하면 되기 때문이다.
>
> ---
>
> `GROUP BY` 뒤에 **기준들의 등장 순서에 따라** `WITH ROLLUP`의 결과도 달라진다.  
>
> 그루핑 기준이 여러개 일 때는 `WITH ROLLUP`이 점차적으로 넓은 범위의 부분 총계를 보여준다.
>
> ---
>
> <img src="https://user-images.githubusercontent.com/64063767/111070044-341b2880-8513-11eb-8361-fa6f92b0032a.png" alt="image" style="zoom: 50%;" />
>
> `결측값을 나타내는 NULL` vs `부분 총계를 위한 NULL`
>
> 결측값 NULL과 부분총계임 NULL을 구분하기 위해 `GROUPING` 함수 활용
>
> 결측값 NULL이면 0, 부분총계 NULL은 1을 리턴해주는 함수

```mysql
-- 각 그룹에 속한 행들의 수(COUNT)와 각 그룹별 평균(AVG), 최소값(MIN)이 적용된다.
SELECT 
    gender, 
    COUNT(*), 
    AVG(height),
    MIN(weight)
FROM `member` 
GROUP BY gender;

-- 여러 컬럼을 기준으로 그룹화
SELECT 
    SUBSTRING(address, 1, 2) AS region,
    gender,
    COUNT(*)
FROM `member` 
GROUP BY SUBSTRING(address, 1, 2), gender;

-- 여러 그룹들 중 region 컬럼이 서울이고 gender가 남성인 것들만 조회
SELECT 
    SUBSTRING(address, 1, 2) AS region,
    gender,
    COUNT(*)
FROM `member` 
GROUP BY SUBSTRING(address, 1, 2), gender
HAVING region = '서울' AND gender = 'm';
	
-- region 컬럼에 값이 있는 그룹들만 정렬해서 조회
SELECT 
    SUBSTRING(address, 1, 2) AS region,
    gender,
    COUNT(*)
FROM `member` 
GROUP BY SUBSTRING(address, 1, 2), gender
HAVING region IS NOT NULL
ORDER BY region ASC, gender DESC;
    
-- ERROR
SELECT 
	SUBSTRING(address, 1, 2) AS region, 
	gender, 
	age, -- nonaggregated column
	COUNT(*) 
FROM `member`
GROUP BY SUBSTRING(address, 1, 2), gender
HAVING region IS NOT NULL
ORDER BY region ASC, gender DESC;

-- NOT ERROR
SELECT 
    SUBSTRING(address, 1, 2) AS region,
    gender,
    AVG(age), -- Available
    COUNT(*)
FROM `member` 
GROUP BY 
    SUBSTRING(address, 1, 2), 
    gender
HAVING region IS NOT NULL
ORDER BY region ASC, gender DESC;

-- 부분 총계 WITH ROLLUP
SELECT 
    SUBSTRING(address, 1, 2) AS region,
    gender,
    COUNT(*)
FROM `member` 
GROUP BY SUBSTRING(address, 1, 2), gender WITH ROLLUP -- 먼저 써준 region이 상위기준
HAVING region IS NOT NULL
ORDER BY region ASC, gender DESC;

SELECT 
	YEAR(birthday) AS b_year,
	YEAR(sign_up_day) AS s_year,
	gender,
	COUNT(*)
FROM `member`
GROUP BY YEAR(birthday), YEAR(sign_up_day), gender WITH ROLLUP
ORDER BY b_year DESC;

-- GROUPING(결측값 NULL과 부분총계 NULL 구분)
SELECT 
	YEAR(sign_up_day) AS s_year,
	gender,
    SUBSTRING(address, 1, 2) AS region,
    GROUPING(YEAR(sign_up_day)),
    GROUPING(gender),
    GROUPING(SUBSTRING(address, 1, 2)),
	COUNT(*)
FROM `member`
GROUP BY YEAR(sign_up_day), gender, SUBSTRING(address, 1, 2) WITH ROLLUP
ORDER BY s_year DESC;
```

<br/>

# SQL 문의 실행순서

| 작성 순서   | 해석 순서   |
| ----------- | ----------- |
| 1. SELECT   | 1. FROM     |
| 2. FROM     | 2. WHERE    |
| 3. WHERE    | 3. GROUP BY |
| 4. GROUP BY | 4. HAVING   |
| 5. HAVING   | 5. SELECT   |
| 6. ORDER BY | 6. ORDER BY |
| 7. LIMIT    | 7. LIMIT    |

> 1. `FROM` : 어느 테이블을 대상으로할 것인지를 먼저 결정한다.
> 2. `WHERE` : 해당 테이블에서 특정 조건들을 만족하는 row들만 선별한다.
> 3. `GROUP BY` : row들을 그루핑 기준대로 그루핑한다. 하나의 그룹은 하나의 row로 표현된다.
> 4. `HAVING` : 그루핑 작업 후 생성된 여러 그룹들 중에서, 즉정 조건들을 만족하는 그룹들만 선별한다.
> 5. `SELECT` : 모든 컬럼 또는 특정 컬럼들을 조회한다. SELECT 절에서 컬럼 이름에 alias를 붙인 것이 있다면, 이후 단계(ORDER BY, LIMIT)부터는 해당 alias를 사용할 수 있다.
> 6. `ORDER BY` : 각 row를 특정 기준에 따라서 정렬한다.
> 7. `LIMIT` : 이전 단계까지 조회된 row들 중 일부 row들만을 조회한다.