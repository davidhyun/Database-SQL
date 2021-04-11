# Managing Tables

## Describe Table Structure

- `DESCRIBE` or `DSEC`: 컬럼 구조를 확인할 수 있는 SQL문
  - Field : 컬럼의 이름
  - Type : 컬럼의 데이터 타입
  - Null : 컬럼의 Null 속성 유무
  - Key : Primary Key, Unique 속성 여부
  - Default : 컬럼의 기본값
  - Extra : AUTO_INCREMENT 등의 기타 속성

```mysql
USE course_rating;

DESCRIBE student;
DESC student;
```

<br/>

## ALTER

> 데이터베이스와 테이블의 내용을 수정할 수 있는 데이터 정의 언어(DDL)
>
> `ALTER TABLE {table_name} {COMMAND} {column_name} {data_type} {column_attributes} DEFAULT {value};`

### (1) 컬럼 추가

```mysql
ALTER TABLE student ADD gender CHAR(1) NULL;
```

<br/>

### (2) 컬럼 이름 변경

```mysql
ALTER TABLE student RENAME COLUMN student_number TO registration_number;
```

<br/>

### (3) 컬럼 삭제

```mysql
ALTER TABLE student DROP COLUMN admission_date;
```

<br/>

### (4) 데이터 타입 변경

```mysql
UPDATE student SET major = 10 WHERE major = '컴퓨터공학과';
UPDATE student SET major = 12 WHERE major = '멀티미디어학과';
UPDATE student SET major = 7 WHERE major = '법학과';
```

> Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
>
> "safe update 모드를 사용중일 때는 KEY column을 사용해서 테이블을 갱신해야 한다"는 뜻이다. 여기서 Key column은 Primary Key를 의미한다.
>
> safe update 모드는 안전한 갱신을 보장하기 위한 모드로
> `UPDATE student SET major = 10;`처럼 모든 row의 특정 컬럼을 갱신해버리는 SQL문이나 `UPDATE student SET major = 10 WHERE major = '컴퓨터공학과';`처럼 WHERE 절에 Primary Key가 사용되지 않은 UPDATE 문이 실행되지 않도록 한다.

```mysql
-- 일시적인 안전모드 해제
SET sql_safe_updates = 0; # SET sql_safe_updates = 1 안전모드로 되돌리기

UPDATE student SET major = 10 WHERE major = '컴퓨터공학과';
UPDATE student SET major = 12 WHERE major = '멀티미디어학과';
UPDATE student SET major = 7 WHERE major = '법학과';

-- 데이터 타입 변경
ALTER TABLE student MODIFY major INT;
```

<br/>

### (5) 컬럼에 NOT NULL 속성 주기

```mysql
ALTER TABLE student MODIFY name VARCHAR(35) NOT NULL;
ALTER TABLE student MODIFY registration_number INT NOT NULL;
ALTER TABLE student MODIFY major INT NOT NULL;
DESC student;

-- test sql
INSERT INTO student (email, phone, gender)
	VALUES ('abc@naver.com', '010-1234-5678', 'm');
```

<br/>

### (6) 컬럼에 Default 속성 주기

```mysql
ALTER TABLE student MODIFY major INT NOT NULL DEFAULT 101;
INSERT INTO student (name, registration_number)
	VALUES ('구지섭', 20112405);
```

<br/>

### (7) DATETIME, TIMESTAMP 타입의 컬럼에 값을 넣기

> 테이블에 어떤 row가 추가되거나 갱신되었을 때 등록시간이나 수정시간을 저장해야할 때가 있다. 이런 정보를 저장하는 컬럼에 현재 시간 값을 넣어줄 때는 크게 두 가지 방법이 있다. 만약 각 row마다 시간값에 관한 처리를 다르게 해줘야하는 경우라면 NOW()함수를 활용하고, 그럴 필요 없이 날짜/시간 값을 별도로 신경쓰고 싶지 않다면 해당 컬럼에 DEFAULT 속성을 설정하는 방법을 활용할 수 있다.
>
> table structure
>
> - id : Primary Key Column
> - title : 게시글 제목
> - content : 게시글 내용
> - upload_time(DATETIME) : 게시글 최초 업로드 시각
> - recent_modified_time(TIMESTAMP) : 게시글 최근 수정 시각

#### (i) `NOW()` 함수

```mysql
-- 게시글 최초 등록
INSERT INTO post (title, content, upload_time, recent_modified_time)
	VALUES ("기분 좋은 날", "오늘은 서울 청계천을 다녀왔어요!", NOW(), NOW());

-- 게시글 수정
UPDATE post 
	SET content = "청계천이 아니라 경복궁 다녀왔어요",
		recent_modified_time = NOW()
	WHERE id = 1;
```

#### (ii) `DEFAULT CURRNET_TIMESTAMP` & `ON UPDATE CURRENT_TIMESTAMP` 속성

> DATETIME, TIMESTAMP 타입의 컬럼에는 `DEFAULT CURRENT_TIMESTAMP`라는 속성과 `ON UPDATE CURRENT_TIMESTAMP`라는 속성을 줄 수 있다.
>
> `DEFAULT CURRENT_TIMESTAMP` 속성은 테이블에 새 row를 추가할 때 따로 그 컬럼에 값을 주지 않아도 현재 시간이 설정되도록 하는 속성이다.
>
> `ON UPDATE CURRENT_TIMESTAMP` 속성은 기존 row에서 단 하나의 컬럼이라도 수정될 때의 시간이 설정되도록하는 속성이다.

