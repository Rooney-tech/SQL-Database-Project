INSERT INTO "Country"("Country")
SELECT cntry_inserts."Country"
FROM(
  SELECT
    cn.*,
    c."Country" AS "Check",
    CASE
      WHEN c."Country" IS NULL THEN 'Successful'
      ELSE 'Country already exists'
    END AS "Message",
    CASE
      WHEN c."Country" IS NULL THEN 'green'
      ELSE 'red'
    END AS _sqlpage_color
  FROM cntr_new cn
  LEFT JOIN "Country" c 
    ON LOWER(c."Country") = LOWER(cn."Country") 
)AS cntry_inserts
WHERE cntry_inserts."Message" = 'Successful';

TRUNCATE cntr_new
SELECT 'redirect' as component,
       'cntry_new.sql' as link;