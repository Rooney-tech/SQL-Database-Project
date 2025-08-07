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
TRUNCATE temp_customer;

-- CREATE OR REPLACE VIEW customer_view AS (
--     SELECT 
--         cst.*, 
--         ct."City" AS "Cust City"
--     FROM "Customer" AS cst
--     JOIN "Cust City" AS ct ON cst."City ID" = ct."City ID"
--     JOIN "States" AS s ON ct."State ID" = s."State ID"
--     JOIN "Country" AS ctry ON s."Cntry ID" = ctry."Cntry ID"
-- );

SELECT 'divider' as component,
       'Customer' as contents;
SELECT
  'form' AS component,
  'customer_filter' AS id,
  'Search' AS validate,
   'cyan' as validate_color,
  'Reset' as reset,
  'GET' AS method;


SELECT 
        'Customer ID' as label,
        'customer_id[]' as name,
        $customer_id as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        3 as width,
        json_agg(json_build_object('label',"Cust ID" ,'value',"Cust ID")) as options 
        FROM(SELECT DISTINCT "Cust ID" FROM customer_view ORDER BY "Cust ID" ASC) as cntry_lst;

SELECT 
        'Customer Name' as label,
        'customer_n[]' as name,
        $customer_n as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        3 as width,
        json_agg(json_build_object('label',"Customer Name" ,'value',"Customer Name")) as options 
        FROM(SELECT DISTINCT "Customer Name" FROM customer_view ORDER BY "Customer Name" ASC) as cntry_lst;

 SELECT 
        'Contact Name' as label,
        'contact_n[]' as name,
        $contact_n as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        3 as width,
        json_agg(json_build_object('label',"Contact Name" ,'value',"Contact Name")) as options 
        FROM(SELECT DISTINCT "Contact Name" FROM customer_view ORDER BY "Contact Name" ASC) as cntry_lst;

SELECT 
        'City'label,
        'select' as type,
        'city[]' as name,
        $city as placeholder,
        'All' as empty_option,
        TRUE as dropdown,
        TRUE as multiple,
        3 as width,
        json_agg(json_build_object('label',"City",'value',"City")) as options
        FROM(SELECT DISTINCT "City" FROM customer_view  ORDER BY "City" ASC) as st_list;

SELECT 'csv' as component,
       'Customer.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;

SELECT * FROM customer_view
WHERE (
$customer_id IS NULL 
OR "Cust ID" IN (
    SELECT (json_array_elements_text($customer_id::JSON)::INT)
    )
)
  AND(
        $customer_n IS NULL 
OR "Customer Name" IN (
    SELECT json_array_elements_text($customer_n::JSON)
)
    )

 AND(
        $contact_n IS NULL 
OR "Contact Name" IN (
    SELECT json_array_elements_text($contact_n::JSON)
)
)
 AND(
        $city IS NULL 
OR "City" IN (
    SELECT json_array_elements_text($city::JSON)
)
)

--button to add a new customer
SELECT 'button' AS component,
       'sml' AS size,
       'end' as justify;

SELECT
       'cyan' AS outline,
       'Add' AS title,
       '/c_cust_form.sql' AS link;


SELECT 'table' as component,
TRUE    as freeze_columns,
TRUE    as freeze_headers,
TRUE    as hover,
TRUE    as striped_rows,
TRUE    as sort,
TRUE    as search,
'table' as icon;

SELECT * FROM customer_view
WHERE (
$customer_id IS NULL 
OR "Cust ID" IN (
    SELECT (json_array_elements_text($customer_id::JSON)::INT)
    )
)
  AND(
        $customer_n IS NULL 
OR "Customer Name" IN (
    SELECT json_array_elements_text($customer_n::JSON)
)
    )

 AND(
        $contact_n IS NULL 
OR "Contact Name" IN (
    SELECT json_array_elements_text($contact_n::JSON)
)
)
 AND(
        $city IS NULL 
OR "City" IN (
    SELECT json_array_elements_text($city::JSON)
)
)
    

