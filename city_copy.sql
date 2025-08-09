TRUNCATE new_cities;

COPY new_cities("City","Postal Code","Latitude","Longitude","State ID","State")
FROM new_city WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"');

UPDATE new_cities nwst
SET "State" = s."State"
FROM "States" s
WHERE s."State ID" = nwst."State ID";

SELECT 'redirect' as component,
       'city_new.sql' as link;