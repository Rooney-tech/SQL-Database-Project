select 
    'chart'             as component,
    'Top 10 Customers by Revenue' as title,
    'bar'              as type,
    TRUE as horizontal,
    'cyan'           as color,
    'Revenue($)' as xtitle,
    4               as width;

SELECT 
       cust_name as x,
       order_rev as x,
	  ROUND(sales::numeric,0) as y
FROM top10pcustomers_viz;
