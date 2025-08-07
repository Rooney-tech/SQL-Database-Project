
WITH formatted_new_products AS (
  SELECT 
    CONCAT(np."Series", '_', np."Model") AS "Product Code",
    np."Manfucturer Specied Retail Price",
    np."Line Code",
    np."Update Date"
  FROM new_product np
  WHERE np."Message" = 'Successful'
)
INSERT INTO "Products"(
  "Product Code",
  "Manfucturer Specied Retail Price",
  "Line Code",
  "Update Date"
)
SELECT 
  f."Product Code",
  f."Manfucturer Specied Retail Price",
  f."Line Code",
  f."Update Date"
FROM formatted_new_products f
WHERE NOT EXISTS (
  SELECT 1 
  FROM "Products" p 
  WHERE p."Product Code" = f."Product Code"
)
ON CONFLICT DO NOTHING;


TRUNCATE new_product;

SELECT 'redirect' as component,
        'p_new_form.sql' as link;