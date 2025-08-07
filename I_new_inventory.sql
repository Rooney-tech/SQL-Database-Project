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

-- CREATE TABLE temp_inventory(
--     "Product Code" VARCHAR(100),
--     "Available Quantity" INT
--     );
SELECT
  'form' AS component,
   'cyan' as validate_color,
   'Go' as validate,
  '/I_copy_inventory.sql' as action,
  'multipart/form-data' AS enctype;

SELECT
  'new_inventory' AS name,
  'file' AS type,
  'text/csv' AS accept,
  '' AS label,
  'Upload a CSV with ''Product Code'' and ''Available Quantity'' as columns' AS description,
  TRUE AS required;


UPDATE temp_inventory t
SET "Message" = CASE
  WHEN NOT EXISTS (
    SELECT 1 FROM "Products" p
    WHERE p."Product Code" = t."Product Code"
  ) THEN 'Not Found'
  WHEN t."Available Quantity" < 1 THEN 'Invalid Quantity'
  ELSE 'Successful'
END;

SELECT 'table' AS component, 'Imported Inventory' AS title
WHERE EXISTS(SELECT 1 FROM temp_inventory);

SELECT * FROM temp_inventory;

SELECT 'button' as component,
       'sml' as size
       WHERE EXISTS(SELECT 1 FROM temp_inventory);


SELECT 'cyan' as outline,
       'Submit' as title,
       '/I_submit_inventory' as link
       WHERE EXISTS(SELECT 1 FROM temp_inventory);

