select 
    'chart'             as component,
    'Top 10 Products by Sales' as title,
    'treemap'              as type,
    TRUE      as labels,
    TRUE as horizontal,
    'cyan'           as color,
    4               as width;

SELECT  order_n as series,
        p_code as label,
         qty as value
FROM top10products_viz;
