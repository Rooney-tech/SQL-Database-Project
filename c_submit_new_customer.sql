INSERT INTO "Customer" (
    "Customer Name",
    "Contact Name",
    "Phone",
    "Addressline 1",
    "City ID",
    "Create Date"
)
SELECT 
    DISTINCT cstv."Customer Name",
    cstv."Contact Name",
    cstv."Phone",
    cstv."Addressline 1",
    cstv."City ID",
    NOW()
FROM  new_customer_view cstv
WHERE "Message" = 'Successful';

TRUNCATE temp_customer;

SELECT 'redirect' as component,
'c_cust_form.sql' as link;