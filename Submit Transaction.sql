--Update orders table.
INSERT INTO "Orders" ("Order Number", "Order Status ID", "Order Date", "Customer ID")
SELECT DISTINCT ON ("Order Number") 
       "Order Number"::INT, 
       "Order Status"::INT, 
       NOW()::DATE, 
       "Customer"
FROM temp_items
WHERE "Message" = 'Successful';


--Update Purchases
INSERT INTO Purchases("Order Number","Customer ID","Customer Name","Product Code","Deal Size ID","Quantity Ordered","Price Each","Sales","Message","Update Date","Deal Size")
SELECT "Order Number",
       "Customer",
       "Customer Name",
       item,
       "Deal ID",
       "Quantity Ordered",
       "Price Each",
       "Sales",
       "Message",
       NOW(),
       ''
FROM temp_items
WHERE "Message" = 'Successful';

UPDATE  purchases p
SET "Deal Size" = ds."Deal Size"
FROM(
     SELECT "Deal ID",
	        "Deal Size"
	 FROM "Deal Size"
) AS ds
WHERE p."Deal Size ID" = ds."Deal ID"
AND p."Deal Size" ='';


-- Update transactions table

INSERT INTO "Transactions" (
  "Transaction ID","Product Code", "Order Number", "Order Line Number",
  "Deal ID", "Quantity Ordered", "Price Each", "Sales","Transaction Date"
)
SELECT 
("Order Number"::TEXT || ROW_NUMBER() OVER (ORDER BY item)::TEXT)::INT AS "Transaction ID",
  item,
  "Order Number",
  ROW_NUMBER() OVER (ORDER BY item) AS "Order Line Number",
  "Deal ID",
  "Quantity Ordered",
  "Price Each",
  "Sales",NOW()
FROM (
  SELECT 
    item,
    "Order Number",
    "Deal ID",
    SUM("Quantity Ordered") AS "Quantity Ordered",
    SUM("Price Each") AS "Price Each",
    SUM("Sales") AS "Sales"
  FROM temp_items
   WHERE "Message" = 'Successful'
  GROUP BY item, "Order Number", "Deal ID"
) AS aggregated;

--Update inventory accordingly.
WITH sold AS (
  SELECT item, SUM("Quantity Ordered") AS total_qty
  FROM temp_items
  WHERE "Message" = 'Successful'
  GROUP BY item
)
UPDATE "Inventory" i
SET "Available Quantity" = i."Available Quantity" - sold.total_qty
FROM sold
WHERE i."Product Code" = sold.item
  AND i."Available Quantity" >= sold.total_qty;

TRUNCATE temp_items RESTART IDENTITY;

SELECT 'redirect' AS component, 'Get Transactions Template.sql' AS link;



