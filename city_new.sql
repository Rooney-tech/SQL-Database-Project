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

CREATE OR REPLACE VIEW city_inserts AS
SELECT subns.*,
  CASE 
     WHEN subns."State" IS NULL THEN 'State does not exist. Please add.'
     WHEN subns."Partition Row Number" > 1 THEN 'Repeated'
     WHEN subns."Check" IS NOT NULL THEN 'City already exists.'
     ELSE 'Successful'
     END AS "Message",
  CASE 
     WHEN subns."State" IS NULL OR subns."Partition Row Number" > 1  OR subns."Check" IS NOT NULL THEN 'red'
     ELSE 'green'
     END AS _sqlpage_color
FROM (
    SELECT t.*,
           ROW_NUMBER() OVER (PARTITION BY t."City") AS "Partition Row Number",
           cu."City" AS "Check"
    FROM new_cities t
    LEFT JOIN "Cust City" cu ON cu."City" = t."City"
) AS subns;


SELECT
  'form' AS component,
  'add_city' AS id,
  'Check' AS validate,
  'city_copy' as action,
  'cyan' as validate_color,
  'Reset' as reset;

SELECT 'file' as type,
        'new_city' as name,
        8 as width,
        '' as label,
        'Upload a CSV file with City, Postal Code,Latitude, Longitude, State ID as columns' as description_md,
        TRUE as required,
         'text/csv,text/plain' AS accept;


SELECT 'table' as component,
   TRUE    as freeze_columns,
   TRUE    as freeze_headers,
   TRUE    as hover,
   TRUE    as striped_rows,
   TRUE    as sort,
   TRUE    as search,
  'table' as icon
  WHERE EXISTS(SELECT 1 FROM city_inserts);

  SELECT * FROM city_inserts;

SELECT 'button' as component,
       'sml' as size,
       'end' as justify;

SELECT 
       'cyan' as outline,
       'Submit' as title,
       'city_submit.sql' as link
       WHERE EXISTS(SELECT 1 FROM city_inserts WHERE "Message" ='Successful');





