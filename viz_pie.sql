select 
    'chart'             as component,
    'Order Status Distribution' as title,
    'pie'              as type,
    'cyan'           as color,
    TRUE as labels,
    TRUE as legend,
    4               as width;

SELECT cnt_s as value,
       order_state as label
       FROM order_status_viz;
