UPDATE "Orders" o
SET "Order Status ID" = u."New Status ID",
    "Update Date" = NOW()
FROM updated_order_status u
WHERE u."Order Number" = o."Order Number"
AND   u."New Status ID" <> o."Order Status ID";



TRUNCATE updated_order_status;

SELECT 'redirect' AS component,
       'Update_order_status.sql' AS link;