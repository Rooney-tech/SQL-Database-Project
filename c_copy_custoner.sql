TRUNCATE temp_customer;

copy temp_customer ("Customer Name","Contact Name","Phone","Addressline 1","City ID") from new_customer
with (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

UPDATE temp_customer c
SET "City" = ct."City"
FROM "Cust City" ct
WHERE c."City ID" = ct."City ID";
SELECT 'redirect' as component,
       'c_cust_form.sql' as link;