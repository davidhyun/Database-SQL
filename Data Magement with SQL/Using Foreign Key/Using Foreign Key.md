# Using Foreign Key

## Foreign Key 개념

Foreign Key(외래키)란 한 테이블의 컬럼 중에서 **다른 테이블의 특정 컬럼을 식별할 수 있는 컬럼**을 말한다.

Foreign Key로 다른 테이블의 Primary Key를 참조(reference)할 때 Foreign Key가 있는 테이블을 **"자식 테이블(child table)"** 또는 **"참조하는 테이블(referencing table)"**이라 한다. 반대로 Foreign Key에 의해 참조당하는 테이블을 **"부모 테이블(parent table)"** 또는 **"참조당하는 테이블(referenced table)"**이라고 한다.

DBMS에서 한 테이블의 컬럼을 "이 컬럼은 다른 테이블의 컬럼을 참조하는 Foreign Key이다"라고 설정해놓으면 **참조 무결성(Referential Integrity)**을 지킬 수 있다.

<img src="https://user-images.githubusercontent.com/64063767/114396910-135cf600-9bd9-11eb-8c0b-577c3d323b17.png" alt="image" style="zoom:67%;" />

<img src="https://user-images.githubusercontent.com/64063767/114404313-8ddd4400-9be0-11eb-85b8-f5156653dc71.png" alt="image" style="zoom:67%;" />

```mysql
CREATE TABLE course_rating.course (
	id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(30) NULL,
    semester VARCHAR(6) NULL,
    maximum INT NULL,
    professor VARCHAR(10) NULL,
    PRIMARY KEY(id)
);
DESCRIBE course;

CREATE TABLE course_rating.review (
	id INT NOT NULL AUTO_INCREMENT,
    course_id INT NULL,
    star INT NULL,
    comment VARCHAR(500) NULL,
    PRIMARY KEY(id)
);
DESCRIBE review;
```

<br/>

## Foreign Key 설정

특정 테이블을 지금 바로 생성한다고 할 때 작성해야할 CREATE TABLE 문이 무엇인지 보여준다.

처음 만들때부터 Foreign Key  설정을 해주려면 SHOW CREATE TABLE을 활용해서 설정해줄 수 있다.

```mysql
-- 기존 테이블에서 Foreign Key 설정
ALTER TABLE `course_rating`.`review` 
ADD CONSTRAINT `fk_review_table`
	FOREIGN KEY (`course_id`)
	REFERENCES `course_rating`.`course` (`id`)
	ON DELETE RESTRICT
	ON UPDATE RESTRICT;

-- 처음 테이블 생성시 Foreign Key 설정
SHOW CREATE TABLE review;

CREATE TABLE `review` (
  	`id` int NOT NULL AUTO_INCREMENT,
  	`course_id` int DEFAULT NULL,
  	`star` int DEFAULT NULL,
  	`comment` varchar(500) DEFAULT NULL,
  	PRIMARY KEY (`id`),
  	KEY `fk_review_table` (`course_id`),
  	CONSTRAINT `fk_review_table` 
    FOREIGN KEY (`course_id`) 
    REFERENCES `course` (`id`) 
    ON DELETE RESTRICT 
    ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

<br/>

## Foreign Key 삭제

```mysql
-- 제약사항 확인
SHOW CREATE TABLE review;
ALTER TABLE review DROP FOREIGN KEY fk_review_table;

