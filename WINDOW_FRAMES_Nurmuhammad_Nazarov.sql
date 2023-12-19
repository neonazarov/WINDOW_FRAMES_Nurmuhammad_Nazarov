WITH SalesData AS (
    SELECT 
        sales_date,
        sales_amount,
        EXTRACT(WEEK FROM sales_date) AS week_num
    FROM 
        sales_table
    WHERE 
        sales_date BETWEEN '1999-12-06' AND '1999-12-31' -- Adjust this range as needed
),
CumulativeSum AS (
    SELECT 
        sales_date,
        sales_amount,
        week_num,
        SUM(sales_amount) OVER (PARTITION BY week_num ORDER BY sales_date) AS cum_sum
    FROM 
        SalesData
)
SELECT 
    s.sales_date,
    s.sales_amount,
    s.week_num,
    s.cum_sum,
    AVG(s.sales_amount) OVER (ORDER BY s.sales_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS centered_3_day_avg
FROM 
    CumulativeSum s
ORDER BY 
    s.sales_date;
