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


CREATE OR REPLACE VIEW new_customer_view AS
SELECT 
  custsub.*,  
  CASE
    WHEN custsub."Check" IS NOT NULL THEN 'Customer already exists'
    WHEN custsub."Partition Row Number" > 1 THEN 'Repeated'
    WHEN custsub."City" IS NULL THEN 'City does not exist. Please add.'
    ELSE 'Successful'
  END AS "Message",
  CASE 
     WHEN custsub."Check" IS NOT NULL OR  custsub."Partition Row Number" > 1 OR custsub."City" IS NULL THEN 'red'
     ELSE 'green'
     END AS _sqlpage_color
FROM (
  SELECT 
    tmp.*,
    c."Customer Name" AS "Check",
    ROW_NUMBER() OVER (PARTITION BY tmp."Customer Name") AS "Partition Row Number"
  FROM temp_customer tmp
  LEFT JOIN "Customer" c
    ON c."Customer Name" = tmp."Customer Name"
) AS custsub;


--form to add new customers
select 'form' as component,
       'c_copy_custoner.sql' as action,
       'cyan' as validate_color,
       'Check' as validate;
     

select 'new_customer' as name,
       'file' as type,
       'text/csv' as accept,
       'New customer',
       'Upload CSV with ''Customer Name'',''Contact Name'',''Phone'',''Addressline 1'',''City' as description,
       'Add customer' as label;

SELECT 'divider' as component,
       'New Customers' as contents
       WHERE EXISTS( SELECT 1 FROM new_customer_view);

SELECT 'table' as component,
TRUE    as freeze_columns,
TRUE    as freeze_headers,
TRUE    as hover,
TRUE    as striped_rows,
TRUE    as sort,
TRUE    as search,
'table' as icon
WHERE EXISTS(SELECT 1 FROM new_customer_view) ;

SELECT * FROM new_customer_view;


SELECT 'button' as component,
       'sml' as size,
       'end' as justify
       WHERE EXISTS(SELECT 1 FROM new_customer_view WHERE "Message" = 'Successful');

SELECT 'cyan' as outline,
       'Submit' as title,
       'c_submit_new_customer.sql' as link
      WHERE EXISTS(SELECT 1 FROM new_customer_view WHERE "Message" = 'Successful');