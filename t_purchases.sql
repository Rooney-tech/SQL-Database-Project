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
       'Purchase' as contents;

UPDATE Purchases AS p
SET 
  "Country" = ctry."Country",
  "City" = ct."City",
  "State" = s."State"
FROM "Customer" AS cst
JOIN "Cust City" AS ct 
  ON cst."City ID" = ct."City ID"
JOIN "States" AS s 
  ON ct."State ID" = s."State ID"
JOIN "Country" AS ctry 
  ON s."Cntry ID" = ctry."Cntry ID"
WHERE p."Customer ID" = cst."Cust ID"
  AND (p."Country" IS NULL OR p."Country" = '')
  AND (p."City" IS NULL OR p."City" = '')
  AND (p."State" IS NULL OR p."State" = '');

SET mx_date = SELECT max("Update Date") FROM Purchases;
SET mn_date =SELECT min("Update Date") FROM Purchases;
SET date_end_start_p = COALESCE(TO_DATE($date_end_start_p,'YYYY-MM-DD'),TO_DATE($mn_date ,'YYYY-MM-DD'));
SET date_end_end_p  = COALESCE(TO_DATE($date_end_end_p,'YYYY-MM-DD'),TO_DATE($mx_date,'YYYY-MM-DD'));



SELECT
  'form' AS component,
  'purchases_filter' AS id,
  'Search' AS validate,
  'GET' AS method,
  'Reset' as reset;


SELECT 
        'Start Date' as label,
        'date_end_start_p' as name,
        $date_end_start_p as value,
        'date' as type,
        2 as width;

SELECT 
        'End Date' as label,
        'date_end_end_p' as name,
        $date_end_end_p as value,
        'date' as type,
        2 as width;

SELECT 
        'Deal Size'label,
        'dealsize_p[]' as name,
        $dealsize_p as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as dropdown,
        TRUE as multiple,
        2 as width,
        json_agg(json_build_object('label',"Deal Size",'value',"Deal Size")) as options
        FROM(SELECT DISTINCT "Deal Size" FROM purchases ORDER BY "Deal Size" ASC) as d_list;
SELECT 
        'Customer'label,
        'customer_p[]' as name,
        $customer_p as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as dropdown,
        TRUE as multiple,
        2 as width,
        json_agg(json_build_object('label',"Customer Name",'value',"Customer Name")) as options
        FROM(SELECT DISTINCT "Customer Name" FROM purchases ORDER BY "Customer Name" ASC) as d_list;

SELECT 
        'Country' as label,
        'country_p[]' as name,
         $country_p as placeholder,
         'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        2 as width,
        json_agg(json_build_object('label',"Country" ,'value',"Country")) as options 
        FROM(SELECT DISTINCT "Country" FROM Purchases ORDER BY "Country" ASC) as list_cntry;

SELECT 
        'State' as label,
        'state_p[]' as name,
         $state_p as placeholder,
         'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        2 as width,
        json_agg(json_build_object('label',"State" ,'value',"State")) as options 
        FROM(SELECT DISTINCT "State" FROM Purchases ORDER BY "State" ASC) as states;


SELECT 'csv' as component,
       'Order Sales.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon,
       TRUE as space_after;

SELECT
    "Order Number"::TEXT AS "Order Number",
    "Update Date",
    "Customer ID",
    "Customer Name",
    "Product Code",
    "Deal Size",
    "Quantity Ordered",
    "Price Each",
    "Sales",
    "Country",
    "State",
    "City"
FROM Purchases
WHERE
    -- Date range filter
    "Update Date" BETWEEN TO_DATE($date_end_start_p, 'YYYY-MM-DD')
                      AND TO_DATE($date_end_end_p, 'YYYY-MM-DD')

    -- Optional filters: Country and Deal Size via JSON array parameters
    AND (
        $country_p IS NULL
        OR "Country" IN (
            SELECT json_array_elements_text($country_p::JSON)
        )
    )
    AND (
        $dealsize_p IS NULL
        OR "Deal Size" IN (
            SELECT json_array_elements_text($dealsize_p::JSON)
        )
    )
    AND (
        $customer_p IS NULL
        OR "Customer Name" IN (
            SELECT json_array_elements_text($customer_p::JSON)
        )   
    )
    AND (
        $state_p IS NULL
        OR "State" IN (
            SELECT json_array_elements_text($state_p::JSON)
        )
    )
ORDER BY
    "Order Number" DESC;


SELECT 'table' as component,
TRUE    as freeze_columns,
TRUE    as freeze_headers,
TRUE    as hover,
TRUE    as striped_rows,
TRUE    as sort,
TRUE    as search,
'https://tabler.io/icons/icon/table' as icon;

SELECT
    "Order Number"::TEXT AS "Order Number",
    "Update Date",
    "Customer ID",
    "Customer Name",
    "Product Code",
    "Deal Size",
    "Quantity Ordered",
    "Price Each",
    "Sales",
    "Country",
    "State",
    "City"
FROM Purchases
WHERE
    -- Date range filter
    "Update Date" BETWEEN TO_DATE($date_end_start_p, 'YYYY-MM-DD')
                      AND TO_DATE($date_end_end_p, 'YYYY-MM-DD')

    -- Optional filters: Country and Deal Size via JSON array parameters
    AND (
        $country_p IS NULL
        OR "Country" IN (
            SELECT json_array_elements_text($country_p::JSON)
        )
    )
    AND (
        $dealsize_p IS NULL
        OR "Deal Size" IN (
            SELECT json_array_elements_text($dealsize_p::JSON)
        )
    )
    AND (
        $customer_p IS NULL
        OR "Customer Name" IN (
            SELECT json_array_elements_text($customer_p::JSON)
        )   
    )
    AND (
        $state_p IS NULL
        OR "State" IN (
            SELECT json_array_elements_text($state_p::JSON)
        )
    )
ORDER BY
    "Order Number" DESC;
