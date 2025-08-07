UPDATE "Inventory" i
SET "Available Quantity" = i."Available Quantity" + inV_up.added_qty
FROM (
  SELECT t."Product Code", 
         SUM(t."Available Quantity") AS added_qty
  FROM temp_inventory t
  WHERE t."Message" = 'Successful'
  GROUP BY t."Product Code"
) AS inV_up
WHERE i."Product Code" = inV_up."Product Code";

TRUNCATE temp_inventory;

SELECT 'redirect' AS component,
't_inventory.sql' as link;