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