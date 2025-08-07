SELECT 'shell' AS component,
  '👌SQL Project' AS title,
  TRUE AS fixed_top_menu,
  'dark' AS theme,
  '' AS icon,
  JSON('[
  { "title": "Home", "link": "index.sql", "icon": "home" },
  { "title": "About", "link": "/about.sql", "icon": "info-square" },
   { "title": "About", "link": "viz_bar.sql", "icon": "info-square" },

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
      60 as refresh,
  TRUE AS sidebar;

-- CREATE OR REPLACE VIEW transaction_view AS(
-- SELECT "Transaction Date",
-- TRIM(TO_CHAR("Transaction Date",'Mon')) AS "Month",
-- TO_CHAR("Transaction Date",'MM') AS "mnth_n",
-- TO_CHAR("Transaction Date",'Year') AS "year",
-- "Sales"
-- FROM "Transactions"
-- );

select 
    'chart'             as component,
    'Monthly Revenue(Thousands)' as title,
    'bar'              as type,
    'cyan'           as color,
    'Revenue(Thousands $)' as ytitle,
    4               as width;


SELECT mnth_n as x,
       "Month" as x,
       y as y
       FROM bar_viz;



