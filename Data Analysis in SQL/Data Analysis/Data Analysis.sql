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

-- NULL이면 두번째 인자값을 return
SELECT 
	COALESCE(height, '####'),
	COALESCE(weight, '----'),
	COALESCE(address, '@@@@')
FROM `member`;

-- Outlier
SELECT AVG(age) FROM `member` WHERE age BETWEEN 5 AND 100;
SELECT * FROM `member` WHERE address NOT LIKE '%호';