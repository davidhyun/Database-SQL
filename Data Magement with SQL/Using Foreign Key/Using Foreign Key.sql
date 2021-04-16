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
  CONSTRAINT `fk_review_table` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Foreign Key 삭제
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

-- 참조 무결성(Referential Integrity)
-- 참조무결성을 훼손하는 새로운 row 추가
INSERT INTO review (course_id, star, comment) VALUES (10, 5, "이 강의 최고!");

-- 참조무결성을 위배하지 않는 새로운 row 추가
INSERT INTO review (course_id, star, comment) VALUES (8, 5, "이 강의 최고!");

-- RESTRICT 정책 설정 후 삭제 또는 변경
DELETE FROM course WHERE id = 5;
UPDATE COURSE SET id = 100 WHERE id = 1;

-- CASCADE 정책 설정 후 삭제 또는 변경
DELETE FROM course WHERE id = 5;
UPDATE COURSE SET id = 100 WHERE id = 1;

-- SET NULL 정책 설정 후 삭제 또는 변경
DELETE FROM course WHERE id = 2;
UPDATE COURSE SET id = 200 WHERE id = 100;