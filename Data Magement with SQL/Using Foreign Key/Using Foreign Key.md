# Using Foreign Key

## Foreign Key 개념

> Foreign Key(외래키)란 한 테이블의 컬럼 중에서 **다른 테이블의 특정 컬럼을 식별할 수 있는 컬럼**을 말한다.
>
> Foreign Key로 다른 테이블의 Primary Key를 참조(reference)할 때 Foreign Key가 있는 테이블을 **"자식 테이블(child table)"** 또는 **"참조하는 테이블(referencing table)"**이라 한다. 반대로 Foreign Key에 의해 참조당하는 테이블을 **"부모 테이블(parent table)"** 또는 **"참조당하는 테이블(referenced table)"**이라고 한다.
>
> DBMS에서 한 테이블의 컬럼을 "이 컬럼은 다른 테이블의 컬럼을 참조하는 Foreign Key이다"라고 설정해놓으면 **참조 무결성(Referential Integrity)**을 지킬 수 있다.

---

> **참조 무결성(Referential Integrity)**
>
> 참조 무결성이란 두 테이블 간에 참조 관계가 있을 때 각 데이터 간에 유지되어야 하는 정확성과 일관성을 의미한다.
>
> 참조당하는 부모 테이블의 row가 삭제되면 참조하고있던 자식 테이블의 row들은 '부모 잃은' 상태가 되어버린다. 이때 참조 무결성이 훼손됐다고 한다. 이런 참조 무결성을 지키기 위한 수단으로 특정 컬럼을 Foreign Key로 설정하는 방법이 있다.

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



## Foreign Key 설정

> 특정 테이블을 지금 바로 생성한다고 할 때 작성해야할 CREATE TABLE 문이 무엇인지 보여준다.
>
> 처음 만들 때 부터 Foreign Key  설정을 해주려면 SHOW CREATE TABLE을 활용해서 설정해줄 수 있다.

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

