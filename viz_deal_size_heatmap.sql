select 
    'chart'                     as component,
    'Yearly Revenue by Deal Size'      as title,
    'heatmap'                   as type,
    'Deal Size' as ytitle,
    'Year'                      as xtitle,
    TRUE  as labels,
    'pink' as color,
    'yellow' as color,
     'green' as color;

select 
     ds as series,
     yr as x,
    sum_s as y
    FROM heatmap_viz;


