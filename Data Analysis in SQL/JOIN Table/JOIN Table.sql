SELECT stock.item_id, item.name
FROM stock
INNER JOIN item ON item.id = stock.item_id;