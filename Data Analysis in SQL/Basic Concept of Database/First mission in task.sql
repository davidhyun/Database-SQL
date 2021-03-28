-- 존재하는 데이터베이스들 파악
SHOW DATABASES;

-- 하나의 데이터베이스 안의 테이블들(뷰 포함) 파악
SHOW FULL TABLES IN copang_main;

-- 하나의 테이블의 컬럼 구조 파악
DESCRIBE item;

-- Foreign Key(외래키) 파악
SELECT 
	i.TABLE_SCHEMA,
    i.TABLE_NAME,
    i.CONSTRAINT_TYPE,
    i.CONSTRAINT_NAME,
    k.REFERENCED_TABLE_NAME,
    k.REFERENCED_COLUMN_NAME
FROM information_schema.TABLE_CONSTRAINTS AS i
LEFT JOIN information_schema.KEY_COLUMN_USAGE AS k ON i.CONSTRAINT_NAME = k.CONSTRAINT_NAME
WHERE i.CONSTRAINT_TYPE = "FOREIGN KEY";