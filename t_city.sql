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

TRUNCATE new_cities;

-- CREATE TABLE new_cities(
--   "City" VARCHAR(255),
--   "Postal Code" VARCHAR(100),
--   "Latitude" FLOAT,
--   "Longitude" FLOAT,
--   "State ID" INT,
--   "State" VARCHAR(255)
-- );

CREATE or REPLACE VIEW city_view AS(
   SELECT cust_city.*,s."State"
   FROM "Cust City" AS  cust_city
   JOIN "States" s 
   ON cust_city."State ID" = s."State ID"
);

SELECT 'divider' as component,
       'CITY' as contents;

SELECT
  'form' AS component,
  'city_filters' AS id,
  'Search' AS validate,
  'GET' AS method,
  'cyan' as  validate_color,
  'Reset' as reset,
  '' as action;

SELECT 
        'City ID' as label,
        'city_id[]' as name,
        $city_id as placeholder,
        'select' as type,
        'All' as empty_option,
        TRUE as multiple,
        TRUE as dropdown,
        4 as width,
        json_agg(json_build_object('label',"City ID" ,'value',"City ID")) as options 
        FROM(SELECT DISTINCT "City ID" FROM city_view ORDER BY "City ID" ASC) as id_list;
SELECT 
        'City' as label,
        'city_n[]' as name,
        $city_n as placeholder,
        'select' as type,
        'All' as empty_option,
        TRUE as multiple,
        TRUE as dropdown,
        4 as width,
        json_agg(json_build_object('label',"City" ,'value',"City")) as options 
        FROM(SELECT DISTINCT "City" FROM city_view ORDER BY "City" ASC) as city_list;

SELECT 
        'State' as label,
        'city_state[]' as name,
        'select' as type,
        'All' as empty_option,
        $city_state as placeholder,
        TRUE as dropdown,
        TRUE as multiple,
        4 as width,
        json_agg(json_build_object('label',"State",'value',"State")) as options
        FROM(SELECT "State"FROM city_view ORDER BY "State" ASC) as state_list;


SELECT 'csv' as component,
       'City' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;
SELECT * FROM city_view
WHERE(
        $city_id IS NULL 
        OR "City ID" IN (SELECT (json_array_elements_text($city_id::JSON)::INT))
)
AND(
    $city_n IS NULL 
        OR "City" IN (SELECT json_array_elements_text($city_n::JSON))
)
AND(
    $city_state IS NULL 
        OR "State" IN (SELECT json_array_elements_text($city_state::JSON))
)
ORDER BY "City ID" ASC;

SELECT 'button' as component,
       'sml' as size,
       'end' as justify;

SELECT 
       'cyan' as outline,
       'Add' as title,
       'city_new.sql' as link;


SELECT 'table' as component,
   TRUE    as freeze_columns,
   TRUE    as freeze_headers,
   TRUE    as hover,
   TRUE    as striped_rows,
   TRUE    as sort,
   TRUE    as search;


SELECT * FROM city_view
WHERE(
        $city_id IS NULL 
        OR "City ID" IN (SELECT (json_array_elements_text($city_id::JSON)::INT))
)
AND(
    $city_n IS NULL 
        OR "City" IN (SELECT json_array_elements_text($city_n::JSON))
)
AND(
    $city_state IS NULL 
        OR "State" IN (SELECT json_array_elements_text($city_state::JSON))
)
ORDER BY "City ID" ASC;


