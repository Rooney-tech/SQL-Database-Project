SELECT 'shell' AS component,
  '👌SQL Project' AS title,
  TRUE AS fixed_top_menu,
  'dark' AS theme,
  'golf' AS icon,
  JSON('[
  { "title": "Home", "link": "index.sql", "icon": "home" },
  { "title": "About", "link": "/about.sql", "icon": "info-square" },

  {
    "title": "Sales",
    "icon": "section",
    "submenu": [
      { "title": "Orders", "link": "t_orders.sql", "icon": "table" },
      { "title": "Purchases", "link": "t_purchases.sql", "icon": "table" },
      { "title": "Transactions", "link": "t_transactions.sql", "icon": "table" },
      { "title": "Order Status", "link": "t_ord_status.sql", "icon": "table" },
      { "title": "Deal Size", "link": "t_deal_size.sql", "icon": "table" }
    ]
  },

  {
    "title": "Product",
    "icon": "section",
    "submenu": [
      { "title": "Products", "link": "t_products.sql", "icon": "table" },
      { "title": "Product Line", "link": "t_products_line.sql", "icon": "table" },
      { "title": "Inventory", "link": "t_inventory.sql", "icon": "table" }
    ]
  },

  {
    "title": "Customer Info",
    "icon": "section",
    "submenu": [
      { "title": "Customer", "link": "t_customer.sql", "icon": "table" },
      { "title": "State", "link": "t_states.sql", "icon": "table" },
      { "title": "Country", "link": "t_country.sql", "icon": "table" },
      { "title": "City", "link": "t_city.sql", "icon": "table" }
    ]
  },
 { "title": "Raw Data", "link": "t_raw_data.sql", "icon": "section" }
]') AS menu_item,
     '' AS footer,
      'Poppins'               as font,
     'en-US' as language,
      'Menu' as navbar_title,
      '' as search_value,
      --30 as refresh,
  TRUE AS sidebar;

SET  order_number = SELECT COALESCE(MAX("Order Number"::INT), 0) + 1 FROM "Orders";

       -- Define the main form
SELECT 'form' AS component, 
       '' AS title,
       'cyan' as validate_color,
       'Check' as validate;

SELECT 'Order Number' AS label, 
       'order_num' AS name, 
       TRUE AS required, 
       3 AS width, 
    $order_number AS placeholder,
      $order_number AS value,
      TRUE AS readonly;

-- First step: Select customer
SELECT 'Customer' AS label, 
       'customer' AS name, 
       'select' AS type,
        TRUE AS required, 
       'Select customer...' AS empty_option,
       TRUE AS searchable,
       3 AS width,
       (SELECT json_agg(json_build_object('label', "Customer Name", 'value', "Cust ID")) FROM "Customer") AS options;


SELECT 'Deal Size' AS label, 
       'deal_size' AS name, 
       'select' AS type, 
       TRUE AS required, 
       'Select Deal Size...' as empty_option, 
       TRUE AS searchable, 
       3 as width, 
       (SELECT json_agg(json_build_object('label',"Deal Size",'value',"Deal ID"))FROM "Deal Size") as options;
      -- WHERE :customer IS NOT NULL; --Ensures the field appears only after selecting customer


SELECT 'Order Status' AS label, 
       'order_status' AS name, 
       'select' AS type, 
       TRUE AS required, 
       'Select order status...' as empty_option, 
       TRUE AS searchable, 
       3 as width, 
       (SELECT json_agg(json_build_object('label',"Status",'value',"Status ID"))FROM "Order Status") as options;


SELECT 'Items' AS label,
       'items_text' AS name,
       'textarea' AS type,
       'Paste items each separated by  a comma, e.g  S10_2016' AS placeholder,
       TRUE AS required;

SELECT 'text' as component,
        '' as contents;

SELECT 'divider' as component,
     'New Order Details' as contents
 WHERE :customer IS NOT NULL;

-- 2. Ensure the the "temp_tems" table exists before inserting items.


TRUNCATE temp_items RESTART IDENTITY;

-- 4. Insert new items, splitting input by line breaks and removing empty lines
INSERT INTO temp_items (item, "Order Number", "Customer", "Deal ID", "Order Status","Quantity Ordered", "Price Each", "Sales","Product Total","Inventory Qty","Message","Customer Name")
SELECT trim(value), :order_num::INT, :customer::INT,:deal_size::INT,:order_status::INT, 1, NULL,NULL, NULL,NULL,'',''
FROM regexp_split_to_table(:items_text, ',') AS value
WHERE INITCAP(trim(value)) <> '';


UPDATE temp_items ti
SET "Price Each" = p."Manfucturer Specied Retail Price"
FROM "Products" p
WHERE ti.item = p."Product Code"
AND ti."Price Each" IS NULL;

UPDATE temp_items
SET "Sales" = "Quantity Ordered" * "Price Each"
WHERE "Price Each" IS NOT NULL;

UPDATE temp_items
SET "Product Total" = totals.total_quantity
FROM (
    SELECT item, SUM("Quantity Ordered") AS total_quantity
    FROM temp_items
    GROUP BY item
) AS totals
WHERE temp_items.item = totals.item;

UPDATE temp_items
SET "Inventory Qty" = "Available Quantity"    
FROM(
   SELECT "Product Code",
              "Available Quantity"
              FROM "Inventory") AS inventory
WHERE temp_items.item = inventory."Product Code";

UPDATE temp_items
SET "Message" = CASE
                   WHEN "Price Each" IS NULL THEN 'Wrong product!'
                   WHEN "Product Total">"Inventory Qty" THEN 'Not enough inventory'
                   ELSE 'Successful'
               END;

UPDATE temp_items t
SET "Customer Name" = cst."Customer Name"
FROM(
       SELECT "Cust ID", 
               "Customer Name"
       FROM "Customer"
) AS cst
WHERE cst."Cust ID" = t."Customer";

-- We can conditionally show download button for failed orders if message displays 'Wrong product!'
SELECT 'csv' as component,
       'Failed_Order.csv' as filename,
       'sm' as size,
       'Export failed' as title,
       'green' as color
       WHERE EXISTS(SELECT 1 FROM temp_items WHERE "Message" <>'Successful');

SELECT * FROM temp_items WHERE "Message" <> 'Successful'

-- 5. Display the stored items in a table component
SELECT 'table' AS component
WHERE EXISTS(SELECT 1 FROM temp_items WHERE "Message"= 'Successful');

SELECT  item, "Order Number", "Quantity Ordered","Price Each","Product Total","Inventory Qty","Sales","Message",
CASE 
    WHEN "Message" = 'Successful' THEN 'green'
    WHEN "Message" IN ('Wrong product!', 'Not enough inventory') THEN 'red'
    ELSE 'gray'
  END AS _sqlpage_color
 FROM temp_items;


SELECT 'button' AS component,
       'md' AS size
       WHERE EXISTS(SELECT 1 FROM temp_items WHERE "Message"= 'Successful');

SELECT
       'purple' AS color,
       'Submit' AS title,
       '/Submit Transaction.sql' AS link
       WHERE EXISTS(SELECT 1 FROM temp_items WHERE "Message"= 'Successful');


