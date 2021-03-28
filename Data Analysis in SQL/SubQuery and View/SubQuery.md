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
LEFT OUTER JOIN `member` AS m
ON r.mem_id = m.id
GROUP BY SUBSTRING(address, 1, 2)
HAVING region IS NOT NULL
AND region != '안드') AS review_count_summary;
```

<br/>

## 비상관 서브쿼리 & 상관 서브쿼리

### (1) 비상관 서브쿼리

> 서브쿼리 그 자체만으로도 별도로 실행이 가능한 서브쿼리를 **비상관 서브쿼리(Non-correlated Subquery)**라고 한다. 이것은 서브쿼리를 둘러싼 outer query와 별개로, 독립적으로 실행되기 때문이다.

### (2) 상관 서브쿼리

> 서브쿼리가 outer query에 적힌 테이블 이름 등과 상관 관계를 가지고 있어서 단독으로는 싱행되지 못하는 서브쿼리를 **상관 서브쿼리(Correlated Subquery)**라고 한다.

<img src="https://user-images.githubusercontent.com/64063767/112744782-fb348680-8fdd-11eb-8e43-062e62b7726b.png" alt="image" style="zoom:50%;" />

#### 상관 서브쿼리의 실행원리

- 상품들 중에서 리뷰가 달린 상품들만 조회

  (0) SQL 문의 최종 조회 결과를 하나의 바구니로 생각한다

  (1) item 테이블의 첫번째 row에서

  (2) 그 row의 id(item.id) 값과 같은 값을 item_id(review.item_id) 컬럼에 가진 review 테이블의 row가 있는지 조회한다.

  (3) 만약에 존재하면(**EXISTS**) // 만약에 존재하지 않는다면(**NOT EXISTS**)

  (4) WHERE 절은 True가 되고 (1)에서 있었던 item 테이블의 row는 최종 조회 결과 바구니에 담긴다.

  (5) 이제 item 테이블의 두번째 row에 대해서 (2) ~ (4) 과정을 반복한다. 이렇게 item 테이블의 마지막 row까지 동일하게 (2) ~ (4)의 과정을 반복한다.

  (6) 최종적으로 item 테이블 중에서 그 id 컬럼 값이 review 테이블의 item_id 컬럼에 존재하는 row들만 추려진다.

```mysql
SELECT
    MAX(copang_report.price) AS max_price,
    AVG(copang_report.star) AS avg_star,
    COUNT(DISTINCT(copang_report.email)) AS distinct_email_count
FROM (
SELECT i.price, r.star, m.email
FROM review AS r
INNER JOIN `member` AS m ON m.id = r.mem_id
INNER JOIN item AS i ON i.id = r.item_id
) AS copang_report;
```

<br/>

## 서브쿼리로 alias 재활용 문제 해결

> 서브쿼리를 활용하면 읽기 쉬운 SQL 문을 작성하는데 도움이 될 수 있다.
>
> alias를 붙인 SELECT 문을 서브쿼리는 FROM 뒤에 있으니까 derived table로 인식되어 마치 원래 존재하던 테이블인 것처럼 outer query에서 자유롭게 사용할 수 있다.

| 조회 성능 UP / 가독성 DOWN                                   | 조회 성능 DOWN / 가독성 UP                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/64063767/112745444-6896e600-8fe3-11eb-8510-3ca53998bfb1.png" alt="image"  /> | <img src="https://user-images.githubusercontent.com/64063767/112745381-076f1280-8fe3-11eb-9436-1a4b17c00aa7.png" alt="image"  /> |

