/******* PHARMA DATA ANALYSIS *******/
--- SELECT * FROM PHARMA_DATA$ ---

/*Q--1  Retrieve all columns for all records in the dataset.*/

        SELECT * FROM PHARMA_DATA$ 

/*Q--2  How many unique countries are represented in the dataset?*/

        SELECT DISTINCT COUNTRY FROM PHARMA_DATA$

/*Q--3  Select the names of all the customers on the 'Retail' channel.*/

        SELECT CUSTOMER_NAME FROM PHARMA_DATA$
		WHERE SUB_CHANNEL ='RETAIL'

/*Q--4  Find the total quantity sold for the ' Antibiotics' product class.*/
        
		SELECT DISTINCT PRODUCT_CLASS, SUM(QUANTITY) AS TOT_QTY FROM PHARMA_DATA$
		GROUP BY PRODUCT_CLASS
		HAVING PRODUCT_CLASS ='Antibiotics'

/*Q--5  List all the distinct months present in the dataset.*/

        SELECT DISTINCT MONTH FROM PHARMA_DATA$ A
		ORDER BY 1

/*Q--6  Calculate the total sales for each year.*/

        SELECT A.YEAR , SUM(SALES) AS TOT_SALES FROM PHARMA_DATA$ A
		GROUP BY A.YEAR

/*Q--7  Find the customer with the highest sales value.*/

        SELECT TOP 1 CUSTOMER_NAME, SUM(SALES)AS SALE_VALUE
		FROM PHARMA_DATA$
		GROUP BY CUSTOMER_NAME
		ORDER BY 2 DESC

/*Q--8  Get the names of all employees who are Sales Reps 
        and are managed by 'James Goodwill'.*/

		SELECT DISTINCT NAME_OF_SALES_REP, MANAGER FROM PHARMA_DATA$
		WHERE MANAGER LIKE '%JAMES_%'

/*Q--9  Retrieve the top 5 cities with the highest sales.*/

        SELECT TOP 5 CITY, SUM(SALES) FROM PHARMA_DATA$
		GROUP BY CITY
		ORDER BY 2 DESC

/*Q-10  Calculate the average price of products in each sub-channel.*/

        SELECT SUB_CHANNEL, AVG(PRICE)AS AVG_PRICE
		FROM PHARMA_DATA$
		GROUP BY SUB_CHANNEL

/*Q-11  Join the 'Employees' table with the 'Sales' table to get
        the name of the Sales Rep and the corresponding sales records.*/

		SELECT NAME_OF_SALES_REP, SUM(SALES) AS SALES FROM PHARMA_DATA$
		GROUP BY NAME_OF_SALES_REP

/*Q-12  Retrieve all sales made by employees from ' Rendsburg ' 
        in the year 2018.*/

		SELECT NAME_OF_SALES_REP, SUM(SALES) AS SALES
		FROM PHARMA_DATA$
		WHERE CITY ='RENDSBURG' AND YEAR =2018
		GROUP BY NAME_OF_SALES_REP

		--NO DATA SHOWING BECAUSE OF DATA LOAD LIMITATION

/*Q-13 Calculate the total sales for each product class, 
       for each month, and order the results by year, month, and product class.*/

	   SELECT PRODUCT_CLASS, YEAR , MONTH, SUM(SALES)AS SALES FROM PHARMA_DATA$
       GROUP BY PRODUCT_CLASS, YEAR , MONTH
	   ORDER BY YEAR, MONTH, PRODUCT_CLASS

/*Q-14 Find the top 3 sales reps with the highest sales in 2019.*/

       SELECT TOP 3 NAME_OF_SALES_REP, SUM(SALES) FROM PHARMA_DATA$
	   WHERE YEAR=2019
	   GROUP BY NAME_OF_SALES_REP
	   ORDER BY SUM(SALES) DESC

	   --NO DATA BECAUSE OF DATA LOAD LIMIT

/*Q-15 Calculate the monthly total sales for each sub-channel, 
       and then calculate the average monthly sales for each sub-channel over the years.*/
	          
	   SELECT SUB_CHANNEL, YEAR, MONTH, SUM(SALES)AS SALES, 
	          AVG(SALES)AS MONTH_AVG_SALE 
	   FROM PHARMA_DATA$
	   GROUP BY SUB_CHANNEL, YEAR, MONTH
	   ORDER BY SUB_CHANNEL, YEAR

/*Q-16 Create a summary report that includes the total sales, average price, 
       and total quantity sold for each product class.*/

	   SELECT PRODUCT_CLASS,  SUM(SALES)AS TOTAL_SALES,
	          ROUND(AVG(PRICE),2)AS AVG_PRICE
	   FROM PHARMA_DATA$
	   GROUP BY PRODUCT_CLASS

/*Q-17 Find the top 5 customers with the highest sales for each year.*/

       WITH CTE AS
	               (
	                SELECT CUSTOMER_NAME, YEAR, SUM(SALES)AS TOT_SALES,
					DENSE_RANK() OVER ( PARTITION BY YEAR 
					                     ORDER BY SUM(SALES) DESC)AS RNK
	                FROM PHARMA_DATA$
	                GROUP BY CUSTOMER_NAME, YEAR
					)
	          SELECT *    
			  FROM CTE
			  WHERE RNK<=5

/*Q-18 Calculate the year-over-year growth in sales for each country.*/

       SELECT COUNTRY, YEAR, SUM(SALES)TOT_SALES,
	   LAG(SUM(SALES)) OVER (PARTITION BY COUNTRY ORDER BY YEAR) AS PREV_YR_SALE,
	   CASE 
	   WHEN LAG(SUM(SALES)) OVER (PARTITION BY COUNTRY ORDER BY YEAR) IS NOT NULL
	    THEN (SUM(SALES))-LAG(SUM(SALES)) OVER (PARTITION BY COUNTRY ORDER BY YEAR)/LAG(SUM(SALES))
		OVER (PARTITION BY COUNTRY ORDER BY YEAR)*100
	   ELSE NULL
	   END AS PERC_CHANGE
	   FROM PHARMA_DATA$
	   GROUP BY COUNTRY, YEAR

	   --NO ANSWER AS NO CORRECT DATA

/*Q-19 List the months with the lowest sales for each year*/

       WITH CTE AS 
	              (
				  SELECT MONTH, YEAR, SUM(SALES)AS SALES,
	              RANK() OVER (PARTITION BY YEAR ORDER BY SUM(SALES) ASC)AS RNK
	              FROM PHARMA_DATA$
	              GROUP BY MONTH, YEAR
				  )
	   SELECT * FROM CTE WHERE RNK<=2
	   
/*Q-20 Calculate the total sales for each sub-channel in each country, 
       and then find the country with the highest total sales for each sub-channel.*/

	   WITH CTE AS
	   (
	   SELECT SUB_CHANNEL, COUNTRY, SUM(SALES)AS SALES,
	   RANK() OVER (PARTITION BY SUB_CHANNEL ORDER BY SUM(SALES) DESC)AS RNK
	   FROM PHARMA_DATA$
	   GROUP BY SUB_CHANNEL, COUNTRY
	   )
	   SELECT * FROM CTE WHERE RNK=1


------END OF PHARMA ANALYSIS -----



       