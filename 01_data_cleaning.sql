/*==============================================================
 CHOCOLATE SALES ANALYSIS
 DATA CLEANING
==============================================================*/

CREATE TABLE chocolate_sales (
    sales_person VARCHAR(100),
    country VARCHAR(50),
    product VARCHAR(100),
    sale_date VARCHAR(20),
    amount VARCHAR(20),
    boxes_shipped INT
);


SELECT * FROM chocolate_sales

/*--------------------------------------------------------------
Create cleaned amount numeric column
--------------------------------------------------------------*/
ALTER TABLE chocolate_sales
ADD COLUMN amount_numeric NUMERIC (10,2);

UPDATE chocolate_sales
SET amount_numeric = REPLACE(REPLACE (amount, '$', ''),
',', '')::NUMERIC;

/*--------------------------------------------------------------
Create proper DATE column
--------------------------------------------------------------*/
ALTER TABLE chocolate_sales
ADD COLUMN sale_date_actual DATE;

SELECT DISTINCT sale_date
FROM chocolate_sales
ORDER BY sale_date;

UPDATE chocolate_sales
SET sale_date_actual = TO_DATE(sale_date, 'DD-MM-YYYY');

/*--------------------------------------------------------------
Verify cleaned data
--------------------------------------------------------------*/

SELECT *
FROM chocolate_sales
LIMIT 10;