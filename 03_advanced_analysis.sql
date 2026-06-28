/*==============================================================
 CHOCOLATE SALES ANALYSIS
 ADVANCED SQL
==============================================================*/



/*==============================================================
1. WINDOW FUNCTIONS
==============================================================*/


/*--------------------------------------------------------------
1.1 Best-selling product in each country
--------------------------------------------------------------*/

WITH ProductRevenue AS (
	SELECT
		country,
		product,
		SUM(amount_numeric) AS revenue,
		RANK() OVER(
		PARTITION BY country
	ORDER BY SUM(amount_numeric) DESC) AS rank_num
	FROM chocolate_sales
	GROUP BY country, product
)

SELECT *
FROM ProductRevenue
WHERE rank_num = 1;



/*--------------------------------------------------------------
1.2 Salesperson ranking based on total revenue
--------------------------------------------------------------*/

SELECT
	sales_person,
	SUM(amount_numeric) AS revenue,
	RANK() OVER(
	ORDER BY SUM(amount_numeric) DESC) AS sales_person_rank
FROM chocolate_sales
GROUP BY sales_person;



/*--------------------------------------------------------------
1.3 Top 3 ranked salespeople
--------------------------------------------------------------*/

WITH ranked_sales AS (
	SELECT
		sales_person,
		SUM(amount_numeric) AS revenue,
		RANK() OVER(
		ORDER BY SUM(amount_numeric) DESC) AS rank_num
	FROM chocolate_sales
	GROUP BY sales_person
)

SELECT *
FROM ranked_sales
WHERE rank_num <=3;



/*==============================================================
2. SALES PERFORMANCE
==============================================================*/


/*--------------------------------------------------------------
2.1 Year-over-year revenue growth
--------------------------------------------------------------*/

WITH yearly_sales AS (
	SELECT
		EXTRACT(YEAR FROM sale_date_actual) AS year,
		SUM(amount_numeric) AS revenue
	FROM chocolate_sales
	GROUP BY EXTRACT(YEAR FROM sale_date_actual)
)

SELECT
	year,
	revenue,
	LAG(revenue) OVER(ORDER BY year) AS previous_year,
	ROUND((revenue-LAG(revenue) OVER(ORDER BY year))*100.0/LAG(revenue) OVER(ORDER BY year),2) AS growth_percentage
FROM yearly_sales;



/*--------------------------------------------------------------
2.2 Pareto Analysis (80/20 Rule)

Determine how much each product contributes
to overall company revenue.
--------------------------------------------------------------*/

WITH ProductSales AS (

	SELECT
		product,
		SUM(amount_numeric) AS revenue
	FROM chocolate_sales
	GROUP BY product)

SELECT
	product,
	revenue,
	ROUND(
	revenue*100.0/
	SUM(revenue) OVER(),2) AS contribution_percentage,
	SUM(revenue) OVER(ORDER BY revenue DESC) AS cumulative_revenue
FROM ProductSales
ORDER BY revenue DESC;



/*--------------------------------------------------------------
2.3 Best-performing month in each year
--------------------------------------------------------------*/

WITH monthly_sales AS(
	SELECT
		EXTRACT(YEAR FROM sale_date_actual) AS year,
		EXTRACT(MONTH FROM sale_date_actual) AS month,
		SUM(amount_numeric) AS revenue
	FROM chocolate_sales
	GROUP BY year, month)

SELECT *
	FROM(
		SELECT *,
			RANK() OVER(PARTITION BY year ORDER BY revenue DESC) AS rank_num
		FROM monthly_sales
	)t
WHERE rank_num = 1;