SELECT 'shell' AS component,
  '👌SQL Project' AS title,
  TRUE AS fixed_top_menu,
  'dark' AS theme,
  '' AS icon,
  JSON('[
  { "title": "Home", "link": "/", "icon": "home" },
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
      'comic' as font,
     'en-US' as language,
      'Menu' as navbar_title,
      '' as search_value,
      86400 as refresh,
  TRUE AS sidebar;

-- CREATE VIEW dashboard_view AS
-- SELECT t."Transaction ID",
--        t."Product Code",
-- 	   l."Product Line",
--        t."Order Number",
--        t."Order Line Number",
--        t."Quantity Ordered",
--        t."Price Each",
--        t."Sales",
--        t."Transaction Date",
--        t."Deal Size",
--        os."Status",
--        o."Order Date",
--        o."Customer ID",
--        c."Customer Name",
--        c."Contact Name",
--        cs."City",
--        cs."Postal Code",
--        cs."Latitude",
--        cs."Longitude",
--        s.*,
--        cntry."Country"
-- FROM "Transactions" t
-- JOIN "Orders" o ON o."Order Number" = t."Order Number"
-- JOIN "Customer" c ON c."Cust ID" = o."Customer ID"
-- JOIN "Order Status" os ON os."Status ID" = o."Order Status ID"
-- JOIN "Cust City" cs ON cs."City ID" = c."City ID"
-- JOIN "States" s ON cs."State ID" = s."State ID"
-- JOIN "Country" cntry ON s."Cntry ID" = cntry."Cntry ID"
-- JOIN "Products" p ON t."Product Code" = p."Product Code"
-- JOIN "Product Line" l ON p."Line Code" = l."Line Code";

--form to filter orders table
SET max_date_d = SELECT max("Transaction Date") FROM dashboard_view;
SET min_date_d =SELECT min("Transaction Date") FROM dashboard_view;
SET date_end_start_d = COALESCE(TO_DATE($date_end_start_d,'YYYY-MM-DD'),TO_DATE($min_date_d ,'YYYY-MM-DD'));
SET date_end_end_d  = COALESCE(TO_DATE($date_end_end_d,'YYYY-MM-DD'),TO_DATE($max_date_d,'YYYY-MM-DD'));

-- Time Intelligence Analysis

--QTD
SET same_Q_lstyr_start = DATE_TRUNC('quarter', TO_DATE($date_end_start_d, 'YYYY-MM-DD')) - INTERVAL '1 year';

SET same_Q_lstyr_end =  DATE_TRUNC('quarter', TO_DATE($date_end_start_d,'YYYY-MM-DD')) 
                        - INTERVAL '1 year' 
                        + INTERVAL '3 months'
                        - INTERVAL '1 day';

SET same_Q_crrntyr_start = DATE_TRUNC('quarter', TO_DATE($date_end_end_d, 'YYYY-MM-DD'));

SET same_Q_crrntyr_end =  DATE_TRUNC('quarter', TO_DATE($date_end_end_d,'YYYY-MM-DD'))
                        + INTERVAL '3 months'
                        - INTERVAL '1 day';

SET QTD = 
SELECT
  CASE
    WHEN sum_sales >= 1000000000 THEN TO_CHAR(ROUND((sum_sales/1000000000)::numeric,2),'FM999G999G999G990.00')::TEXT || 'B'
    WHEN sum_sales >= 1000000 THEN TO_CHAR(ROUND((sum_sales/1000000)::numeric,2), 'FM999G999G990.00')::TEXT || 'M'
    WHEN sum_sales >= 1000 THEN TO_CHAR(ROUND((sum_sales/1000)::numeric,2), 'FM999G990.00')::TEXT || 'K'
    ELSE TO_CHAR(sum_sales, 'FM999G990')::TEXT
  END AS formatted_amount
FROM (
  SELECT ROUND(SUM("Sales")::numeric,0) AS sum_sales
  FROM dashboard_view
  WHERE "Transaction Date" >= TO_DATE($same_Q_crrntyr_start, 'YYYY-MM-DD')
    AND "Transaction Date" <= TO_DATE($same_Q_crrntyr_end, 'YYYY-MM-DD')
    AND(
  $cntry_d IS NULL 
OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON))
)
AND(
  $product_code_d IS NULL
  OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON))
)
AND(
  $order_status_d IS NULL
  OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON))
)
AND(
  $deal_size_d IS NULL 
OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON))
)
);

