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
       'Orders' as contents;



--create a temporary table for smart filtering for forms too.
CREATE OR REPLACE VIEW ord_summary AS(
SELECT 
  o."Order Number" AS "Order Number" , 
  o."Order Status ID" AS "Order Status ID" ,
  os."Status" AS "Status" , 
  o."Order Date" AS "Order Date", 
  c."Customer Name" AS "Customer Name",
  o."Update Date"
FROM "Orders" o
JOIN "Order Status" os ON os."Status ID" = o."Order Status ID"
JOIN "Customer" c ON o."Customer ID" = c."Cust ID"
);


--form to filter orders table
SET max_date_o = SELECT max("Order Date") FROM ord_summary;
SET min_date_o =SELECT min("Order Date") FROM ord_summary;
SET date_end_start_o = COALESCE(TO_DATE($date_end_start_o,'YYYY-MM-DD'),TO_DATE($min_date_o ,'YYYY-MM-DD'));
SET date_end_end_o   = COALESCE(TO_DATE($date_end_end_o,'YYYY-MM-DD'),TO_DATE($max_date_o,'YYYY-MM-DD'));

SELECT
  'form' AS component,
  'orders_filter' AS id,
  'Search' AS validate,
  'cyan' as validate_outline,
  'GET' AS method,
  'Reset' as reset,
  't_orders.sql' as action;


SELECT 
        'Start Date' as label,
        'date_end_start_o' as name,
        $date_end_start_o as value,
        'date' as type,
        2 as width;

SELECT 
        'End Date' as label,
        'date_end_end_o' as name,
        $date_end_end_o as value,
        'date' as type,
        2 as width;
SELECT 
        'Order Number' as label,
        'order_no[]' as name,
        $order_no as placeholder,
        'select' as type,
        'All' as empty_option,
        TRUE as multiple,
        TRUE as dropdown,
        2 as width,
        json_agg(json_build_object('label',"Order Number" ,'value',"Order Number")) as options 
        FROM(SELECT DISTINCT "Order Number" FROM ord_summary ORDER BY "Order Number" DESC) as order_list;
SELECT 
        'Customer' as label,
        'cust_o[]' as name,
        $cust_o as placeholder,
        'select' as type,
        'All' as empty_option,
        TRUE as multiple,
        TRUE as dropdown,
        2 as width,
        json_agg(json_build_object('label',"Customer Name" ,'value',"Customer Name")) as options 
        FROM(SELECT DISTINCT "Customer Name" FROM ord_summary ORDER BY "Customer Name" DESC) as order_list;

SELECT 
        'Status' as label,
        'order_status_o[]' as name,
        'select' as type,
        'All' as empty_option,
        $order_status_o as placeholder,
        TRUE as dropdown,
        TRUE as multiple,
        2 as width,
        json_agg(json_build_object('label',"Status",'value',"Status")) as options
        FROM(SELECT "Status"FROM ord_summary ORDER BY "Status" ASC) as st_list_o;

SELECT 'csv' as component,
       'Order Sales.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;


SELECT
    "Order Number"::TEXT,
    "Order Status ID",
    "Status",
    "Order Date",
    "Customer Name",
    "Update Date"
FROM ord_summary
WHERE
    "Order Date" BETWEEN TO_DATE($date_end_start_o, 'YYYY-MM-DD')
                    AND TO_DATE($date_end_end_o, 'YYYY-MM-DD')

    -- Filter by Order Number if provided
    AND (
        $order_no IS NULL
        OR "Order Number" IN (
            SELECT (json_array_elements_text($order_no::JSON))::INT
        )
    )

    -- Filter by Status if provided
    AND (
        $order_status_o IS NULL
        OR "Status" IN (
            SELECT json_array_elements_text($order_status_o::JSON)
        )
    )

    -- Filter by Customer Name if provided
    AND (
        $cust_o IS NULL
        OR "Customer Name" IN (
            SELECT json_array_elements_text($cust_o::JSON)
        )
    )
ORDER BY "Order Number" DESC;

-- button to create new order
SELECT 'button' as component,
       'sml' as size,
       'end' as justify;

SELECT 
       'cyan' as outline,
       'New' as title,
       '/Get Transactions Template.sql' as link;

-- button to help edit order status

SELECT 
       'teal' as outline,
       'Update' as title,
       '/Update_order_status.sql' as link;
  
SELECT 'table' as component,
TRUE    as freeze_columns,
TRUE    as freeze_headers,
TRUE    as hover,
TRUE    as striped_rows,
TRUE    as sort,
TRUE    as search,
'table' as icon;


SELECT
    "Order Number"::TEXT,
    "Order Status ID",
    "Status",
    "Order Date",
    "Customer Name",
    "Update Date"
FROM ord_summary
WHERE
    "Order Date" BETWEEN TO_DATE($date_end_start_o, 'YYYY-MM-DD')
                    AND TO_DATE($date_end_end_o, 'YYYY-MM-DD')

    -- Filter by Order Number if provided
    AND (
        $order_no IS NULL
        OR "Order Number" IN (
            SELECT (json_array_elements_text($order_no::JSON))::INT
        )
    )

    -- Filter by Status if provided
    AND (
        $order_status_o IS NULL
        OR "Status" IN (
            SELECT json_array_elements_text($order_status_o::JSON)
        )
    )

    -- Filter by Customer Name if provided
    AND (
        $cust_o IS NULL
        OR "Customer Name" IN (
            SELECT json_array_elements_text($cust_o::JSON)
        )
    )
  ORDER BY "Order Number" DESC;

