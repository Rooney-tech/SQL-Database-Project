SELECT 'shell' AS component,
  '👌SQL Project' AS title,
  TRUE AS fixed_top_menu,
  'dark' AS theme,
  'golf' AS icon,
  JSON('[
  { "title": "Home", "link": "index.sql", "icon": "home" },
  { "title": "About", "link": "/about.sql", "icon": "info-square" },

  {
    "title": "Sales",
    "icon": "section",
    "submenu": [
      { "title": "Orders", "link": "t_orders.sql", "icon": "table" },
      { "title": "Purchases", "link": "t_purchases.sql", "icon": "table" },
      { "title": "Transactions", "link": "t_transactions.sql", "icon": "table" },
      { "title": "Order Status", "link": "t_ord_status.sql", "icon": "table" },
      { "title": "Deal Size", "link": "t_deal_size.sql", "icon": "table" }
    ]
  },

  {
    "title": "Product",
    "icon": "section",
    "submenu": [
      { "title": "Products", "link": "t_products.sql", "icon": "table" },
      { "title": "Product Line", "link": "t_products_line.sql", "icon": "table" },
      { "title": "Inventory", "link": "t_inventory.sql", "icon": "table" }
    ]
  },

  {
    "title": "Customer Info",
    "icon": "section",
    "submenu": [
      { "title": "Customer", "link": "t_customer.sql", "icon": "table" },
      { "title": "State", "link": "t_states.sql", "icon": "table" },
      { "title": "Country", "link": "t_country.sql", "icon": "table" },
      { "title": "City", "link": "t_city.sql", "icon": "table" }
    ]
  },
 { "title": "Raw Data", "link": "t_raw_data.sql", "icon": "section" }
]') AS menu_item,
     '' AS footer,
      'Poppins'               as font,
     'en-US' as language,
      'Menu' as navbar_title,
      '' as search_value,
      --30 as refresh,
  TRUE AS sidebar;

select 
    'text' as component,
    --TRUE   as article,
    '50%' as width,
    '
# Database Normalization.
  Def: This is the process of structuring a relational database in accordance with a series of so-called normal forms in order to reduce data redundancy and improve data integrity.
 ## First Normal Form(1NF)
