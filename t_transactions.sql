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
       'Transactions' as contents;

SET max_date_t = SELECT max("Transaction Date") FROM "Transactions";
SET min_date_t =SELECT min("Transaction Date") FROM "Transactions";
SET date_end_start_t = COALESCE(TO_DATE($date_end_start_t,'YYYY-MM-DD'),TO_DATE($min_date_t ,'YYYY-MM-DD'));
SET date_end_end_t  = COALESCE(TO_DATE($date_end_end_t,'YYYY-MM-DD'),TO_DATE($max_date_t,'YYYY-MM-DD'));


SELECT
  'form' AS component,
  'order_sales_filter' AS id,
  'Search' AS validate,
   'cyan' as validate_color,
  'Reset' as reset,
  'GET' AS method;


SELECT 
        'Start Date' as label,
        'date_end_start_t' as name,
        $date_end_start_t as value,
        'date' as type,
        2 as width;

SELECT 
        'End Date' as label,
        'date_end_end_t' as name,
        $date_end_end_t as value,
        'date' as type,
        2 as width;
SELECT 
        'Transaction ID' as label,
        'transactionID_t[]' as name,
        $transactionID_t as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        2 as width,
        json_agg(json_build_object('label',"Transaction ID" ,'value',"Transaction ID")) as options 
        FROM(SELECT DISTINCT "Transaction ID" FROM "Transactions") as trn_no;

SELECT 
        'Order Number'label,
        'order_number_t[]' as name,
        $order_number_t as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as dropdown,
        TRUE as multiple,
        2 as width,
        json_agg(json_build_object('label',"Order Number",'value',"Order Number")) as options
        FROM(SELECT DISTINCT "Order Number" FROM "Transactions" ORDER BY "Order Number" DESC) as order_number_list;

SELECT 
        'Product Code'label,
        'product_code_t[]' as name,
        $product_code_t as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as dropdown,
        TRUE as multiple,
        2 as width,
        json_agg(json_build_object('label',"Product Code",'value',"Product Code")) as options
        FROM(SELECT DISTINCT "Product Code" FROM "Transactions" ORDER BY "Product Code" ASC) as product_list;

 SELECT 
        'Deal Size'label,
        'Deal_t[]' as name,
        $Deal_t as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as dropdown,
        TRUE as multiple,
        2 as width,
        json_agg(json_build_object('label',"Deal Size",'value',"Deal Size")) as options
        FROM(SELECT DISTINCT "Deal Size" FROM "Transactions" ORDER BY "Deal Size" ASC) as product_list;


-- Update deal size
UPDATE "Transactions" t
SET "Deal Size" = dsu.ds
FROM(
    SELECT "Deal ID", "Deal Size" as ds
	FROM "Deal Size"
) as dsu
WHERE dsu."Deal ID" = t."Deal ID";

SELECT 'csv' as component,
       'Transacations.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;

SELECT * FROM (
   SELECT 
      "Transaction ID"::TEXT AS "Transaction ID",
      "Transaction Date",
      "Product Code",
      "Order Number"::TEXT AS "Order Number",
      "Order Line Number",
      "Deal Size",
      "Quantity Ordered",
      "Price Each",
      "Sales"
   FROM "Transactions"
) 
WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_t,'YYYY-MM-DD') 
   AND TO_DATE($date_end_end_t,'YYYY-MM-DD')
   AND(
    $transactionID_t IS NULL 
    OR "Transaction ID" IN (
        SELECT json_array_elements_text($transactionID_t::JSON)
    )
   )
   AND( 
    $order_number_t IS NULL 
    OR "Order Number" IN (
        SELECT (json_array_elements_text($order_number_t::JSON))
    )
    )
    AND(
        $product_code_t IS NULL 
    OR "Product Code" IN (
        SELECT (json_array_elements_text($product_code_t::JSON))
    )
    )
    AND(
        $Deal_t IS NULL 
    OR "Deal Size" IN (
        SELECT (json_array_elements_text($Deal_t::JSON))
    )
    )
ORDER BY "Order Number" DESC;


SELECT 'table' as component,
   TRUE    as freeze_columns,
   TRUE    as freeze_headers,
   TRUE    as hover,
   TRUE    as striped_rows,
   TRUE    as sort,
   TRUE    as search,
  'table' as icon;

SELECT * FROM (
   SELECT 
      "Transaction ID"::TEXT AS "Transaction ID",
      "Transaction Date",
      "Product Code",
      "Order Number"::TEXT AS "Order Number",
      "Order Line Number",
      "Deal Size",
      "Quantity Ordered",
      "Price Each",
      "Sales"
   FROM "Transactions"
) 
WHERE "Transaction Date" BETWEEN TO_DATE($date_end_start_t,'YYYY-MM-DD') 
   AND TO_DATE($date_end_end_t,'YYYY-MM-DD')
   AND(
    $transactionID_t IS NULL 
    OR "Transaction ID" IN (
        SELECT json_array_elements_text($transactionID_t::JSON)
    )
   )
   AND( 
    $order_number_t IS NULL 
    OR "Order Number" IN (
        SELECT (json_array_elements_text($order_number_t::JSON))
    )
    )
    AND(
        $product_code_t IS NULL 
    OR "Product Code" IN (
        SELECT (json_array_elements_text($product_code_t::JSON))
    )
    )
    AND(
        $Deal_t IS NULL 
    OR "Deal Size" IN (
        SELECT (json_array_elements_text($Deal_t::JSON))
    )
    )
ORDER BY "Order Number" DESC;