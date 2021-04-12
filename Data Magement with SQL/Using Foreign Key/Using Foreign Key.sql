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