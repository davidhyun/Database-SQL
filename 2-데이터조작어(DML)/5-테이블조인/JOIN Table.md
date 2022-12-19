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

### 1:1 관계, 1:N 관계

> 이전에 item 테이블과 stock 테이블 조인에서는 하나의 '상품'이 한건의 '재고 수' 정보를 갖는 **1:1 관계**였기 때문에 동일한 상품 이름이 여러번 등장하지 않았다.
>
> 반면에 하나의 '상품'에는 여러개의 '리뷰'가 달릴 수 있는데 이런 것을 **1:N 관계**라고 한다. item 테이블을 기준으로 review 테이블을 LEFT OUTER JOIN하면 하나의 상품에 여러개의 리뷰를 연결해서 표현해줄 수 있다. 그래서 하나의 상품에 대해서 그 id 값과 일치하는 item_id 값을 가진 리뷰라면 모두 연결되어, 동일한 상품 이름이 여러번 표시된 것이다.

<img src="https://user-images.githubusercontent.com/64063767/111995655-83d5a180-8b5c-11eb-8731-2d765eb89249.png" alt="image" style="zoom: 50%;" />

```mysql
-- 서로 다른 3개의 테이블 조인하기
SELECT 
	i.name, i.id, 
	r.item_id, r.star, r.comment, r.mem_id, 
	m.id, m.email
FROM item AS i 
LEFT OUTER JOIN review AS r ON r.item_id = i.id
LEFT OUTER JOIN `member` AS m ON r.mem_id = m.id;
```

```mysql
-- 여성이 구매한 별점 평균이 좋은 상품과 리뷰 수 조회
SELECT i.id, i.name, AVG(star), COUNT(*)
FROM item AS i 
LEFT OUTER JOIN review AS r ON r.item_id = i.id
LEFT OUTER JOIN `member` AS m ON r.mem_id = m.id
WHERE m.gender = 'f'
GROUP BY i.id, i.name
HAVING COUNT(*) > 1
ORDER BY AVG(star) DESC, COUNT(*) DESC;
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

<br/>

# 5. Other JOIN

### (1) NATURAL JOIN

> NATURAL JOIN(자연 조인)은 두 테이블에서 같은 이름의 컬럼을 찾아서 자동으로 조인 조건으로 설정하고 INNER JOIN해주는 역할을 한다. 테이블 구조를 모른다면 어떤 컬럼들을 기준으로 조인되었는지 알 수 없기 때문에 ON 절에 조인 조건을 명시하는 것을 권장한다. 

```mysql
SELECT p.id, p.player_name, p.team_name, t.team_name, t.region
FROM player AS p 
INNER JOIN team AS t ON p.team_name = t.team_name;

SELECT p.id, p.player_name, p.team_name, t.team_name, t.region
FROM player AS p 
NATURAL JOIN team AS t;
```

### (2) CROSS JOIN

> 한 테이블의 하나의 row에 다른 테이블의 모든 row들을 매칭하고, 다음 row에서도 다른 테이블의 모든 row들을 매칭하는 것을 반복함으로써 두 테이블의 row들의 모든 조합을 볼 수 있는 조인이다. 집합의 모든 원소들의 조합을 나타내는 것을 수학 집합이론에서는 카르테시안 곱(Cartesian Product)라고 한다.

<img src="https://user-images.githubusercontent.com/64063767/112001425-4ecc4d80-8b62-11eb-9f1d-e839bfe74cc4.png" alt="image" style="zoom:50%;" />

```mysql
SELECT * FROM member CROSS JOIN stock;
```

### (3) SELF JOIN

> 테이블이 자기 자신과 조인을 하는 경우를 말한다. 서로 별개인 두 테이블을 조인하는 것처럼 생각하면 된다.

<img src="https://user-images.githubusercontent.com/64063767/112002555-5b04da80-8b63-11eb-90be-a068b5cd65fe.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/112002749-91425a00-8b63-11eb-92ff-5540af550bb0.png" alt="image" style="zoom:50%;" />

```mysql
SELECT * FROM FOR_TEST.employee;

SELECT *
FROM employee AS e1
LEFT OUTER JOIN employee AS e2 ON e1.boss = e2.id;

SELECT *
FROM employee AS e1
LEFT OUTER JOIN employee AS e2 ON e1.boss = e2.id
LEFT OUTER JOIN employee AS e3 ON e2.boss = e3.id;
```

### (4) FULL OUTER JOIN

> 두 테이블의 LEFT OUTER JOIN 결과와 RIGHT OUTER JOIN 결과를 합치는 조인이다. 이 때 두 결과에 모두 존재하는 공통 row들은 한번만 나타낸다.

| LEFT OUTER JOIN + <br />RIGHT OUTER JOIN                     | UNION ALL                                                    | UNION                                                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/64063767/112003739-85a36300-8b64-11eb-984f-2579d0be1d48.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/112004009-c00d0000-8b64-11eb-811c-7ac4a975fd13.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/112004073-d024df80-8b64-11eb-85b4-45292f7990e9.png" alt="image" style="zoom:50%;" /> |

```mysql
SELECT *
FROM player AS p
LEFT OUTER JOIN team AS t ON p.team_name = t.team_name;

SELECT *
FROM player AS p
LEFT OUTER JOIN team AS t ON p.team_name = t.team_name
UNION ALL
SELECT *
FROM player AS p 
RIGHT OUTER JOIN team AS t ON p.team_name = t.team_name;

SELECT *
FROM player AS p
LEFT OUTER JOIN team AS t ON p.team_name = t.team_name
UNION
SELECT *
FROM player AS p
RIGHT OUTER JOIN team AS t ON p.team_name = t.team_name;
```

```mysql
-- ORACLE
SELECT *
FROM player AS p
FULL OUTER JOIN team AS t ON p.team_name = t.team_name;
```

### (5) Non-Equi 조인

> 지금까지 조인 조건을 설정할 때 두 컬럼의 값이 같은지를 기준으로 했다. 이렇게 조인 조건에 항상 등호(=)를 사용한 조인을 Equi 조인이라고 한다.
>
> 하지만 동등 조건이 아닌 다른 종류의 조건을 사용해서도 조인을 할 수 있다. 이러한 조인을 **Non-Equi 조인**이라고 한다. 특정 회원이 가입한 이후에 사이트에 올라온 상품들이 무엇인지 확인할 수 있다.

<img src="https://user-images.githubusercontent.com/64063767/112005355-057dfd00-8b66-11eb-91b1-19690f447968.png" alt="image" style="zoom:50%;" />

```mysql
SELECT 
    m.email, 
    m.sign_up_day, 
    i.name, 
    i.registration_date
FROM `member` AS m
LEFT OUTER JOIN item AS i ON m.sign_up_day < i.registration_date
ORDER BY m.sign_up_day ASC;
```

