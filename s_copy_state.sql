TRUNCATE states_new;

COPY states_new ("State","Country")
FROM new_state WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"')

UPDATE states_new s
SET "Cntry ID" = c."Cntry ID"
FROM "Country" c
WHERE s."Country" = c."Country";

UPDATE states_new 
SET "Message" =
 CASE WHEN "Cntry ID" IS NULL THEN 'Country does not exist. Please add.' 
 ELSE 'Successful'
 END;

SELECT 'redirect' as component,
       's_new_state.sql' as link;


