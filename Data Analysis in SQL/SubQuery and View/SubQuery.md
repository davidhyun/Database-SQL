# SubQuery

> 전체 SQL 문에서 '부품'처럼 일부를 이루는 또 다른 하위 SQL SELECT 문이다.
>
> > **서브쿼리와 JOIN 조회 속도 이슈**
> >
> > [reference](https://jojoldu.tistory.com/520)
> >
> > MySQL의 5.5버전 이하에서는 서브쿼리보다 JOIN을 사용하는 것이 훨씬 속도가 빠르다.
> >
> > 5.6버전에서 서브쿼리가 대폭 최적화되었지만 적용안되는 조건들도 다수 존재한다.
> >
> > **버전/조건 관계없이 좋은 성능을 내려면 최대한 JOIN을 이용**하자

<img src="https://user-images.githubusercontent.com/64063767/112717980-61b09a80-8f33-11eb-96b3-edc3933329e8.png" alt="image" style="zoom:50%;" />

- 서브쿼리는 꼭 괄호`(SubQuery)`로 감싸주어야 한다.
- 서브쿼리를 포함하는 전체 SQL 문을 **outer query(외부 쿼리)**, 서브쿼리를 **inner query(내부 쿼리)**라고 하기도한다.
- **HAVING 절** 뿐만 아니라 **SELECT 절**, **WHERE 절**, **FROM 절** 등에서도 사용할 수 있다.

```mysql
-- 서브쿼리 기본 동작
SELECT i.id, i.name, AVG(star) AS avg_star
FROM item AS i 
LEFT OUTER JOIN review AS r
ON r.item_id = i.id
GROUP BY i.id, i.name
HAVING avg_star < (SELECT AVG(star) FROM review)
ORDER BY avg_star DESC;
```

<br/>

## SELECT 절 안의 서브쿼리

```mysql
-- SELECT 절 안의 서브쿼리
SELECT 
	id, 
	name, 
    price, 
    (SELECT MAX(price) FROM item) AS max_price,
    (SELECT MAX(price) FROM item) - price AS diff
FROM item;
```

<br/>

## WHERE 절 안의 서브쿼리

```mysql
-- WHERE 절 안의 서브쿼리
SELECT 
	id, 
	name, 
    price, 
    (SELECT AVG(price) FROM item) AS avg_price
FROM item
WHERE price > (SELECT AVG(price) FROM item);

-- 가장 비싼 상품을 조회
SELECT id, name, price
FROM item
WHERE price = (SELECT MAX(price) FROM item);

-- 하나의 값이 아닌 여러 결과값를 나타내는 서브쿼리
SELECT * FROm item
WHERE id IN
(
SELECT item_id
FROM review
GROUP BY item_id
HAVING COUNT(*) >= 3
);

-- 오래 전에 등록됐지만 아직까지도 리뷰가 달리고 있는 스테디 셀러 상품들의 리뷰 조회
SELECT * 
FROM review
WHERE item_id IN
(
SELECT id
FROM item
WHERE registration_date < '2018-12-31'
);
```

<br/>

## ANY(SOME) / ALL

- ANY(서브쿼리) / SOME(서브쿼리)

  서브쿼리가 리턴한 결과 **중에 하나라도** 만족하는 경우가 있으면 True를 return

- ALL(서브쿼리)

  서브쿼리가 리턴한 결과를 **모두 만족하면** True를 return

```mysql
-- ANY(or SOME), ALL의 역할
SELECT name, price
FROM item
WHERE price > ANY(SELECT price FROM item WHERE gender = 'm');

SELECT name, price
FROM item
WHERE price > ALL(SELECT price FROM item WHERE gender = 'm');
```

<br/>

## FROM 절 안의 서브쿼리

> Error Code : Every derived table must have its own alias
>
> 서브쿼리로 새로 탄생한(도출된, 파생된) 테이블을 derived table(ORACLE_inline view)이라고 하며 항상 alias를 붙여줘야한다.

```mysql
-- FROM 절 안의 서브쿼리
SELECT
	AVG(review_count),
    MAX(review_count),
    MIN(review_count)
FROM
(SELECT
	SUBSTRING(address, 1, 2) AS region,
    COUNT(*) AS review_count
FROM review AS r
LEFT OUTER JOIN member AS m
ON r.mem_id = m.id
GROUP BY SUBSTRING(address, 1, 2)
HAVING region IS NOT NULL
AND region != '안드') AS review_count_summary;
```

