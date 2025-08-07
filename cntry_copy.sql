TRUNCATE cntr_new;

INSERT INTO cntr_new("Country")
SELECT INITCAP(TRIM(cntry_list))
FROM regexp_split_to_table($items_cntry, ',') AS cntry_list
WHERE TRIM(cntry_list) <> '';

UPDATE cntr_new
SET "ID" = sub.id_new
FROM (
  SELECT
    "Country",
    ROW_NUMBER() OVER () +
    (SELECT COALESCE(MAX("Cntry ID"), 0) FROM "Country") AS id_new
  FROM cntr_new
) AS sub
WHERE cntr_new."Country" = sub."Country";

SELECT 'redirect' as component,
       'cntry_new.sql' as link;