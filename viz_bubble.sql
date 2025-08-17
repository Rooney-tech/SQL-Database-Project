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