SET QoQ =
SELECT
  ((q_data.curr_q_sales::FLOAT / NULLIF(q_data.same_q_lstyear_sales, 0)) - 1) * 100 AS qoq_percentage
FROM (
  SELECT
    SUM(CASE WHEN 
      "Transaction Date" >= TO_DATE($same_Q_crrntyr_start, 'YYYY-MM-DD') AND 
      "Transaction Date" <= TO_DATE($same_Q_crrntyr_end, 'YYYY-MM-DD')
    THEN "Sales" ELSE 0 END) AS curr_q_sales,

    SUM(CASE WHEN 
      "Transaction Date" >= TO_DATE($same_Q_lstyr_start, 'YYYY-MM-DD') AND 
      "Transaction Date" <= TO_DATE($same_Q_lstyr_end, 'YYYY-MM-DD')
    THEN "Sales" ELSE 0 END) AS same_q_lstyear_sales

  FROM dashboard_view
   WHERE
    ($cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON))) AND
    ($product_code_d IS NULL OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON))) AND
    ($order_status_d IS NULL OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON))) AND
    ($deal_size_d IS NULL OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON)))
) AS q_data;

--YTD
SET same_lstyr_start = DATE_TRUNC('year', TO_DATE($date_end_start_d, 'YYYY-MM-DD')) - INTERVAL '1 year';

SET same_lstyr_end =  DATE_TRUNC('year', TO_DATE($date_end_start_d,'YYYY-MM-DD')) 
                        +INTERVAL '1 year' 
                        - INTERVAL '1 day';

SET same_crrntyr_start = DATE_TRUNC('year', TO_DATE($date_end_end_d, 'YYYY-MM-DD'));

SET same_crrntyr_end =  DATE_TRUNC('year',TO_DATE($date_end_end_d,'YYYY-MM-DD'))+INTERVAL'1 year'- INTERVAL '1 day';
                        

SET YTD = 
SELECT
  CASE
    WHEN YTD_Sales >= 1000000000 THEN TO_CHAR(ROUND((YTD_Sales/1000000000)::numeric,2),'FM999G999G999G990.00')::TEXT || 'B'
    WHEN YTD_Sales >= 1000000 THEN TO_CHAR(ROUND((YTD_Sales/1000000)::numeric,2), 'FM999G999G990.00')::TEXT || 'M'
    WHEN YTD_Sales >= 1000 THEN TO_CHAR(ROUND((YTD_Sales/1000)::numeric,2), 'FM999G990.00')::TEXT || 'K'
    ELSE TO_CHAR(YTD_Sales, 'FM999G990')::TEXT
    END AS formatted_YTD
    FROM
(
  SELECT SUM("Sales") as YTD_Sales
  FROM dashboard_view
  WHERE "Transaction Date" >= TO_DATE($same_crrntyr_start, 'YYYY-MM-DD')
    AND "Transaction Date" <= TO_DATE($same_crrntyr_end, 'YYYY-MM-DD')
   AND(
  $cntry_d IS NULL 
OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON))
)
AND(
  $product_code_d IS NULL
  OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON))
)
AND(
  $order_status_d IS NULL
  OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON))
)
AND(
  $deal_size_d IS NULL 
OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON))
)
);

SET YoY = SELECT
  ((curr_year_sales::FLOAT / NULLIF(prev_year_sales, 0)) - 1) * 100 AS yoy_percentage
