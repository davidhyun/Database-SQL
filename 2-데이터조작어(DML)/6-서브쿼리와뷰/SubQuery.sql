-- 서브쿼리 기본 동작
SELECT i.id, i.name, AVG(star) AS avg_star
FROM item AS i 
LEFT OUTER JOIN review AS r
ON r.item_id = i.id
GROUP BY i.id, i.name
HAVING avg_star < (SELECT AVG(star) FROM review)
ORDER BY avg_star DESC;

-- SELECT 절 안의 서브쿼리
SELECT 
	id, 
	name, 
    price, 
    (SELECT MAX(price) FROM item) AS max_price,
    (SELECT MAX(price) FROM item) - price AS diff
FROM item;

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

-- ANY(or SOME), ALL의 역할
SELECT name, price
FROM item
WHERE price > ANY(SELECT price FROM item WHERE gender = 'm');

SELECT name, price
FROM item
WHERE price > ALL(SELECT price FROM item WHERE gender = 'm');

-- 오래 전에 등록됐지만 아직까지도 리뷰가 달리고 있는 스테디 셀러 상품들의 리뷰 조회
SELECT * 
FROM review
WHERE item_id IN
(
SELECT id
FROM item
WHERE registration_date < '2018-12-31'
);

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

-- 상관 서브쿼리(Correlated Subquery)
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