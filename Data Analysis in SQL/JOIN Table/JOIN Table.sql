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