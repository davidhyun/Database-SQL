# SELECT & WHERE

- member 테이블명은 예약어(reserved words)이기 때문에 ``로 감싸주면 된다.

- 문자열 매칭 `LIKE`
  - `%` : 임의의 길이를 가진 문자열(0자도 포함)
  - `_` : 문자 하나
  
- `AND`가 `OR`보다 우선순위가 높기 때문에 먼저 실행되기 때문에 괄호()로 묶어주어 실행순서를 명시해야한다.

- **Escaping Problem**

  - `%`, `''`, `""`, `_` 등과 같은 문자열과 `%`, `_` 등의 표현식을 구분해줘야한다.
  - 그 방법으로 표현식 앞에 `\`을 사용하여 문자열로 해석되도록 한다. 

  ```mysql
  -- Escaping Problem
  SELECT * FROM `test` WHERE sentence LIKE '%\%%';
  SELECT * FROM `test` WHERE sentence LIKE '%\'%';
  SELECT * FROM `test` WHERE sentence LIKE '%\_%';
  SELECT * FROM `test` WHERE sentence LIKE '%\"%\"%';
  ```

- 대소문자 구분

  <img src="https://user-images.githubusercontent.com/64063767/110233833-14f82600-7f6a-11eb-9e17-ad0020d3b9e6.png" alt="image" style="zoom:50%;" />

  - 테이블 기본설정의 `Table collation`을 보면  `utf8mb4_0900_ai_ci`로 설정되어 있다. 여기서 ci는 `case-insensitive`로 대소문자를 구분하지 않겠다는 뜻이다.
  - 이 때 `BINARY`를 활용하여 대소문자를 구분할 수 있다.

  ```mysql
  SELECT * FROM test WHERE sentence LIKE BINARY '%g%';
  SELECT * FROM test WHERE sentence LIKE BINARY '%G%';
  ```

---

```mysql
-- 사용할 DB 선언
USE copang_main;

-- member 테이블로부터 WHERE 조건이 참인 모든 열(*)을 조회
SELECT * FROM `member`;
SELECT * FROM `member` WHERE email = 'taehos@hanmail.net';
SELECT * FROM `member` WHERE age >= 27;
SELECT * FROM `member` WHERE age BETWEEN 30 AND 39;
SELECT * FROM `member` WHERE age NOT BETWEEN 30 AND 39;
SELECT * FROM `member` WHERE sign_up_day > '2019-01-01';
SELECT * FROM `member` WHERE sign_up_day BETWEEN '2018-01-01' AND '2018-12-31';
-- 주소에 서울이 포함된 행의 모든 열 조회
SELECT * FROM `member` WHERE address LIKE '%서울%';
SELECT * FROM `member` WHERE gender != 'm';
-- 여러 값들 중 해당하는 값이 있는 행의 모든 열 조회
SELECT * FROM `member` WHERE age IN (20, 30);
-- c로 시작하고 다섯글자가 있는 행의 모든 열 조회
SELECT * FROM `member` WHERE email LIKE 'c_____@%';
-- ID가 짝수인 CITY 열을 중복없이 조회
SELECT DISTINCT(CITY) FROM STATION WHERE ID % 2 = 0;

SELECT * FROM `member` 
WHERE gender = 'm' 
	AND address LIKE '서울%' 
	AND age BETWEEN 25 AND 29;
	
SELECT * FROM `member` 
WHERE MONTH(sign_up_day) BETWEEN 3 AND 5 
	OR MONTH(sign_up_day) BETWEEN 9 AND 11;
	
SELECT * FROM `member`
WHERE (gender = 'm' AND height >= 180)
	OR (gender = 'f' AND height >= 170);
```



# DATE type 관련 함수

```mysql
SELECT * FROM `member` WHERE YEAR(birthday) = '1992';
SELECT * FROM `member` WHERE MONTH(sign_up_day) IN (6, 7, 8);
SELECT * FROM `member` WHERE DAYOFMONTH(sign_up_day) BETWEEN 15 AND 31;

SELECT email, sign_up_day, DATEDIFF(sign_up_day, '2019-01-01') FROM `member`;
SELECT email, sign_up_day, CURDATE(), DATEDIFF(sign_up_day, CURDATE()) AS datediff FROM `member`;
SELECT email, sign_up_day, DATEDIFF(sign_up_day, birthday) / 365 AS sign_up_age FROM `member`;
SELECT email, sign_up_day, DATE_ADD(sign_up_day, INTERVAL 300 DAY) AS after_300days FROM `member`;
SELECT email, sign_up_day, DATE_SUB(sign_up_day, INTERVAL 300 DAY) AS before_300daysFROM `member`;
SELECT email, sign_up_day, UNIX_TIMESTAMP(sign_up_day) FROM `member`; -- 1970년 1월 1일 기준으로 총 지난 시간(초)
SELECT email, sign_up_day, FROM_UNIXTIME(UNIX_TIMESTAMP(sign_up_day)) FROM `member`;
SELECT sign_up_day, SYSDATE(),  CURDATE(), CURTIME() FROM `member`;
```



#  ORDER BY 정렬

> 특정 컬럼을 기준으로  row들을 순서대로 정렬

- 같은 값처럼 보여도 데이터 타입이 다르면 정렬이 달라질 수 있다.

  - 숫자형(INT)은 숫자의 크기 기준으로 정렬
  - 문자열형(TEXT)은 한 문자씩 문자 순서를 비교해서 정렬

  - `CAST()` : 문자열형(TEXT) 숫자값들의 데이터 타입을 일시적으로 변경해주는 함수

  | Type           | ORDER BY         |
  | -------------- | ---------------- |
  | 숫자형(INT)    | 19, 27, 120, 230 |
  | 문자열형(TEXT) | 120, 19, 230, 27 |

  ```mysql
  -- signed는 정수값을 나타낼 수 있는 데이터 타입
  SELECT * FROM sales ORDER BY CAST(registration_num AS signed) ASC;
  -- decimal은 실수값을 나타낼 수 있는 데이터 타입
  SELECT * FROM sales ORDER BY CAST(registration_num AS decimal) ASC;
  ```

  

```mysql
SELECT * FROM `member` ORDER BY height ASC;
SELECT * FROM `member` ORDER BY height DESC;
SELECT * FROM `member` WHERE gender = 'm' AND weight >= 70 ORDER BY height ASC;
SELECT sign_up_day, email FROM `member` ORDER BY YEAR(sign_up_day) DESC, email ASC;

-- 데이터 일부만 추려보기
SELECT * FROM `member` ORDER BY sign_up_day DESC LIMIT 10;
SELECT * FROM `member` ORDER BY sign_up_day DESC LIMIT 8, 2; -- 9번째부터 2개의 행만 추출
```