FROM (
  SELECT
    SUM(CASE
          WHEN "Transaction Date" >= TO_DATE($same_crrntyr_start, 'YYYY-MM-DD')
           AND "Transaction Date" <= TO_DATE($same_crrntyr_end, 'YYYY-MM-DD')
          THEN "Sales"
          ELSE 0
        END) AS curr_year_sales,

    SUM(CASE
          WHEN "Transaction Date" >= TO_DATE($same_lstyr_start, 'YYYY-MM-DD')
           AND "Transaction Date" <= TO_DATE($same_lstyr_end, 'YYYY-MM-DD')
          THEN "Sales"
          ELSE 0
        END) AS prev_year_sales
  FROM dashboard_view
   WHERE (
  $cntry_d IS NULL 
OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON))
)
AND(
  $product_code_d IS NULL
  OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON))
)
AND(
  $order_status_d IS NULL
  OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON))
)
AND(
  $deal_size_d IS NULL 
OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON))
)
) AS YoY_data;


select 
    'text'      as component,
    'Dashboard' as title;
    
SELECT
  'form' AS component,
  'dashboard filters' AS id,
  'Search' AS validate,
  'cyan' as validate_outline,
  'GET' AS method,
  'Reset' as reset,
  'index.sql' as action;


SELECT 
        'Start Date' as label,
        'date_end_start_d' as name,
        $date_end_start_d as value,
        'date' as type,
        2 as width;

SELECT 
        'End Date' as label,
        'date_end_end_d' as name,
        $date_end_end_d as value,
        'date' as type,
        2 as width;

SELECT 
        'Country' as label,
        'cntry_d[]' as name,
        $cntry_d as placeholder,
        'select' as type,
        'All' as empty_option,
        TRUE as multiple,
        TRUE as dropdown,
        2 as width,
        json_agg(json_build_object('label',"Country" ,'value',"Country")) as options 
        FROM(SELECT DISTINCT "Country" FROM dashboard_view ORDER BY "Country" DESC) as order_list;

SELECT 
        'Product' as label,
        'product_code_d[]' as name,
        $product_code_d as placeholder,
        'select' as type,
        'All' as empty_option,
        TRUE as multiple,
        TRUE as dropdown,
        2 as width,
        json_agg(json_build_object('label',"Product Code" ,'value',"Product Code")) as options 
        FROM(SELECT DISTINCT "Product Code" FROM dashboard_view ORDER BY "Product Code" DESC) as pr_list;

SELECT 
        'Order Status' as label,
        'order_status_d[]' as name,
        'select' as type,
        'All' as empty_option,
        $order_status_d as placeholder,
        TRUE as dropdown,
        TRUE as multiple,
        2 as width,
        json_agg(json_build_object('label',"Status",'value',"Status")) as options
        FROM(SELECT "Status"FROM dashboard_view ORDER BY "Status" ASC) as st_list_d;

SELECT 
      'Deal Size' as label,
      'deal_size_d[]' as name,
      'select' as type,
      'All' as empty_option,
      $deal_size_d as placeholder,
      TRUE as dropdown,
      TRUE as multiple,
      2 as width,
      json_agg(json_build_object('label',"Deal Size",'value',"Deal Size")) as options
      FROM(SELECT "Deal Size"FROM dashboard_view ORDER BY "Deal Size" ASC) as size_list_d;


SET n_orders =
SELECT COUNT(DISTINCT "Order Number") AS n_orders
FROM dashboard_view
WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
AND (
  $cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON))
)
AND (
  $product_code_d IS NULL OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON))
)
AND (
  $order_status_d IS NULL OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON))
)
AND (
  $deal_size_d IS NULL OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON))
);

SET customers = 
SELECT COUNT(DISTINCT "Customer Name")
FROM dashboard_view
 WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
AND
(
  $cntry_d IS NULL 
OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON))
)
AND(
  $product_code_d IS NULL
  OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON))
)
AND(
  $order_status_d IS NULL
  OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON))
)
AND(
  $deal_size_d IS NULL 
OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON))
);


