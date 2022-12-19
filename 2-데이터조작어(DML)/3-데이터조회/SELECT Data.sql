USE copang_main;

SELECT * FROM `member`;
SELECT * FROM `member` WHERE email = 'taehos@hanmail.net';
SELECT * FROM `member` WHERE age >= 27;
SELECT * FROM `member` WHERE age BETWEEN 30 AND 39;
SELECT * FROM `member` WHERE age NOT BETWEEN 30 AND 39;
SELECT * FROM `member` WHERE sign_up_day > '2019-01-01';
SELECT * FROM `member` WHERE sign_up_day BETWEEN '2018-01-01' AND '2018-12-31';
SELECT * FROM `member` WHERE address LIKE '%서울%'; -- 주소에 서울이 포함된 행의 모든 열 조회
SELECT * FROM `member` WHERE gender != 'm';
SELECT * FROM `member` WHERE age IN (20, 30); -- 여러 값들 중 해당하는 값이 있는 행의 모든 열 조회
SELECT * FROM `member` WHERE email LIKE 'c_____@%'; -- c로 시작하고 다섯글자가 있는 행의 모든 열 조회

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


-- DATE type 관련 함수
SELECT * FROM `member` WHERE YEAR(birthday) = '1992';
SELECT * FROM `member` WHERE MONTH(sign_up_day) IN (6, 7, 8);
SELECT * FROM `member` WHERE DAYOFMONTH(sign_up_day) BETWEEN 15 AND 31;
SELECT email, sign_up_day, DATEDIFF(sign_up_day, '2019-01-01') FROM `member`;
SELECT email, sign_up_day, CURDATE(), DATEDIFF(sign_up_day, CURDATE()) AS datediff FROM `member`;
SELECT email, sign_up_day, DATEDIFF(sign_up_day, birthday) / 365 AS sign_up_age FROM `member`;
SELECT email, sign_up_day, DATE_ADD(sign_up_day, INTERVAL 300 DAY) AS after_300days FROM `member`;
SELECT email, sign_up_day, DATE_SUB(sign_up_day, INTERVAL 300 DAY) AS before_300days FROM `member`;
SELECT email, sign_up_day, UNIX_TIMESTAMP(sign_up_day) FROM `member`; -- 1970년 1월 1일 기준으로 총 지난 시간(초)
SELECT email, sign_up_day, FROM_UNIXTIME(UNIX_TIMESTAMP(sign_up_day)) FROM `member`;
SELECT sign_up_day, SYSDATE(),  CURDATE(), CURTIME() FROM `member`;


-- ORDER BY 정렬
SELECT * FROM `member` ORDER BY height ASC;
SELECT * FROM `member` ORDER BY height DESC;
SELECT * FROM `member` WHERE gender = 'm' AND weight >= 70 ORDER BY height ASC;
SELECT sign_up_day, email FROM `member` ORDER BY YEAR(sign_up_day) DESC, email ASC;

SELECT * FROM `member` ORDER BY sign_up_day DESC LIMIT 10;
SELECT * FROM `member` ORDER BY sign_up_day DESC LIMIT 8, 2; -- 9번째부터 2개의 행만 추출