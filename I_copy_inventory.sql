TRUNCATE temp_inventory; 

COPY temp_inventory("Product Code", "Available Quantity")
FROM 'new_inventory'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

SELECT 'redirect' as component,
'I_new_inventory.sql' as link;




