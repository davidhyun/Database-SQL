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

### (1) 컬럼 추가

- `ALTER TABLE {table_name} ADD {column_name} {data_type} {column_attribute};`

  ```mysql
  ALTER TABLE student ADD gender CHAR(1) NULL;
  ```

<br/>

### (2) 컬럼 이름 변경

- `ALTER TABLE {table_name} RENAME COLUMN {old_name} TO {new_name};`

  ```mysql
  ALTER TABLE student RENAME COLUMN student_number TO registration_number;
  ```

<br/>

### (3) 컬럼 삭제

- `ALTER TABLE {table_name} DROP COLUMN {column_name};`

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
```

<br/>

- `ALTER TABLE {table_name} MODIFY {column_name} {data_type}`

  ```mysql
  ALTER TABLE student MODIFY major INT;
  ```

<br/>

### (5) 컬럼에 NOT NULL 속성 주기

- `ALTER TABLE {table_name} MODIFY {column_name} {data_type} {column_attribute}`

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

- `ALTER TABLE {table_name} MODIFY {column_name} {data_type} {column_attribute} DEFAULT {value};`

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

#### (a) `NOW()` 함수

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

#### (b) `DEFAULT CURRNET_TIMESTAMP` & `ON UPDATE CURRENT_TIMESTAMP` 속성

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