* The raw ''Order Sales'' data in this website was sourced from [Kaggle](https://www.kaggle.com/datasets/kyanyoga/sample-sales-data) and is set to undergo normalization using the PgAdmin RDBMS, powered by the PostgreSQL database engine.
* 1NF assumptions checked at this stage include:
    1. Atomicity: Each column must contain single, indivisible vaalues (no lists on grouped data).
    2. Uniqueness: Every row should be uniquely identifiable with a primary key which is a combination of "Order Number"+"Order Line Number".
    3. No Repeating Groups: Data should be structured so that there are no duplicate columns for similar data.
    4. Consistent Data Types: Each column should store only one type of data (e.g numbers in numeric columns, text in string columns).
    5. Each Field Contains Single Values: No multiple values in a single column.
* The table created from it has 2823 rows and 25 columns as shown below.
* The rows in the table can also be filtered using the form above it.
' as contents_md;

select 
    'text' as component,
    --TRUE   as article,
    '50%' as width,
    '
## Second Normal Form(2NF)
* Second Normal Form (2NF) Assumptions rely on meeting the conditions of First Normal Form (1NF) while addressing partial dependency issues. 
* Here’s what 2NF assumes:
   1. It must first be in 1NF – meaning no repeating groups and atomic values in every column.
   2. Eliminates Partial Dependencies – all non-key attributes must be fully dependent on the whole primary key, not just part of it.
   3. Applies to Composite Keys – if a table has a single-column primary key, it automatically satisfies 2NF. 
        The real need arises when dealing with composite keys, where dependencies on only part of the key must be removed.
* To achieve 2NF, we often split tables to remove partial dependencies, ensuring each table has attributes that depend on the full primary key.

' as contents_md;


select 
    'text' as component,
    --TRUE   as article,
    '50%' as width,
    '
## Third Normal Form(3NF)
* A table is in 3NF if it meets the following conditions:
  1. It is in Second Normal Form (2NF) – This means there are no partial dependencies (i.e., no non-prime attribute depends on only part of a candidate key).
  2. It has no transitive dependencies – No non-key attribute should depend on another non-key attribute. Instead, all non-key attributes must depend directly on the primary key.
  ' as contents_md;

select 
    'text' as component,
'* Creating original table of ''Order Sales'' and ''City''.
```sql
    DROP TABLE IF EXISTS "Order Sales";

    CREATE  TABLE "Order Sales"
    (
        "Order Number" INT,
        "Order Line Number" INT,
        "Quantity Ordered" INT,
        "Price Each" FLOAT,
        "Sales" FLOAT,
        "Msrp" FLOAT,
        "Order Date" TIMESTAMP,
        "Status" VARCHAR(100),
        "Qtr Id" INT,
        "Month Id" INT,
        "Year Id" INT,
        "Product Line" VARCHAR(100),
        "Product Code" VARCHAR(100),
        "Customer Name" VARCHAR(100),
        "Phone"VARCHAR(20),
        "Addressline 1" VARCHAR(100),
        "Addressline 2" VARCHAR(100),
        "City"VARCHAR(100),
        "State" VARCHAR(100),
        "Postal Code" VARCHAR(100),
        "Country" VARCHAR(100),
        "Territory" VARCHAR(100),
        "Contact Last Name" VARCHAR(100),
        "Contact First Name" VARCHAR(100),
        "Deal Size"VARCHAR(100)
        );
```'as  contents_md;

select 
'text' as component,
'* Populate "Order Sales" table with original data from a .csv as follows using plsql:
```sql
   \copy public."Order Sales" FROM ''C:/Users/odago/OneDrive/SQL Programming/Database Normalization/sales_data_sample.csv ''DELIMITER '','' CSV HEADER;
```'as contents_md;

select 
'text' as component,
'* Creating a copy of the Order Sales table for data wrangling:
```sql
    SELECT * INTO "Sales"
    FROM "Order Sales";
```'as contents_md;


select
'text' as component,
'* Creating original table of cities to help in handling missing city Latitude and Longitude:
```sql
    CREATE TABLE "City"
    ("Id" INT,
    "City" VARCHAR(100),
    "City Ascii" VARCHAR(100),
    "Latitude" DOUBLE PRECISION,
    "Longitude" DOUBLE PRECISION,
    "Country" VARCHAR(100),
    "Iso2" VARCHAR(20),
    "Iso3" VARCHAR(20),
    "Admin Name" VARCHAR(200),
    "Capital" VARCHAR(50),
    "Population" INT
    );
```
* Importing data into table City
```sql
 \copy public."City" FROM ''C:/Users/odago/OneDrive/SQL Programming/Database Normalization/worldcities.csv ''DELIMITER '','' CSV HEADER;
```
* Creating a copy of the City table for data wrangling:
 ```sql
    SELECT * INTO "Cities"
    FROM "City"; 
```' as contents_md;

SELECT 
    'text' as component,

'* Cleaning Cities table.
```sql
    ALTER TABLE "Cities" 
    DROP COLUMN "City",
    DROP COLUMN "Addressline 2",
    DROP COLUMN "Admin Name",
    DROP COLUMN "Capital",
    DROP COLUMN "Population";

    ALTER TABLE "Cities" RENAME COLUMN "City Ascii" TO "City";
```' as contents_md;



SELECT 'text' as component,
'## Data Wrangling.
 * Updating the Sales table by adding latitude and longitude for each city and drop Addressline 2 column.
 ```sql
    SELECT * FROM "Sales";

    ALTER TABLE "Sales"
    ADD COLUMN "Latitude" DOUBLE PRECISION,
    ADD COLUMN "Longitude" DOUBLE PRECISION;

    ALTER TABLE "Sales"
    DROP COLUMN "Addressline 2";

    SELECT * FROM "Sales";
```
* Checking whether all city names in Sales table also exist in Cities table.
```sql
    SELECT DISTINCT s."City"AS "Sales-City", c."City" AS "Cities-City"
    FROM "Sales" s
    LEFT JOIN "Cities" c ON s."City" = c."City"
    WHERE c."City" IS NULL;
    ```
* Updating city name with wrong spelling.
    ```sql
    UPDATE "Sales"
    SET "City" = ''Geneva''
    WHERE "City" =''Gensve'';
```
* Inserting missing city information into the cities table.
```sql
    INSERT INTO "Cities" ("Id", "City", "Latitude", "Longitude", "Country", "Iso2", "Iso3")
    SELECT *
    FROM (
        VALUES
            (13024, ''South Brisbane'', -27.4748, 153.018, ''Australia'', ''AU'', ''AUS''),
            (13025, ''Torino'', 45.0703, 7.6869, ''Italy'', ''IT'', ''ITA''),
            (13026, ''NYC'', 40.7128, 74.006, ''United States'', ''US'', ''USA''),
            (13027, ''Bruxelles'', 50.8503, 4.3517, ''Belgium'', ''BE'', ''BEL''),
            (13028, ''Glen Waverly'', -37.881, 145.164, ''Australia'', ''AU'', ''AUS''),
            (13029, ''Chatswood'', -33.7969, 151.182, ''Australia'', ''AU'', ''AUS''),
            (13030, ''Lule'', 65.5848, 22.1567, ''Sweden'', ''SE'', ''SWE''),
            (13031, ''Tsawassen'', 49.005, 123.082, ''Canada'', ''CA'', ''CAN''),
            (13032, ''Koln'', 50.9375, 6.9603, ''Germany'', ''DE'', ''DEU''),
            (13033, ''Brickhaven'', 35.5747, 79.0292, ''South Africa'', ''ZA'', ''ZAF''),
            (13034, ''North Sydney'', -33.839, 151.2093, ''Australia'', ''AU'', ''AUS''),
            (13035, ''Minato-ku'', 35.6581, 139.7516, ''Japan'', ''JP'', ''JPN''),
            (13036, ''Aaarhus'', 56.1629, 10.2039, ''Denmark'', ''DK'', ''DNK''),
            (13037, ''Kobenhavn'', 55.6761, 12.5683, ''Denmark'', ''DK'', ''DNK''),
            (13038, ''Stavern'', 59.0028, 10.0356, ''Norway'', ''NO'', ''NOR''),
            (13039, ''Manchester'', 53.4808, -2.2426, ''United Kingdom'', ''GB'', ''GBR''),
            (13040, ''Liverpool'', 53.4084, -2.9916, ''United Kingdom'', ''GB'', ''GBR'')
    ) AS cities_to_insert ("Id", "City", "Latitude", "Longitude", "Country", "Iso2", "Iso3")
    WHERE NOT EXISTS (
        SELECT 1
        FROM "Cities"
        WHERE "Cities"."City" = cities_to_insert."City"
    );
```
* Checking and updating only null states using values from Cities table.
```sql
    UPDATE "Sales"
    SET "State" = c."Iso2"
    FROM "Cities" c
    WHERE "Sales"."City" = c."City" AND "Sales"."State" IS NULL;
```

* Looking up Latitude, Longitude and State from Cities table into Sales table.
```sql
    UPDATE "Sales"
    SET "Latitude"  = "Cities"."Latitude",
        "Longitude" = "Cities"."Longitude"
    FROM "Cities"
    WHERE "Sales"."City" = "Cities"."City";
```

* Viewing rows with null Latitude, Longitude, State, and Postal code from Sales table.
```sql
    SELECT DISTINCT "City","Country","Latitude", "Longitude" FROM "Sales"
    WHERE "Latitude" IS NULL;

    SELECT DISTINCT "City","Country","Latitude", "Longitude" FROM "Sales"
    WHERE "State" IS NULL;

    SELECT DISTINCT "City","Postal Code","Country","Latitude", "Longitude" FROM "Sales"
    WHERE "Postal Code" IS NULL;
```
* Updating null postal codes for Los Angeles, and San Francisco in Sales table.

```sql
    UPDATE "Sales"
    SET "Postal Code"= ''90001''
    WHERE "City" = ''Los Angeles'';

    UPDATE "Sales"
    SET "Postal Code"= ''94102''
    WHERE "City" = ''San Francisco'';
```' as contents_md;


SELECT 'text' as component,
'## First Normal Form.
* Creating a primary key by combining ''Order Number'' and ''Order Line Number'' columns.
```sql
    ALTER TABLE "Sales"
    ADD COLUMN "Transaction ID" VARCHAR(200)

    ALTER TABLE "Sales" 
    ADD CONSTRAINT PK PRIMARY KEY("Transaction ID");

    UPDATE "Sales"
    SET "Transaction ID" = CAST("Order Number" AS TEXT)||CAST("Order Line Number" AS TEXT);

    SELECT * FROM "Sales";
```
***The table is now in 1NF First Normal Form (1NF)***
' as contents_md;

SELECT 'text' as component,
'## Second Normal Form(2NF).
  1. Already in 1NF: The table must conform to all the rules of First Normal Form,
     which means it should have atomic values, no repeating groups, and a unique identifier (primary key).
  2. No Partial Dependency: Every non-primary-key column attribute must depend on the entire primary key, not just part of it. 
	 This applies to tables with composite primary keys (keys with multiple columns).
 * ***If partial dependency occurs, then we need to minimize it by splitting the "Sales" table into smaller sub tables as follows.***
 ### STEPS:
 * Check for partial dependecny from "Sales" table on primary key "Transaction ID".
  ### Creating table for products with "Product Code" as the primary key.  Then drop other  product details from the "Sales" table leaving only the "Product Code" for reference by other tables.
```sql
    CREATE TABLE "Products" 
    (
        "Product Code" VARCHAR(100) PRIMARY KEY,
        "Product Line" VARCHAR(100),
        "Manfucturer Specied Retail Price" FLOAT
    );

    ALTER TABLE "Sales"
    ADD CONSTRAINT pr_fk FOREIGN KEY("Product Code") REFERENCES "Products"("Product Code");

    INSERT INTO "Products" ("Product Code","Product Line","Manfucturer Specied Retail Price")
    SELECT DISTINCT "Product Code","Product Line","Msrp"
    FROM "Sales"
    ORDER BY "Product Code" ASC;

 
    ALTER TABLE "Sales" 
    DROP COLUMN "Product Line",
    DROP COLUMN "Msrp";

    SELECT * FROM "Sales"
    ORDER BY "Customer Name"
```
***The table is now in Second Normal Form (2NF)***
' as contents_md;

select 
'text' as component,
'* Creating table for Cities with City ID for reference by other tables, and then inserting distinct city data from "Sales" table.
    ```sql
    CREATE TABLE "Cust City"
    ( "City ID" BIGINT GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    "City" VARCHAR(100),
    "Postal Code" VARCHAR(100),
    "Latitude" DOUBLE PRECISION,
    "Longitude" DOUBLE PRECISION,
    "State" VARCHAR(100),
    "Country" VARCHAR(100)
    );
   
    INSERT INTO "Cust City"("City","Postal Code","Latitude","Longitude","State","Country")
    SELECT DISTINCT "City","Postal Code","Latitude","Longitude","State","Country"
    FROM "Sales";

    ALTER TABLE "Cust City" 
    ADD CONSTRAINT city_Kdey PRIMARY KEY("City ID");

    SELECT * FROM "Cust City"
    ORDER BY "City";
    ```
* Insert City ID into the Sale table, populate City ID from City table then remove city information execpt city ID.
    ```sql
    ALTER TABLE "Sales"
    ADD COLUMN "City ID" BIGINT,
    ADD CONSTRAINT fk_city FOREIGN KEY ("City ID") REFERENCES "Cust City" ("City ID");

    UPDATE "Sales"
    SET "City ID" = "Cust City"."City ID"
    FROM "Cust City"
    WHERE "Sales"."City" = "Cust City"."City";
    ```
* Drop columnns with redudant city information from "Sales" table.
    ```sql
    ALTER TABLE "Sales"
    DROP COLUMN "City",
    DROP COLUMN "Postal Code",
    DROP COLUMN "Latitude",
    DROP COLUMN "Longitude",
    DROP COLUMN "State",
    DROP COLUMN "Territory", 
    DROP COLUMN "Country";
    ```

* Create a customer table with customer ID as the primary key. Then add "Customer ID" column as foreign key in the sales. 
* Also delete the redundant customer information from "Sales" table.
    ```sql
    DROP TABLE IF EXISTS "Customer";

    CREATE TABLE "Customer"
    ( 
    "Cust ID" BIGINT  PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1), 
    "Customer Name" VARCHAR(100),
    "Contact Name" VARCHAR(100),
    "Phone" VARCHAR(100),
    "Addressline 1" VARCHAR(100),
    "City ID" BIGINT,
    CONSTRAINT Cust_fk FOREIGN KEY ("City ID") REFERENCES "Cust City"("City ID")
    );
    ```

* Add Customer ID on the "Sales" table
    ```sql
    ALTER TABLE "Sales"
    ADD COLUMN "Customer ID" BIGINT,
    ADD CONSTRAINT Cust_fk FOREIGN KEY("Customer ID") REFERENCES "Customer"("Cust ID");
    ```
* Update Customer ID on the "Sales" table.
    ```sql
    UPDATE "Sales"
    SET "Customer ID" = c."Cust ID"
    FROM "Customer" c
    WHERE "Sales"."Customer Name" = c."Customer Name";
    ```
* Populate the customer table with records.
    ```sql
    INSERT INTO "Customer"("Customer Name", "Contact Name","Phone","Addressline 1","City ID")
    SELECT DISTINCT "Customer Name",
        COALESCE("Contact First Name",'' '')||'' ''||COALESCE("Contact Last Name",'' ''),
        "Phone",
        "Addressline 1",
        "City ID"
    FROM "Sales";
    ```

* Drop redundant customer related columns from "Sales" table. 
* Since "Customer ID" links "Customer" table, and the "Customer" table also has "City ID" linking to "Cust City" table, we can drop it too.
* Columns like "Qtr Id","Month Id","Year Id" can be dropped from the "Sales" table since we can generate them whenever we want from the "Order Date" column
    ```sql
    ALTER TABLE "Sales"
    DROP COLUMN "Customer Name",
    DROP COLUMN "Phone",
    DROP COLUMN "Addressline 1",
    DROP COLUMN "Contact Last Name",
    DROP COLUMN "Contact First Name",
    DROP COLUMN "City ID",
    DROP COLUMN "Qtr Id",
    DROP COLUMN "Month Id",
    DROP COLUMN "Year Id";
    ```

* Create "Order Status" table with "Status ID" as the primary key then populate it with data from "Sales" table
* Also add "Status ID" in the "Sales" table then  drop "Status" column from the "Sales" table.
```sql
    CREATE TABLE "Order Status"
    ( 
        "Status ID" BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        "Status" VARCHAR(100)
    );
    
    INSERT INTO "Order Status" ("Status")
    SELECT DISTINCT "Status"
    FROM "Sales";
    
    ALTER TABLE "Sales"
    ADD COLUMN "Order Status ID" BIGINT,
    ADD CONSTRAINT ord_sts FOREIGN KEY("Order Status ID") REFERENCES "Order Status"("Status ID");
    
    UPDATE "Sales"
    SET "Order Status ID" = o."Status ID"
    FROM "Order Status" o
    WHERE "Sales"."Status" = o."Status";
    
    ALTER TABLE "Sales"
    DROP "Status";

    SELECT * FROM "Sales";
```
* Create a table for "Deal Size" column with "Deal ID" as primary key wich is also a foreign key in "Sales" table.
* Populate the "Deal Size" table with distinct values from "Sales" table.
* Update the sales table to have the "Deal ID" column, then drop the "Deal Size" column.
```sql

   CREATE TABLE "Deal Size"("Deal ID" BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
                            "Deal Size" VARCHAR(100));

	INSERT INTO "Deal Size"("Deal Size")
	SELECT DISTINCT "Deal Size"
	FROM "Sales";


	ALTER TABLE "Sales"
	ADD COLUMN "Deal ID" BIGINT,
	ADD CONSTRAINT deal_fk FOREIGN KEY("Deal ID") REFERENCES "Deal Size"("Deal ID");

    UPDATE "Sales"
	SET "Deal ID" = d."Deal ID"
	FROM "Deal Size" d
	WHERE "Sales"."Deal Size" = d."Deal Size";

	ALTER TABLE "Sales"
	DROP COLUMN "Deal Size";
```
* Create "Orders" table with primary key as the "Order Number", and "Order Date" and "Customer ID" as other columns
* Also drop redundant order columns from the "Sales" data.
    ```sql
    CREATE TABLE "Orders" 
    (  "Order Number" INT PRIMARY KEY,
        "Order Status ID" BIGINT,
        "Order Date" TIMESTAMP,
        "Customer ID" BIGINT
        );
                            
    INSERT INTO "Orders" ("Order Number","Order Status ID","Order Date","Customer ID")
    SELECT DISTINCT "Order Number","Order Status ID","Order Date","Customer ID"
    FROM "Sales"
    ORDER BY "Order Number" ASC;

    ALTER TABLE "Orders"
    ADD CONSTRAINT "Order Number" TYPE 


    ALTER TABLE "Sales"
    DROP COLUMN "Order Date",
    DROP COLUMN "Customer ID",
    DROP COLUMN "Order Status ID";
    ```

* Create a new table called "Transactions" to help rearrange columns with "Transaction ID" as the first column.Then drop the "Sales" table.
    ```sql
    CREATE TABLE "Transactions" AS
    (SELECT
    "Transaction ID",
    "Product Code",
    "Order Number",
    "Order Line Number",
    "Deal ID",
    "Quantity Ordered",
    "Price Each",
    "Sales"
    FROM "Sales"
    ORDER BY "Transaction ID" ASC
    );

    ALTER TABLE "Transactions"
    ADD CONSTRAINT tr_pr_ky PRIMARY KEY("Transaction ID");
    ```
' as contents_md;

SELECT 'text' as component,
'## Third Normal Form(3NF).
 * A table is in 3NF if it meets the following conditions:
  1. Every non-key attribute must depend directly on the primary key and not indirectly via another non-key attribute.
  2. It is in Second Normal Form (2NF) – This means there are no partial dependencies (i.e., no non-prime attribute depends on only part of a candidate key).
  3.It has no transitive dependencies – No non-key attribute should depend on another non-key attribute. Instead, all non-key attributes must depend directly on the primary key.


* Check:
    ```sql
    SELECT * FROM "Cust City"; 
    ```
 * Transitive dependency: State depends on "City ID" via "City". Country also depends on "City ID" indirectly via State and City.
 * Solution : Move the States and Country data into a new table called "Sates" then create a foreign key columns for reference by the tables.

    ```sql
    CREATE TABLE "States"
    (  
    "State ID" BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    "State" VARCHAR(100),
    "Country" VARCHAR(100),
    "Cntry ID" BIG =INT
    );

    INSERT INTO "States"("State","Country")
    SELECT DISTINCT "State","Country"
    FROM "Cust City";
    
    SELECT * FROM "States";
    ```
  
* Since country does not depend directly on the primary key column of the "States" table, that is "State ID", we get a transitive dependency.This violates the rules of 3NF.
* To solve this:
  1. We need to create a new column for "Country ID" on "States" table to reference the "Country" table and then delete Country column only after populating "Country ID" on the "States" table from the new "Country" table created.
  2. We need drop redundant "State" and "Country" columns from the "Cust City" table.

```sql
    CREATE TABLE "Country"
    (  
    "Cntry ID" BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    "Country" VARCHAR(100)
    );

    INSERT INTO "Country"("Country")
    SELECT DISTINCT "Country"
    FROM "Cust City";

    UPDATE "States"
    SET "Cntry ID" = c."Cntry ID"
    FROM "Country" c
    WHERE "States"."Country" = c."Country";

    ALTER TABLE "States"
    DROP COLUMN "Country";

    ALTER TABLE "Cust City"
    DROP COLUMN "State",
    DROP COLUMN "Country";
```
* Insert "State ID" into the "Cust City" as foreign key field, then populate the column using "State ID" from "States" table.

    ```sql
    ALTER TABLE "Cust City"
    ADD COLUMN "State ID" BIGINT,
    ADD CONSTRAINT st_fk FOREIGN KEY("State ID") REFERENCES "States"("State ID");

    UPDATE "Cust City"
    SET "State ID" = "States"."State ID"
    FROM "States" 
    WHERE  "Cust City"."State"= "States"."State";
    ```
* I realized that some cities with more than one postal code existed in my "Cust City", with an exception of ''Glendale''.
* I use the window function ROW_NUMBER() to fetch duplicate values in the "City" column as follows: 
    ```sql
    SELECT * FROM
    (
    SELECT "City ID","City","Postal Code","State",
    ROW_NUMBER() OVER(PARTITION BY "City" ORDER BY "City" ASC) AS city_cnt
    FROM "Cust City") AS x;
    ```

* Update the "Cust City" table with the first occurence of the "Postal Code" of a duplicate city record.
* Do not update for ''Glendale'' city since it exists in more than one state. Sounds like a table self-update🤗🤗🤗.
    ```sql
    UPDATE "Cust City"
    SET "Postal Code" = x."Postal Code"
    FROM( 
        SELECT "City ID","City","Postal Code",
                ROW_NUMBER() OVER(PARTITION BY "City" ORDER BY "City" ASC) AS city_cnt
        FROM "Cust City") AS x
    WHERE x.city_cnt = 1 AND
        x."City" = "Cust City"."City" AND
        x."City" <>''Glendale'';
    ```

* Delete from the "Cust City" duplicate record in the "City" column.
* N/B : "City ID" is a foreign column in "Customer" table, so we cannot delete the record directly from "Cust City".
*     :  We need to delete the records with the "City ID" returned in the query below from the "Customer" table first
    ```sql
    CREATE TEMP TABLE temp_id AS 
    SELECT "City ID"
    FROM (SELECT "City ID","City",ROW_NUMBER() OVER(PARTITION BY "City" ORDER BY "City" ASC) AS city_count
        FROM "Cust City")
        WHERE city_count>1
        AND "City"<>''Glendale'';   --- This is a temporary table for the open session only.
    ```
* Delete from "Customer" table the "City ID" returned in the above query as follows:
    ```sql
    DELETE FROM "Customer" 
    WHERE "City ID" IN(SELECT * FROM temp_id);

    DELETE FROM "Cust City"
    WHERE "City ID" IN(SELECT * FROM temp_id);
                        
    SELECT * FROM "Cust City";
    SELECT * FROM "States";
    SELECT * FROM "Country";
    ```
    * Check:
    ```sql
    SELECT * FROM "Customer";
    ```
    ***Already in 3NF***

    * Check:
    ```sql
    SELECT * FROM "Products"; 
    ```
* Already in 3NF since both the ''Product Line'' and "Retail Price" depend directly on the "Product Code" column.
* However, we need to break "Product Line" from the table "Products" then create a "Line Code" on "Products",foreign key column.
* Then update the "Products" table accordingly.

		CREATE TABLE "Product Line" 
		  (
		    "Line Code"  BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
			"Product Line" VARCHAR(100)
		  );

		  INSERT INTO "Product Line"("Product Line")
		  SELECT DISTINCT "Product Line"
		  FROM "Products";
		  
		  SELECT * FROM "Product Line";

		  ALTER TABLE "Products"
		  ADD COLUMN "Line Code" BIGINT;

		  ALTER TABLE "Products"
		  ADD CONSTRAINT ln_cd FOREIGN KEY("Line Code") REFERENCES "Product Line"("Line Code");

		  UPDATE  "Products"
		  SET "Line Code" = p."Line Code"
		  FROM "Product Line" p
		  WHERE "Products"."Product Line" = p."Product Line";

		  ALTER TABLE "Products"
		  DROP COLUMN "Product Line";
 
		  SELECT * FROM "Products";
          ' as contents_md;
          
        







