select 
    'chart'             as component,
    'Monthly Revenue(Thousands)' as title,
    'area'              as type,
    'cyan'           as color,
    'Revenue(Thousands $)' as ytitle,
    4               as width;


SELECT mnth_n as x,
       "Month" as x,
       y as y
       FROM bar_viz;



