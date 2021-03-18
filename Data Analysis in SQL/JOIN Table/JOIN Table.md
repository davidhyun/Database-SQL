# JOIN

> 여러개의 테이블을 합쳐서 하나의 테이블인 것처럼 보는 것을 `JOIN`이라고 한다.

<br/>

## 1. Foreign Key

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

## 2. JOIN

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
```

