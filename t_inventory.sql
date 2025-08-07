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

SELECT 'divider' AS component,
       'Inventory' as contents; 


SET max_qty = SELECT MAX("Available Quantity") FROM "Inventory";
SET min_qty = SELECT MIN("Available Quantity") FROM "Inventory";

SELECT
  'form' AS component,
  'order_sales_filter' AS id,
  'Search' AS validate,
  'Reset' as reset,
  'GET' AS method;

SELECT 
        'Product Code' as label,
        'product_code_i[]' as name,
        $product_code_i as placeholder,
        'All' as empty_option,
        'select' as type,
        TRUE as multiple,
        TRUE as dropdown,
        4 as width,
        json_agg(json_build_object('label',"Product Code" ,'value',"Product Code")) as options 
        FROM(SELECT DISTINCT "Product Code" FROM "Inventory" ORDER BY "Product Code" ASC) as cntry_lst;

SELECT 
        'Min Quantity' as label,
        'min_qty' as name,
        $min_qty as placeholder,
        'number' as type,
        4 as width;

     SELECT 
        'Max Quantity' as label,
        'max_qty' as name,
        $max_qty as placeholder,
        'number' as type,
        4 as width;



--form to help update inventory
SELECT 'button' as component,
       'sml' as size,
       'end' as justify

SELECT 'cyan' as outline,
       'Update' as title,
       '/I_new_inventory' as link;

SELECT 'csv' as component,
       'Inventory.csv' as filename,
       'md' as size,
       'Export' as title,
       'cyan' as color,
       'file-download' as icon;

select * from "Inventory"
WHERE $product_code_i IS NULL 
     OR "Product Code" IN (SELECT json_array_elements_text($product_code_i::JSON));

SELECT 'table' as component,
TRUE    as freeze_columns,
TRUE    as freeze_headers,
TRUE    as hover,
TRUE    as striped_rows,
TRUE    as sort,
TRUE    as search,
'table' as icon;


SELECT 
  i.*, 
  CASE 
    WHEN i."Available Quantity" >= 20 THEN 'green'
    ELSE 'red'
  END AS _sqlpage_color
FROM "Inventory" i
WHERE $product_code_i IS NULL
   OR i."Product Code" IN (
     SELECT json_array_elements_text($product_code_i::JSON)
   );

TRUNCATE temp_inventory;