```mysql
-- 속성 추가
ALTER TABLE post
	MODIFY upload_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	MODIFY recent_modified_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 게시글 최초 등록
INSERT INTO post (title, content)
	VALUES ("기분 안좋은 날", "오늘은 월요일.."); -- 시각 컬럼에는 이미 default 값이 설정됨
	
-- 게시글 수정
UPDATE post
	SET content = "월요병은 내일연차로 힐링"
	WHERE id = 2;
```

<br/>

### (8) UNIQUE 속성 주기

> 컬럼에 UNIQUE 속성을 설정하면 그 컬럼에 같은 값을 가진 또 다른 row(entry)가 추가되는 것을 막을 수 있다.

```mysql
ALTER TABLE student MODIFY registration_number INT NOT NULL UNIQUE;

INSERT INTO student (name, registration_number) VALUES ('최태웅', 20112405);
```

Error Code: 1062. Duplicate **entry** '20112405' for key 'student.registration_number' 

<br/>

#### Primary Key VS UNIQUE 속성

- **Primary Key**
  - 테이블에서 특정 row 하나만 식별할 수 있도록 해주는 컬럼.
  - Primary Key에 해당하는 컬럼은 각 row마다 다른 값을을 가져야 한다.
  - Primary Key는 **테이블당 오직하나**만 존재할 수 있다.
  - Primary Key는 **NULL을 허용하지 않는다.**
- **UNIQUE 속성**
  - 각각의 컬럼들이 가질 수 있는 속성이기 때문에 한 테이블에 **여러개의 UNIQUE 속성들이 존재할 수 있다.**
  - **UNIQUE 속성은 NULL을 허용한다.**

<br/>

### (9) 테이블에 제약사항 걸기

> **CONSTRAINT**
>
> 테이블에 이상한 row가 추가되는 것을 막기위해 테이블에 제약사항을 건다.
>
> - IN (value1, vlaue2, ...) : 값이 ~중에 하나는 있어야 한다.

```mysql
-- 하나의 제약사항
ALTER TABLE student ADD CONSTRAINT st_rule CHECK (registration_number < 30000000);

-- 제약사항 위반
INSERT INTO student (name, registration_number) VALUES ('이대위', 30000000);

-- 제약사항 삭제
ALTER TABLE student DROP CONSTRAINT st_rule;
```

```mysql
-- 두개 이상의 제약사항
ALTER TABLE student 
	ADD CONSTRAINT st_rule
	CHECK ((email LIKE '%@%') AND gender IN ('m', 'f'));
	
-- 제약사항 위반
INSERT INTO student (name, registration_number, email, gender)
	VALUES ('김준성', 20130827, 'hyunh317', 'm'); -- 제약사항 위반
```

<br/>

> **제약사항 확인하기**
>
> [How to display all constraints on a table in MySQL?](https://www.tutorialspoint.com/how-to-display-all-constraints-on-a-table-in-mysql)
>
> - Method1 - Using SHOW command
>
>   ```mysql
>   SHOW CREATE TABLE student;
>   ```
>
> - Method2 - Using information.schema
>
>   ```mysql
>   SELECT 
>   	COLUMN_NAME, 
>   	CONSTRAINT_NAME, 
>   	REFERENCED_COLUMN_NAME,
>   	REFERENCED_TABLE_NAME
>   FROM information_schema.KEY_COLUMN_USAGE
>   WHERE TABLE_NAME = 'student';
>   ```

<br/>

### (10) 기타 컬럼 관련 작업

![image](https://user-images.githubusercontent.com/64063767/114300228-2056e800-9afa-11eb-8a47-3ed9539a1d47.png)

#### (i) 컬럼 가장 앞으로 당기기

```mysql
-- 맨 뒤의 id 컬럼 맨 앞으로 당기기
ALTER TABLE player_info MODIFY id INT NOT NULL AUTO_INCREMENT FIRST;
```

#### (ii) 컬럼 간의 순서 바꾸기

```mysql
-- role 컬럼을 선수명 컬럼 뒤에 배치
ALTER TABLE player_info MODIFY role CHAR(5) NULL AFTER name;
```

#### (iii) 컬럼의 이름, 컬럼의 데이터 타입 및 속성 동시에 수정하기

```mysql
ALTER TABLE player_info CHANGE role position VARCHAR(2) NOT NULL;
```

#### (iv) 여러 작업 동시에 수행하기

```mysql
ALTER TABLE player_info
	RENAME COLUMN id TO registration_number,
	MODIFY name VARCHAR(20) NOT NULL,
	DROP COLUMN position,
	ADD height DOOUBLE NOT NULL,
	ADD weight DOUBLE NOT NULL;
	
ALTER TABLE player_info
	CHANGE id registration_number INT NOT NULL AUTO_INCREMENT,
	CHANGE name name VARCHAR(20) NOT NULL,
	DROP COLUMN position,
	ADD height DOOUBLE NOT NULL,
	ADD weight DOUBLE NOT NULL;
```

<br/>

### (11) 테이블 이름 변경, 복사본 만들기, 구조만 복제, 삭제

```mysql
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
```

