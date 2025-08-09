INSERT INTO "Cust City"("City","Postal Code","Latitude","Longitude","State ID")
SELECT DISTINCT "City","Postal Code","Latitude","Longitude","State ID"
FROM city_inserts
WHERE "Message" = 'Successful';

TRUNCATE new_cities;

SELECT 'redirect' as component,
    'city_new.sql' as link;