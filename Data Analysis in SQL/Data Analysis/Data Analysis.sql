USE copang_main;

-- 테이블의 총 row 개수 구하기
SELECT COUNT(*) FROM `member`;
SELECT COUNT(email) FROM `member`;
SELECT COUNT(height) FROM `member`; -- NULL 값은 제외하고 count
SELECT COUNT(id) FROM `member`; -- PrimaryKey

-- 집계 함수(Aggregate Function)
SELECT MAX(weight) FROM `member`;
SELECT MIN(weight) FROM `member`;
SELECT SUM(weight) FROM `member`; -- NULL 값은 제외하고 합
SELECT AVG(weight) FROM `member`; -- NULL 값은 제외하고 평균
SELECT STD(weight) FROM `member`; -- NUKK 값은 제외하고 표준편차

-- 산술 함수(Mathematical Function)
SELECT ABS(height) FROM `member`; -- 절대값
SELECT SQRT(height) FROM `member`; -- 제곱근
SELECT CEIL(height) FROM `member`; -- 올림
SELECT FLOOR(height) FROM `member`; -- 내림

-- NULL
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

-- double check  
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


-- Outlier
SELECT AVG(age) FROM `member` WHERE age BETWEEN 5 AND 100;
SELECT * FROM `member` WHERE address NOT LIKE '%호';


-- Calcullate with columns
SELECT email, height, weight, weight / ((height/100) * (height/100)) FROM `member`; -- BMI지수 계산

-- alias(별명)
SELECT 
	email, 
	height AS 키, 
    weight AS 몸무게, 
    weight / ((height/100) * (height/100)) AS 'BMI'
FROM `member`;

-- 여러 컬럼값을 연결하기
SELECT 
	email, 
	CONCAT(height, 'cm', ', ', weight, 'kg') AS '키와 몸무게',
    weight / ((height/100) * (height/100)) AS 'BMI'
FROM `member`;

-- 검색 CASE 함수(Label Encoding)
SELECT
	email, 
	CONCAT(height, 'cm', ', ', weight, 'kg') AS '키와 몸무게',
    weight / ((height/100) * (height/100)) AS 'BMI',
	(CASE
		WHEN weight IS NULL OR height IS NULL THEN '비만 여부 알 수 없음'
		WHEN weight / ((height/100) * (height/100)) >= 25 THEN '과체중 또는 비만'
		WHEN weight / ((height/100) * (height/100)) >= 18.5
			AND weight / ((height/100) * (height/100)) < 25 THEN '정상'
		ELSE '저체중'
	END) AS 'obesity_check'
FROM `member`
ORDER BY obesity_check ASC;

-- 단순 CASE 함수
SELECT 
	email,
    (CASE age
        WHEN 29 THEN '스물아홉'
        WHEN 30 THEN '서른'
        ELSE age
    END) AS '29 or 30'
FROM `member`;


-- 고유값 함수 DISTINCT
SELECT DISTINCT(gender) FROM `member`;
SELECT DISTINCT(SUBSTRING(address, 1, 2)) FROM `member`; -- 첫번째 문자부터 2개
-- 고유값 개수
SELECT COUNT(DISTINCT(gender)) FROM `member`;
SELECT COUNT(DISTINCT(SUBSTRING(address, 1, 2))) AS region_count FROM `member`;


-- 문자열 함수
SELECT address, LENGTH(address) FROM `member`; -- 문자열 길이
SELECT email, UPPER(email) FROM `member`; -- 문자열 대문자화
SELECT email, LOWER(email) FROM `member`; -- 문자열 소문자화
SELECT age, LPAD(age, 10, '0') FROM `member`; -- 왼쪽에 문자 0을 채워 10자리로
SELECT age, RPAD(age, 10, '0') FROM `member`; -- 오른쪽에 문자 0을 채워 10자리로
-- 문자열 좌우 공백 제거
-- SELECT LTRIM(word) FROM trim_test;
-- SELECT RTRIM(word) FROM trim_test;
-- SELECT TRIM(word) FROM trim_test;
