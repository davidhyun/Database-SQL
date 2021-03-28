# 실무에서 데이터베이스 현황 파악

> 기존 직원 분들의 설명을 듣고, 문서화된 자료를 읽는 것이 가장 좋다. 그리고 그것과 동시에 데이터베이스 현황을 간단하게 파악할 수 있는 SQL 문을 알고 직접 적용해보는 것이 좋다.
>
> 회사의 서버에
>
> 1. 어떤 데이터베이스들이 있는지
> 2. 각 데이터베이스 안에 어떤 테이블들이 있는지
> 3. 각 테이블의 컬럼 구조는 어떻게 되는지
> 4. 테이블들 간의 Foreign Key 관계는 어떤지
>

<br/>

## 1. 존재하는 데이터베이스들 파악

```mysql
SHOW DATABASES;
```

## 2. 하나의 데이터베이스 안의 테이블들(뷰 포함) 파악

```mysql
SHOW FULL TABLES IN copang_main;
```

## 3. 하나의 테이블의 컬럼 구조 파악

```mysql
DESCRIBE item;
```

## 4. Foreign Key(외래키) 파악

> **두 테이블의 각 컬럼 간에 Foreign Key 관계가 논리적으로 성립한다고 해도, 실제 DBMS 상에서는 관리자가 그것을 Foreign Key로 설정하지 않는 경우도 많다.** 관리자의 실수일 수도 있고, 데이터베이스의 성능을 고려해서 의도적으로 외래키 설정을 안했을 수도 있다.

```mysql
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
```