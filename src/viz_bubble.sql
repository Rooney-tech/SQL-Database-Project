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


select 
    'chart'             as component,
    'Revenue by Product Line' as title,
    'bubble'              as type,
    'cyan'           as color,
    4               as width,
    8                as marker,
    5                as xticks,
    5                as yticks,
    'Revenue' as ytitle,
    'Count of Product Line' as xtitle;
   

SELECT  "Product Line" as series,
        ROUND(line_rev::numeric,0) as x,
        ROUND(line_rev2::numeric,0) as y,
        ROUND(line_rev2::numeric,0) as size
        FROM prod_line_bubble_viz;



