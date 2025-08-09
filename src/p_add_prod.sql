-- DROP TABLE IF EXISTS new_product;

-- CREATE TABLE new_product
-- (
-- "Series" VARCHAR(100),
-- "Model" VARCHAR(100), 
-- "Manfucturer Specied Retail Price" FLOAT, 
-- "Line Code" INT,
-- "Product Line" VARCHAR(100),
-- "Update Date" DATE,
-- "Message" TEXT
-- );
TRUNCATE new_product;

COPY new_product ("Series","Model","Manfucturer Specied Retail Price","Line Code","Product Line")
FROM 'product_new' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

UPDATE new_product AS n
SET 
  "Update Date" = NOW(),
  "Line Code" = ld_up.ld
FROM (
  SELECT 
    "Line Code" AS ld,
    "Product Line" AS pd
  FROM "Product Line"
) AS ld_up
WHERE ld_up.pd = n."Product Line";

UPDATE new_product AS n
SET 
"Message" = CASE
               WHEN "Line Code" IS NULL THEN 'Product Line does not exist. Please download to confirm.'
               ELSE 'Successful'
               END;



-- INSERT INTO new_product(
--   "Product code", 
--   "Manufacturer Specified Retail Price", 
--   "Line Code"
-- )
-- SELECT * FROM(
-- SELECT DISTINCT
--   CONCAT(TRIM(series) || '_' || TRIM(model)), 
--   price, 
--   prod_line
-- FROM $product_new
-- WHERE TRIM(series) <> ''
--   AND TRIM(model) <> '');


SELECT 'redirect' as component,
       'p_new_form.sql' as link;