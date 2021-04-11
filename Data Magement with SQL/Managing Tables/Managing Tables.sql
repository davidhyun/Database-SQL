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
INSERT INTO student (name, registration_number) VALUES ('구지섭', 20112405);
    
-- UNIQUE 속성 주기
ALTER TABLE student MODIFY registration_number INT NOT NULL UNIQUE;
INSERT INTO student (name, registration_number) VALUES ('최태웅', 20112405);

-- 테이블에 제약사항 걸기
-- 하나의 제약사항
ALTER TABLE student ADD CONSTRAINT st_rule CHECK (registration_number < 30000000);
INSERT INTO student (name, registration_number) VALUES ('이대위', 30000000); -- 제약사항 위반
ALTER TABLE student DROP CONSTRAINT st_rule; -- 제약사항 삭제

-- 두개 이상의 제약사항
ALTER TABLE student 
	ADD CONSTRAINT st_rule
	CHECK ((email LIKE '%@%') AND gender IN ('m', 'f'));
INSERT INTO student (name, registration_number, email, gender)
	VALUES ('김준성', 20130827, 'hyunh317', 'm'); -- 제약사항 위반

-- 제약사항 확인
SHOW CREATE TABLE student;

SELECT 
	COLUMN_NAME, 
	CONSTRAINT_NAME, 
	REFERENCED_COLUMN_NAME,
	REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'student';

-- 테이블 이름 변경
RENAME TABLE student TO undergraduate;

-- 복사본 만들기
CREATE TABLE copy_of_undergraduate AS SELECT * FROM undergraduate;

-- 테이블 구조만 복제
CREATE TABLE copy_of_undergraduate LIKE undergraduate;
INSERT INTO copy_of_undergraduate 
	SELECT * FROM undergraduate WHERE major = 101; -- 서브쿼리로 특정 row만 추가

-- 테이블의 모든 row 삭제
DELETE FROM copy_of_undergraduate; -- 안전모드 해제 필요
TRUNCATE copy_of_undergraduate;

-- 테이블 삭제
DROP TABLE copy_of_undergraduate;
