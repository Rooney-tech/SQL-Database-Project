INSERT INTO "States"("State", "Cntry ID")
SELECT "State", "Cntry ID"
FROM (
  SELECT 
    "State",
    "Cntry ID",
    "Country",
    ROW_NUMBER() OVER (PARTITION BY "State" ORDER BY "State") AS rn,
    CASE 
      WHEN "Cntry ID" IS NULL THEN 'Country does not exist. Please add.'
      WHEN ROW_NUMBER() OVER (PARTITION BY "State" ORDER BY "State") > 1 THEN 'Repeated'
      ELSE 'Successful'
    END AS "Message"
  FROM states_new
) inst
WHERE "Message" = 'Successful'
  AND NOT EXISTS (
    SELECT 1
    FROM "States" st
    WHERE st."State" = inst."State"
  );

TRUNCATE states_new;

SELECT 'redirect' as component,
       's_new_state.sql' as link;