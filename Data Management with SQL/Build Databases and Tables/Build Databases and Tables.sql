-- 데이터 삽입
INSERT INTO student
	(id, name, student_number, major, email, phone, admission_date)
    VALUES (1, '성태후', 20142947, '컴퓨터공학과', 'taehos@naver.com', '010-5678-1234', '2014-03-12');

-- 데이터를 추가할 열을 지정하지 않으면 모든 열에 추가
INSERT INTO student
    VALUES (2, '김소원', 20130912, '화학과', 'sungso@google.com', '010-5678-2323', '2013-03-07');
    
-- 특정 열에만 데이터 추가
INSERT INTO student
	(id, name, student_number, major, admission_date)
    VALUES (3, '이현승', 20111025, '법학과', '2011-03-02');
    
-- auto_increment 속성이 있는 컬럼은 이전 row의 id값보다 1이 큰 고유값을 자동으로 추가
INSERT INTO student
	(name, student_number, major, admission_date)
    VALUES ('정유진', 20160843, '빅데이터학과', '2016-03-15');

SELECT * FROM student;


-- 데이터 갱신
UPDATE student 
	SET major = '멀티미디어학과', name = '차소원'
	WHERE id = 2;
    
SELECT * FROM student;


-- 데이터 삭제
DELETE FROM student WHERE id = 4;

SELECT * FROM student;