SET n_transactions = 
SELECT COUNT( DISTINCT "Transaction ID")
  FROM dashboard_view
  WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
AND
(
  $cntry_d IS NULL 
OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON))
)
AND(
  $product_code_d IS NULL
  OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON))
)
AND(
  $order_status_d IS NULL
  OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON))
)
AND(
  $deal_size_d IS NULL 
OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON))
);


SET revenue = 
SELECT CONCAT('$',TO_CHAR(SUM("Sales"), 'LFM999G999G999G990.00')) 
FROM dashboard_view
  WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
AND
(
  $cntry_d IS NULL 
OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON))
)
AND(
  $product_code_d IS NULL
  OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON))
)
AND(
  $order_status_d IS NULL
  OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON))
)
AND(
  $deal_size_d IS NULL 
OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON))
);

--=================VISUAL TABLES==============

-- 1. BAR BEGIN
DROP TABLE IF EXISTS bar_viz;
CREATE TABLE bar_viz AS
SELECT
    TRIM(TO_CHAR("Transaction Date",'Mon')) AS "Month", 
	  TRIM(TO_CHAR("Transaction Date",'MM')) AS mnth_n, 
    --TO_CHAR("Transaction Date",'YYYY') AS "year",
    TO_CHAR(SUM("Sales"), 'FM999G999G999G990.00')||'K' AS y
    FROM dashboard_view
    WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
AND
($cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON)))
AND( $product_code_d IS NULL OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON)))
AND( $order_status_d IS NULL OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON)))
AND($deal_size_d IS NULL OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON)))
  GROUP BY mnth_n,"Month"
	ORDER BY mnth_n,"Month"ASC;

-- BAR END 



-- 1. TOP 10 PRODUCTS BEGIN
DROP TABLE IF EXISTS top10products_viz;
CREATE TEMP TABLE top10products_viz AS
SELECT *
FROM (
    SELECT
        ROW_NUMBER() OVER(ORDER BY SUM("Quantity Ordered") DESC) AS order_n,
        "Product Code" AS p_code,
        SUM("Quantity Ordered") AS qty
    FROM dashboard_view
    WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
      AND ($cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON)))
      AND ($order_status_d IS NULL OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON)))
      AND ($deal_size_d IS NULL OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON)))
    GROUP BY "Product Code"
    ORDER BY SUM("Quantity Ordered") DESC
    LIMIT 10
) AS ranked_products;
-- TOP 10 PRODUCTS END 



-- 1. TOP 10 CUSTOMERS BEGIN
DROP TABLE IF EXISTS top10pcustomers_viz;
CREATE TABLE top10pcustomers_viz AS
SELECT *
FROM (
    SELECT
        ROW_NUMBER() OVER(ORDER BY SUM("Sales") DESC) AS order_rev,
        "Customer Name" AS cust_name,
        SUM("Sales") AS sales
    FROM dashboard_view
    WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
      AND ($cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON)))
      AND ($product_code_d IS NULL OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON)))
      AND ($order_status_d IS NULL OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON)))
      AND ($deal_size_d IS NULL OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON)))
    GROUP BY "Customer Name"
    ORDER BY sales DESC
    LIMIT 10
) AS ranked_customers;
-- TOP 10 CUSTOMERS END 


-- 1. ORDER STATUS BEGIN
DROP TABLE IF EXISTS order_status_viz;
CREATE TABLE order_status_viz AS
SELECT *
FROM (
    SELECT
        "Status" AS order_state,
        COUNT("Status") AS cnt_s
    FROM dashboard_view
    WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
      AND ($cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON)))
      AND ($product_code_d IS NULL OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON)))
      AND ($deal_size_d IS NULL OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON)))
    GROUP BY order_state
) AS status_order
-- ORDER STATUS END 


