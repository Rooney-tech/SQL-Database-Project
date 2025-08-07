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

--  CREATE VIEW new_states_add_view AS( 
-- SELECT 
--   "State",
--   "Cntry ID",
--   "Country",
--   "Check",
--  CASE 
--   WHEN "Cntry ID" IS NULL THEN 'Country does not exist. Please add.'
--   WHEN rn > 1 THEN 'Repeated'
--   WHEN "Check" IS NOT NULL THEN 'State already exists'
--   ELSE 'Successful'
--   END AS "Message",
--   CASE 
--     WHEN "Cntry ID" IS NULL OR rn > 1 OR "Check" IS NOT NULL THEN 'red'
--     ELSE 'green'
--   END AS _sqlpage_color
-- FROM (
--   SELECT 
--     n.*,
--     ROW_NUMBER() OVER (PARTITION BY n."State" ORDER BY n."State") AS rn,
--     s."State" AS "Check"
--   FROM states_new n
--   LEFT JOIN "States" s ON s."State" = n."State"
-- ) sub
--  );

SELECT
  'form' AS component,
  'add_state' AS id,
  'Check' AS validate,
   'cyan' as validate_color,
  's_copy_state.sql' as action,
  'Reset' as reset;

SELECT 'file' as type,
        'new_state' as name,
        8 as width,
        '' as label,
        'Upload a CSV file with State, Country as columns' as description_md,
        TRUE as required,
         'text/csv,text/plain' AS accept;

SELECT 'csv' as component,
       'Failed States.csv' as filename,
       'md' as size,
       'Export failed' as title,
       'cyan' as color,
       'file-download' as icon
       WHERE EXISTS(SELECT 1 FROM new_states_add_view WHERE "Message"<>'Successful');

SELECT * FROM new_states_add_view 
WHERE "Message" <>'Successful';

SELECT 'table' as component,
   TRUE    as freeze_columns,
   TRUE    as freeze_headers,
   TRUE    as hover,
   TRUE    as striped_rows,
   TRUE    as sort,
   TRUE    as search,
  'table' as icon
   WHERE EXISTS(SELECT 1 FROM states_new);

SELECT * FROM new_states_add_view


SELECT 'button' as component,
       'sml' as size,
       'end' as justify
       WHERE EXISTS(SELECT 1 FROM new_states_add_view WHERE "Message"= 'Successful');

SELECT 
       'cyan' as outline,
       'Submit' as title,
        'cyan' as outline,
       's_submit_state.sql' as link
       WHERE EXISTS(SELECT 1 FROM new_states_add_view WHERE "Message"= 'Successful');












