# 데이터 조작어 (Data Manipulation Language, DML)

## INSERT INTO VALUES

> 테이블에 새로운 데이터(row)를 추가하는 SQL 문
>
> `INSERT INTO {table_names} VALUES {values};` 

```mysql
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
```

<br/>

## UPDATE SET WHERE

> 테이블의 데이터를 갱신(수정)하는 SQL 문
>
> `UPDATE {table_name} SET {column=value} WHERE {column=value};`

```mysql
-- 데이터 갱신
UPDATE student 
	SET major = '멀티미디어학과', name = '차소원'
	WHERE id = 2;
	
-- 모든 열의 데이터 갱신
UPDATE final_exam_result SET score = score + 3;
```

<br/>

## DELETE FROM WHERE

> 테이블의 데이터를 삭제하는 SQL 문
>
> `DELETE FROM {table_name} WHERE {column=value};`

```mysql
DELETE FROM student WHERE id = 4;
```

### 물리 삭제 VS 논리 삭제

> row를 바로 삭제해버리는 것을 **'물리 삭제'**라고 한다. 반면에 삭제해야할 row를 삭제하지 않고, '삭제 여부'를 나타내는 별도의 컬럼을 두고 거기에 '삭제됐음'을 나타내는 값을 넣는 것을 **'논리 삭제'**라고 한다.
>
> 논리 삭제는 데이터를 보존하여 향후 활용에도 도움이 되는 장점이 있지만, 삭제되지 않고 유효한 row들만 조회할 때 `SELECT * FROM WHERE is_cancelled != 'Y';` 처럼 WHERE 절에 별도의 조건을 추가해줘야한다는 번거로운 단점이 있다. 또한, 물리적인 삭제가 아니기 때문에 저장용량이 줄어들지 않는다는 단점도 있다. 때문에 이런 단점을 보완하기 위해 기본 정책은 논리 삭제로 두되, 이미 데이터 분석에 활용되었거나 고객이 동의한 데이터 보유기간이 지난 데이터들은 정기적으로 물리 삭제하는 방법을 활용하기도 한다.

```mysql
-- 쇼핑몰 고객 주문 내역 삭제
-- 물리 삭제
DELETE FROM order WHERE id = 2; 

-- 논리 삭제
UPDATE order SET is_cancelled = ‘Y’ WHERE id = 4;
```

