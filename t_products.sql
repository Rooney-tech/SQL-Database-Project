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

TRUNCATE new_product;

SELECT 'divider' as component,
       'Products' as contents;


DROP TABLE IF EXISTS products;

CREATE TEMP TABLE products AS (
  SELECT 
    p."Product Code",
    p."Manfucturer Specied Retail Price",
    p."Line Code",
    pr."Product Line",
    p."Update Date"
  FROM "Products" AS p
  JOIN "Product Line" AS pr
    ON p."Line Code" = pr."Line Code"
);

SET max_date_pr = SELECT max("Update Date") FROM products;
SET min_date_pr =SELECT min("Update Date") FROM products;
SET date_end_start_pr = COALESCE(TO_DATE($date_end_start_pr,'YYYY-MM-DD'),TO_DATE($min_date_pr ,'YYYY-MM-DD'));
SET date_end_end_pr  = COALESCE(TO_DATE($date_end_end_pr,'YYYY-MM-DD'),TO_DATE($max_date_pr,'YYYY-MM-DD'));

SELECT *
FROM (
  SELECT 
    p."Product Code",
    p."Manfucturer Specied Retail Price",
    p."Line Code",
    pr."Product Line",
    p."Update Date"
  FROM "Products" p
  JOIN "Product Line" pr
    ON p."Line Code" = pr."Line Code"
) AS products;


SELECT
  'form' AS component,
  'order_sales_filter' AS id,
  'Search' AS validate,
  'Reset' as reset,
  'GET' AS method;


SELECT 
        'Start Date' as label,
        'date_end_start_pr' as name,
        $date_end_start_pr as value,
        'date' as type,
        3 as width;

SELECT 
        'End Date' as label,
        'date_end_end_pr' as name,
        $date_end_end_pr as value,
        'date' as type,
        3 as width;
SELECT 
        'Product Code' as label,
        'product_code_pr[]' as name,
        $product_code_pr as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        3 as width,
        json_agg(json_build_object('label',"Product Code" ,'value',"Product Code")) as options 
        FROM(SELECT DISTINCT "Product Code" FROM products ORDER BY "Product Code" ASC) as pr_lst;

SELECT 
        'Product Line' as label,
        'select' as type,
        'product_line_pr[]' as name,
        $product_line_pr as placeholder,
        'All' as empty_option,
        TRUE as dropdown,
        TRUE as multiple,
        3 as width,
        json_agg(json_build_object('label',"Product Line",'value',"Product Line")) as options
        FROM(
            SELECT DISTINCT "Line Code", "Product Line" 
            FROM products 
            ORDER BY "Line Code" ASC
            ) as line_code_list;

SELECT 'csv' as component,
       'Order Sales.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;

SELECT *
FROM products
WHERE "Update Date" BETWEEN TO_DATE($date_end_start_pr,'YYYY-MM-DD') AND TO_DATE($date_end_end_pr,'YYYY-MM-DD')
AND(
    $product_code_pr IS NULL 
    OR "Product Code" IN (
        SELECT json_array_elements_text($product_code_pr::JSON)
    )
)
AND(
    $product_line_pr IS NULL 
    OR "Product Line" IN (SELECT json_array_elements_text($product_line_pr::JSON)
)
); 
-- button to help add new products
SELECT 'button' as component,
       'sml' as size,
       'end' as justify;

SELECT 'cyan' as outline,
       'New Product' as title,
       '/p_new_form.sql' as link;

    
SELECT 'table' as component,
TRUE    as freeze_columns,
TRUE    as freeze_headers,
TRUE    as hover,
TRUE    as striped_rows,
TRUE    as sort,
TRUE    as search,
'https://tabler.io/icons/icon/table' as icon;

SELECT *
FROM products
WHERE "Update Date" BETWEEN TO_DATE($date_end_start_pr,'YYYY-MM-DD') AND TO_DATE($date_end_end_pr,'YYYY-MM-DD')
AND(
    $product_code_pr IS NULL 
    OR "Product Code" IN (
        SELECT json_array_elements_text($product_code_pr::JSON)
    )
)
AND(
    $product_line_pr IS NULL 
    OR "Product Line" IN (SELECT json_array_elements_text($product_line_pr::JSON)
)
);
