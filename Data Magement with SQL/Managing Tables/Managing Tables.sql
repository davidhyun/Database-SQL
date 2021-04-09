USE course_rating;

-- 컬럼 구조 확인
DESCRIBE student;
DESC student;

SELECT * FROM student;

-- ALTER 테이블 내용 변경
-- 컬럼 추가
ALTER TABLE student ADD gender CHAR(1) NULL;

-- 컬럼 이름 변경
ALTER TABLE student RENAME COLUMN student_number TO registration_number;
    
-- 컬럼 삭제
ALTER TABLE student DROP COLUMN admission_date;

-- 데이터 타입 변경
SET sql_safe_updates = 0; -- 일시적 안전모드 해제

UPDATE student SET major = 10 WHERE major = '컴퓨터공학과';
UPDATE student SET major = 12 WHERE major = '멀티미디어학과';
UPDATE student SET major = 7 WHERE major = '법학과';
ALTER TABLE student MODIFY major INT;

SET sql_safe_updates = 1; -- 안전모드로 되돌리기

-- 컬럼에 NOT NULL 속성 주기
ALTER TABLE student MODIFY name VARCHAR(35) NOT NULL;
ALTER TABLE student MODIFY registration_number INT NOT NULL;
ALTER TABLE student MODIFY major INT NOT NULL;
DESC student;

-- 컬럼에 Default 속성 주기
ALTER TABLE student MODIFY major INT NOT NULL DEFAULT 101;
INSERT INTO student (name, registration_number)
	VALUES ('구지섭', 20112405);
