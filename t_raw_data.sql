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

SELECT 'divider' as component,
       'Raw Data' as contents;

SET max_date = SELECT max("Order Date") FROM "Order Sales";
SET min_date =SELECT min("Order Date") FROM "Order Sales";
SET date_end_start = COALESCE(TO_DATE($date_end_start,'YYYY-MM-DD'),TO_DATE($min_date ,'YYYY-MM-DD'));
SET date_end_end   = COALESCE(TO_DATE($date_end_end,'YYYY-MM-DD'),TO_DATE($max_date,'YYYY-MM-DD'));


SELECT
  'form' AS component,
  'order_sales_filter' AS id,
  'Search' AS validate,
   'cyan' as validate_color,
  'Reset' as reset,
  'GET' AS method;


SELECT 
        'Start Date' as label,
        'date_end_start' as name,
        $date_end_start as value,
        'date' as type,
        3 as width;

SELECT 
        'End Date' as label,
        'date_end_end' as name,
        $date_end_end as value,
        'date' as type,
        3 as width;
SELECT 
        'Country' as label,
        'country[]' as name,
        $country as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        3 as width,
        json_agg(json_build_object('label',"Country" ,'value',"Country")) as options 
        FROM(SELECT DISTINCT "Country" FROM "Order Sales" ORDER BY "Country" ASC) as cntry_lst;

SELECT 
        'Status'label,
        'select' as type,
        'order_status[]' as name,
        $order_status as placeholder,
        'All' as empty_option,
        TRUE as dropdown,
        TRUE as multiple,
        3 as width,
        json_agg(json_build_object('label',"Status",'value',"Status")) as options
        FROM(SELECT DISTINCT "Status" FROM "Order Sales" ORDER BY "Status" ASC) as st_list;

SELECT 'csv' as component,
       'Order Sales.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;

SELECT * FROM(
   SELECT * FROM "Order Sales"
   WHERE "Order Date" BETWEEN TO_DATE($date_end_start,'YYYY-MM-DD') 
   AND TO_DATE($date_end_end,'YYYY-MM-DD')
   AND (
    $country IS NULL
     OR
    "Country" IN (SELECT json_array_elements_text(CAST($country AS JSON)))
   )
   AND ( $order_status IS NULL 
   OR
    "Status" IN (SELECT json_array_elements_text(CAST($order_status AS JSON)))
   )
   );


SELECT 'table' as component,
   TRUE    as freeze_columns,
   TRUE    as freeze_headers,
   TRUE    as hover,
   TRUE    as striped_rows,
   TRUE    as sort,
   TRUE    as search,
  'table' as icon;

SELECT * FROM(
   SELECT * FROM "Order Sales"
   WHERE "Order Date" BETWEEN TO_DATE($date_end_start,'YYYY-MM-DD') 
   AND TO_DATE($date_end_end,'YYYY-MM-DD')
   AND (
    $country IS NULL
     OR
    "Country" IN (SELECT json_array_elements_text(CAST($country AS JSON)))
   )
   AND ( $order_status IS NULL 
   OR
    "Status" IN (SELECT json_array_elements_text(CAST($order_status AS JSON)))
   )
   );