/*
review, CREATE TABLE `review` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int DEFAULT NULL,
  `star` int DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_review_table` (`course_id`),
  CONSTRAINT `fk_review_table` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
*/
```

<br/>

## 참조 무결성(Referential Integrity)

참조 무결성이란 두 테이블 간에 참조 관계가 있을 때 각 데이터 간에 유지되어야 하는 정확성과 일관성을 의미한다.

참조당하는 부모 테이블의 row가 삭제되면 참조하고있던 자식 테이블의 row들은 '부모 잃은' 상태가 되어버린다. 이때 참조 무결성이 훼손됐다고 한다. 이런 참조 무결성을 지키기 위한 수단으로 특정 컬럼을 Foreign Key로 설정하는 방법이 있다.

<br/>

```mysql
-- 참조무결성을 훼손하는 새로운 row 추가
INSERT INTO review (course_id, star, comment) VALUES (10, 5, "이 강의 최고!");
```

> Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`course_rating`.`review`, CONSTRAINT `fk_review_table` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)

추가하려는 course_id 컬럼이 부모 테이블의 id 컬럼에 없는 이상한 값이기 때문에, 즉 참조무결성을 훼손하는 값이기 때문에 Foreign Key 제약사항을 위반하여 에러가 발생한 것이다.

<br/>

## 정책(Policy)

강의 목록의 부모테이블에서 강의가 삭제되면 자식테이블에서 해당 강의의 후기는 어떻게 처리해야할지 생각해보자.

부모 테이블의 참조당하는 row가 삭제될 때 남아있는 자식 테이블의 참조하고 있는 row는 어떻게 되어야할지는 정해진 답이 있기보다는 사용자가 정한 정책(policy)에 의거하여 처리된다.

### (1) RESTRICT Policy (NO ACTION Policy)

<img src="https://user-images.githubusercontent.com/64063767/114567241-ff36f880-9cad-11eb-90d4-cf5f3e86b9e6.png" alt="image" style="zoom:67%;" />

자식 테이블의 row들에 의해 참조 당하고 있는 **부모 테이블의 row를 삭제하지 못하도록 막는** 정책. 

참조 당하고 있는 부모 테이블의 row를 삭제하려면 참조하고 있는 자식테이블의 row들을 먼저 삭제한 후에야 가능하다.

```mysql
-- RESTRICT 정책 설정 후 삭제 또는 변경
DELETE FROM course WHERE id = 5;
UPDATE COURSE SET id = 100 WHERE id = 1;
```

> Error Code: 1451. Cannot **delete or update** a parent row: a foreign key constraint fails (`course_rating`.`review`, CONSTRAINT `fk_review_table` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT)

<br/>

### (2) CASCADE Policy

> CASCADE : '폭포수처럼 떨어지다', '연쇄 작용을 일으키다'

<img src="https://user-images.githubusercontent.com/64063767/114569048-9ea8bb00-9caf-11eb-92e3-0bee23939981.png" alt="image" style="zoom:67%;" />

부모 테이블의 row가 삭제될 때 그 row를 **참조하고 있던 자식 테이블의 row도 연쇄적으로 삭제**되는 정책.

```mysql
-- CASCADE 정책 설정 후 삭제 또는 변경
DELETE FROM course WHERE id = 5;
UPDATE COURSE SET id = 100 WHERE id = 1;
```

<br/>

### (3) SET NULL Policy

<img src="https://user-images.githubusercontent.com/64063767/114570095-81282100-9cb0-11eb-886b-289ce8675f2e.png" alt="image" style="zoom:67%;" />

부모 테이블의 row가 삭제될 때 그 row를 **참조하고 있던 자식 테이블의 Foreign Key 컬럼의 값을 NULL로 변경**하는 정책.

```mysql
-- SET NULL 정책 설정 후 삭제 또는 변경
DELETE FROM course WHERE id = 2;
UPDATE COURSE SET id = 200 WHERE id = 100;
```

<br/>

## 논리적 Foreign Key & 물리적 Foreign Key

많은 테이블들이 Foreign Key를 매개로 관계를 맺고 있고, 여러 테이블들을 하나로 합치는 조인9Join)을 이 Foreign Key 기준으로 하는 것이 일반적이기 때문에, 현재 데이터베이스에 존재하는 Foreign Key들을 잘 파악하는 것이 중요하다.

하지만 실무에서 데이터베이스의 테이블들을 살펴보다 보면 **어떤 테이블의 특정 컬럼이 Foreign Key로 설정되어야할 것 같은데 Foreign Key로 설정되지 않은 경우를 보게될 수 있다.** 어떤 테이블의 한 컬럼이 논리적으로는 다른 테이블의 컬럼을 참조해야해서 개념상 Foreign Key에 해당하는 것과, 실제로 해당 컬럼을 Foreign Key로 설정해서 두 테이블 간의 참조 무결성을 지킬 수 있게되는 것은 별개의 개념이다. 그래서 보통 이 둘을 나누어 **개념상, 논리적으로 성립하는 Foreign Key**를 `논리적(Logical) Foreign Key`라고 하고, **DBMS 상에서 실제로 특정 컬럼을 Foreign Key로 설정**해서 두 테이블 간의 참조 무결성을 보장할 수 있게 됐을 때, 그 컬럼을 `물리적(Physical) Foreign Key`라고 한다. 실무에서 논리적 Foreign Key라고 해서 꼭 그것을 물리적 Foreign Key로 설정하는 것은 아니다. 물리적 Foreign Key로 설정하면 참조 무결성이 보장되니까 좋을텐데 왜 설정하지 않는 것일까?

<br/>

### 1. 성능 문제

실제 서비스에 의해 사용되고 있는 데이터베이스의 테이블들은 단 1초 내에도 수많은 조회(SELECT), 추가(INSERT), 수정(UPDATE), 삭제(DELETE) 작업이 일어나고 있을 수 있다. 이럴 때 SQL 문 하나하나가 얼마나 빨리 실행되는지가 사용자의 만족도에 큰 영향을 미친다.

**물리적 Foreign Key가 있는 자식 테이블의 경우에는 INSERT, UPDATE 문 등이 실행될 때 약간의 속도 저하가 발생할 가능성이 있다.** 왜냐하면 INSERT, UPDATE 문이 실행될 때 혹시라도 **참조 무결성을 깨뜨리는 변화가 발생하지 않을지 추가적으로 검증해줘야하기 때문**이다. 즉 물리적 Foreign Key를 설정하게 되면, 데이터의 참조 무결성을 보장해주는 대신, 성능 부분에서는 약간의 양보가 필요한 것이다.

만약 데이터의 참조 무결성보다는 일단 당장 빠른 성능이 중요하다면 물리적 Foreign Key를 굳이 설정하지 않기도 한다. 그리고 이렇게 일단은 INSERT, UPDATE 문 등이 보다 더 빠르게 실행되도록 하고, 참조 무결성을 어기는 데이터들은 정기적으로 별도의 확인 후에 삭제해주는 방식을 택하기도 한다.

<br/>

### 2. 레거시(Legacy) 데이터의 참조 무결성이 이미 깨진 상태라면?

Legacy는 "유물", "유산"이라는 뜻으로 IT 직무에서는 프로그램의 **기존 코드**, **기존 데이터** 등을 나타낼 때 사용하는 말이다.

이미 레거시 데이터의 참조 무결성이 깨져버려서 복구하기 힘든 실무에서의 현실적인 이유로 물리적 Foreign Key없이, 참조 무결성을 지키는 것을 포기하고 서비스를 운영하는 곳들도 생겨나게 된다. 참조 무결성이 깨지더라도 일단 소중한 데이터들을 삭제하지 않기 위해서 말이다.

하지만 데이터의 참조 무결성을 완벽하게 지켜야하는 서비스(은행, 학적관리 서비스 등)에서는 논리적 Foreign Key를 반드시 물리적 Foreign Key로 설정해야한다.