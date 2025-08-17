SELECT   
    'map' as component,  
    'Customer Geographical Distribution by State' as title,
    2 as zoom,  
    8 as max_zoom, 
    850 as height;  

SELECT 'map-pin' as icon,
    1 as size,
    'cyan' as color;
  
-- Then, provide the marker data (multiple rows)  
SELECT   
    lt as latitude,
    lo as longitude,
    "State" as title
FROM customer_distribution_viz;
