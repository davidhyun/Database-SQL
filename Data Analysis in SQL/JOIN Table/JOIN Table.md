# 1. 테이블 연산

> 테이블을 합치는 '연산'은 `결합 연산`과 `집합 연산`으로 나눌 수 있다. **결합 연산**은 테이블을 **가로방향**으로 합치는 것에 관한 연산이고, **집합 연산**은 테이블을 **세로방향**으로 합치는 것에 관한 연산이다.

<br/>

# 2. Foreign Key (외래키)

> 한 테이블의 컬럼이 다른 테이블의 컬럼을 **참조**하는 관계일 때, '다른 테이블의 특정 row를 식별할 수 있게 해주는 컬럼'을 `Foreign Key(외래키)`라고 한다.
>
> 참조를 하는 테이블을 **자식 테이블**, 참조를 당하는 테이블을 **부모 테이블**이라고 한다.
>
> Foreign Key는 다른 테이블의 특정 row를 식별할 수 있어야하기 때문에 주로 다른 테이블의 Primary Key를 참조할 때가 많다.
>
> Foreign Key를 기준으로 조인하면 OUTER JOIN 결과와 INNER JOIN의 결과가 같을 수 밖에 없다.
>
> 하지만 꼭 Foreign Key를 기준으로 조인해야만하는 것은 아니다. Foreign Key가 아닌 컬럼을 기준으로 해서 조인할 수도 있다. 꼭 Foreign Key가 존재하지 않더라도 **서로 같은 의미를 나타내는 컬럼들을 기준으로 조인할 수 있다**는 것이다.

<img src="https://user-images.githubusercontent.com/64063767/111165807-cb9b7c80-85e2-11eb-808e-a8f1d8acdf6d.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/111165886-e1a93d00-85e2-11eb-8ac6-ed38442d4181.png" alt="image" style="zoom:50%;" />

<br/>

# 3. JOIN (결합 연산)

> 여러개의 테이블을 합쳐서 하나의 테이블인 것처럼 보는 것을 `JOIN`이라고 한다.
>
> **조인**은 두 테이블의 각 컬럼을 기준으로 해서 같은 값을 가진 row들을 가로 방향으로 이어붙이는 작업이기 때문에 **결합 연산**에 해당한다.

```mysql
-- LEFT OUTER JOIN
-- 왼쪽 item 테이블의 id 컬럼을 기준으로 outer방식으로 stock 테이블을 합친다
SELECT 
	item.id,
    item.name,
    stock.item_id,
    stock.inventory_count
FROM item 
LEFT OUTER JOIN stock
ON item.id = stock.item_id;

-- old 테이블에는 있지만 new 테이블에는 누락된 데이터 조회
SELECT
	old.id AS old_id,
    old.name AS old_name,
    new.id AS new_id,
    new.name AS new_name
FROM item AS old
LEFT OUTER JOIN item_new AS new
ON old.id = new.id;

-- old 테이블에는 없지만 new 테이블에는 새롭게 추가된 데이터 조회
SELECT
	old.id AS old_id,
    old.name AS old_name,
    new.id AS new_id,
    new.name AS new_name
FROM item AS old
RIGHT OUTER JOIN item_new AS new
ON old.id = new.id
WHERE old.id IS NULL;

-- RIGHT OUTER JOIN
-- 오른쪽 stock 테이블의 item_id 컬럼을 기준으로 outer방식으로 item 테이블을 합친다
SELECT 
	item.id,
    item.name,
    stock.item_id,
    stock.inventory_count
FROM item 
RIGHT OUTER JOIN stock
ON item.id = stock.item_id;


-- INNER JOIN
SELECT 
	i.id,
    i.name,
    s.item_id,
    s.inventory_count
FROM item AS i 
INNER JOIN stock AS s
ON i.id = s.item_id;

-- 두 테이블 모두 공통으로 가지고있는 상품정보 조회
-- (집합연산 UNION의 필요성)
SELECT
	old.id AS old_id,
    old.name AS old_name,
    new.id AS new_id,
    new.name AS new_name
FROM item AS old
INNER JOIN item_new AS new
ON old.id = new.id; 
-- 두 컬럼 이름이 같다면, ON old.id = new.id 대신 USNIG(id) 사용가능
```

<br/>

# 4. UNION, INTERSECT, MINUS (집합 연산)

> **MySQL에서는 UNION만 지원**한다. (ORACLE에서는 UNION, INTERSECT, MINUS 모두 지원)
>
> 컬럼 구조가 같은 테이블끼리만 UNION 연산을 할 수 있다. 테이블끼리 컬럼 수가 다르다면 두 테이블이 공통적으로 갖고 있는 컬럼 이름들을 지정해서 조회하면 된다.
>
> 중복을 허용해야하는 경우 UNION 대신 **UNION ALL** 연산자를 활용하여 겹치는 것들을 그대로 조회할 수 있다.

<img src="https://user-images.githubusercontent.com/64063767/111859906-8b901d00-8987-11eb-8702-8cd937bb8191.png" alt="image" style="zoom:50%;" />

| A ∪ B | A ∩ B     | A - B |
| ----- | --------- | ----- |
| UNION | INTERSECT | MINUS |

```mysql
-- (1) A U B (UNION 연산자 사용)
SELECT * FROM member_A
UNION
SELECT * FROM member_B

-- (2) A ∩ B (INTERSECT 연산자 사용)
SELECT * FROM member_A 
INTERSECT 
SELECT * FROM member_B

-- (3) A - B (MINUS 연산자 또는 EXCEPT 연산자 사용)
SELECT * FROM member_A 
MINUS
SELECT * FROM member_B
```

