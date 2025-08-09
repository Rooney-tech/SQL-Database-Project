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
       'STATE' as contents;
       
-- CREATE VIEW state_view As(
--     SELECT s.*, c."Country"
--     FROM
--     "States" s
--     JOIN "Country" c
--     ON s."Cntry ID"  = c."Cntry ID"
-- );


TRUNCATE states_new;

SELECT
  'form' AS component,
  'order_sales_filter' AS id,
  'Search' AS validate,
   'cyan' as validate_color,
  'Reset' as reset,
  'GET' AS method;

SELECT 
        'Country' as label,
        'country_s[]' as name,
        $country_s as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        6 as width,
        json_agg(json_build_object('label',"Country" ,'value',"Country")) as options 
        FROM(SELECT DISTINCT "Country" FROM state_view ORDER BY "Country" ASC) as cntry_lst;

SELECT 
        'State 'label,
        'select' as type,
        'state_s[]' as name,
        $state_s as placeholder,
        'All' as empty_option,
        TRUE as dropdown,
        TRUE as multiple,
        6 as width,
        json_agg(json_build_object('label',"State",'value',"State")) as options
        FROM(SELECT DISTINCT "State" FROM state_view ORDER BY "State" ASC) as st_list;


SELECT 'csv' as component,
       'States.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;

SELECT * FROM state_view
WHERE (
    $state_s IS NULL
    OR "State" IN (SELECT json_array_elements_text($state_s::JSON)) 
)
AND($country_s IS NULL
    OR "Country" IN (SELECT json_array_elements_text($country_s::JSON)) )
ORDER BY "State ID" ASC;

-- button to create new order
SELECT 'button' as component,
       'sml' as size,
       'end' as justify;

SELECT 
       'cyan' as outline,
       'Add' as title,
       's_new_state.sql' as link;


SELECT 'table' as component,
   TRUE    as freeze_columns,
   TRUE    as freeze_headers,
   TRUE    as hover,
   TRUE    as striped_rows,
   TRUE    as sort,
   TRUE    as search,
  'table' as icon;


SELECT * FROM state_view
WHERE (
    $state_s IS NULL
    OR "State" IN (SELECT json_array_elements_text($state_s::JSON)) 
)
AND($country_s IS NULL
    OR "Country" IN (SELECT json_array_elements_text($country_s::JSON)) )
ORDER BY "State ID" ASC;