-- 1. PRODUCT LINE BUBBLE BEGIN
DROP TABLE IF EXISTS prod_line_bubble_viz;
CREATE TABLE prod_line_bubble_viz AS
SELECT *
FROM (
    SELECT
        "Product Line",
        COUNT("Product Line") AS line_rev,
        SUM("Sales") AS line_rev2
    FROM dashboard_view
    WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
      AND ($cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON)))
      AND ($product_code_d IS NULL OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON)))
      AND ($order_status_d IS NULL OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON)))
      AND ($deal_size_d IS NULL OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON)))
    GROUP BY "Product Line"
) AS line_bubble;

-- PRODUCT LINE BUBBLE END 


-- -- 1. Deal Size BEGIN
DROP TABLE IF EXISTS heatmap_viz;
CREATE TABLE heatmap_viz AS
    SELECT
        "Deal Size" as ds,
        TO_CHAR("Transaction Date",'YYYY') as yr,
         SUM("Sales") as sum_s
    FROM dashboard_view
    WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
      AND ($cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON)))
      AND ($product_code_d IS NULL OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON)))
      AND ($order_status_d IS NULL OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON)))
      GROUP BY ds,yr
--Deal Size END;


-- -- 1. Customer Distribution BEGIN
DROP TABLE IF EXISTS customer_distribution_viz;
CREATE TABLE customer_distribution_viz AS
    SELECT
        "Latitude" as lt,
        "Longitude" as lo,
        "State"
    FROM dashboard_view
    WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_d, 'YYYY-MM-DD') AND TO_DATE($date_end_end_d, 'YYYY-MM-DD')
      AND ($cntry_d IS NULL OR "Country" IN (SELECT json_array_elements_text($cntry_d::JSON)))
      AND ($product_code_d IS NULL OR "Product Code" IN (SELECT json_array_elements_text($product_code_d::JSON)))
      AND ($order_status_d IS NULL OR "Status" IN (SELECT json_array_elements_text($order_status_d::JSON)))
      AND ($deal_size_d IS NULL OR "Deal Size" IN (SELECT json_array_elements_text($deal_size_d::JSON)))
--Customer Distribution END;

--big number for KPI
select 
    'big_number'          as component,
    6                   as columns,
    'colorfull_dashboard' as id;

select 
    'Revenue' as title,
    $revenue   as value,
    --'$'       as unit,
    'blue'    as color;

select 
    'Customers'  as title,
    $customers       as value,
    'teal'   as color,
    'shopping-cart' as icon,
    TRUE      as title_link_new_tab;

select 
    'Transactions'          as title,
    $n_transactions          as value,
    'cyan'            as color;

select 
    'Orders'  as title,
    $n_orders       as value,
    'blue'   as color,
    'shopping-cart' as icon,
    TRUE      as title_link_new_tab;

  select 
    'QTD Revenue'  as title,
    'combine_data.sql' as value_link,
    'purple'    as color,
    '$'||$QTD as value,
    'shopping-cart' as icon,
    ROUND($QoQ::numeric,0) as change_percent;


 select 
    'YTD Revenue'  as title,
    'combine_data.sql' as value_link,
    'indigo'   as color,
    '$'||$YTD as value,
    'shopping-cart' as icon,
    ROUND($YoY::numeric,0) as change_percent;


SELECT 'card' as component,
3 as columns;

select 'viz_bar.sql?_sqlpage_embed' as embed;
select 'viz_top10_products.sql?_sqlpage_embed' as embed;
select 'viz_top_10_customers.sql?_sqlpage_embed' as embed;

select 'viz_pie.sql?_sqlpage_embed' as embed;
select 'viz_bubble.sql?_sqlpage_embed' as embed;
select 'viz_deal_size_heatmap.sql?_sqlpage_embed' as embed;

SELECT 'card' as component,
1 as columns;

select 'viz_sales_by_cntry.sql?_sqlpage_embed' as embed;

