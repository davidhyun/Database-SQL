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

## 논리적 Foreign Key & 물리적 Foreign Key

작성중...

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