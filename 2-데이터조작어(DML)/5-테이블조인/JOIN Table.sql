USE copang_main;

-- LEFT OUTER JOIN
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
FROM  item AS old
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
ON old.id = new.id; -- 두 컬럼 이름이 같다면, ON old.id = new.id 대신 USNIG(id) 사용가능


-- 집합 연산
-- UNION(합집합, 중복 row 삭제)
SELECT * FROM item
UNION
SELECT * FROM item_new;


-- 서로 다른 3개의 테이블 조인하기
SELECT 
	i.name, i.id, 
	r.item_id, r.star, r.comment, r.mem_id, 
	m.id, m.email
FROM item AS i 
LEFT OUTER JOIN review AS r ON r.item_id = i.id
LEFT OUTER JOIN `member` AS m ON r.mem_id = m.id;

-- 여성이 구매한 별점 평균이 좋은 상품과 리뷰 수 조회
SELECT i.id, i.name, AVG(star), COUNT(*)
FROM item AS i 
LEFT OUTER JOIN review AS r ON r.item_id = i.id
LEFT OUTER JOIN `member` AS m ON r.mem_id = m.id
WHERE m.gender = 'f'
GROUP BY i.id, i.name
HAVING COUNT(*) > 1
ORDER BY AVG(star) DESC, COUNT(*) DESC;