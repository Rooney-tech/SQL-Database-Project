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

CREATE OR REPLACE VIEW cntry_new AS (
  SELECT
    cn.*,
    c."Country" AS "Check",
    CASE
      WHEN c."Country" IS NULL THEN 'Successful'
      ELSE 'Country already exists'
    END AS "Message",
    CASE
      WHEN c."Country" IS NULL THEN 'green'
      ELSE 'red'
    END AS _sqlpage_color
  FROM cntr_new cn
  LEFT JOIN "Country" c 
    ON LOWER(c."Country") = LOWER(cn."Country")
);
-- Define the main form
SELECT 'form' AS component, 
       '' AS title,
       'cyan' as validate_color,
       'cntry_copy.sql' as action,
       'Check' as validate;

SELECT 'Items' AS label,
       'items_cntry' AS name,
       'textarea' AS type,
       'Paste country names (each separated by  a comma)' AS placeholder,
       TRUE AS required;


SELECT 'csv' as component,
       'Customer.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;

SELECT 
"ID",
"Country",
"Check",
"Message"
FROM cntry_new
WHERE "Message"<> 'Successful';

SELECT 'table' as component,
TRUE    as freeze_columns,
TRUE    as freeze_headers,
TRUE    as hover,
TRUE    as striped_rows,
TRUE    as sort,
TRUE    as search
WHERE EXISTS(SELECT 1 FROM cntry_new);

SELECT * FROM cntry_new;

SELECT 'button' as component,
       'sml' as size,
       'end' as justify;
       
SELECT 
       'cyan' as outline,
       'Submit' as title,
       'cntry_submit.sql' as link
       WHERE EXISTS(
        SELECT 1 FROM cntry_new
       WHERE "Message" = 'Successful'
       );



