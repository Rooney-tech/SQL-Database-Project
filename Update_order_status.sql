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

TRUNCATE updated_order_status;

SELECT
  'form' AS component,
  'Update Orders' as title,
   'cyan' as validate_color,
  'Update_order_status.sql' AS action,
  'Check' as validate;

SELECT
  'select' AS type,
  'Order Number' AS label,
  'order_numbers[]' AS name, 
  $order_numbers as placeholder,
  6 AS width,
  TRUE AS required, 
  'Select order number...' AS empty_option,
  TRUE AS searchable, 
  TRUE AS multiple,
  (
    SELECT json_agg(json_build_object('label', "Order Number", 'value', "Order Number"))
    FROM(
    SELECT "Order Number"
    FROM "Orders"
    ORDER BY "Order Number" DESC
  ))AS options; -- Sub-query helps us group the order numbers in descending order so as to get the latest orders.


SELECT
        'select' AS type,
        'New Order Status' AS label,
        6 as width,
        'new_status' AS name, 
        $new_status as placeholder,
        TRUE AS required, 
        'Select order status...' as empty_option, 
        TRUE AS searchable, 
        (SELECT json_agg(json_build_object('label',"Status",'value',"Status ID"))FROM "Order Status") as options;

WITH updated_order AS (
  SELECT 
    unnest(string_to_array(
      regexp_replace(CAST(:order_numbers AS TEXT), '[\[\]"]', '', 'g'),
      ','
    )::INT[]) AS "Order Number"
)
INSERT INTO updated_order_status ("Order Number")
SELECT * FROM updated_order;


-- Step 1: Set the Status ID
UPDATE updated_order_status
SET "New Status ID" = :new_status::INT;

-- Step 2: Set the Status label based on the new ID
UPDATE updated_order_status u
SET "New Status" = (
  SELECT o."Status"
  FROM "Order Status" o
  WHERE o."Status ID" = u."New Status ID"
);

UPDATE updated_order_status u
SET "Old Status" = os."Status"
FROM (
  SELECT o."Order Number",
         o."Order Status ID",
         s."Status"
  FROM "Orders" o
  JOIN "Order Status" s
    ON s."Status ID" = o."Order Status ID"
) AS os
WHERE u."Order Number" = os."Order Number";

SELECT 'divider' as component,
        'UPDATE' as contents
        WHERE EXISTS (SELECT 1 FROM updated_order_status)

SELECT 'table' AS component
WHERE EXISTS (SELECT 1 FROM updated_order_status)

SELECT 
"Order Number",
"Old Status",
"New Status ID",
"New Status"
 FROM updated_order_status;


--form to help update inventory
SELECT 'button' as component,
       'sml' as size,
       'end' as justify

SELECT 'cyan' as outline,
       'Submit' as title,
       '/submit order status updates.sql' as link
       WHERE EXISTS (SELECT 1 FROM updated_order_status);





