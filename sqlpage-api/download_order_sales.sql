SELECT 'csv' as component,
       'Order Sales.csv' as filename;

    SELECT * FROM "Order Sales"
    WHERE "Order Date" BETWEEN TO_DATE($date_end_start,'YYYY-MM-DD') 
    AND TO_DATE($date_end_end,'YYYY-MM-DD')
    AND "Country" = ANY(SELECT ARRAY(SELECT json_array_elements_text(CAST($country AS JSON))))
    AND "Status" = ANY(SELECT ARRAY(SELECT json_array_elements_text(CAST($order_status AS JSON))));

