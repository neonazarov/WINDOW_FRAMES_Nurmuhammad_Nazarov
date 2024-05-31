-- create table
CREATE TABLE sales (
    sales_id SERIAL PRIMARY KEY,
    sales_date DATE,
    sales_amount DECIMAL(10, 2)
);

-- insert
INSERT INTO sales (sales_date, sales_amount) VALUES
('1999-12-01', 100.00),  -- Week 49
('1999-12-02', 150.00),  -- Week 49
('1999-12-03', 200.00),  -- Week 49
('1999-12-04', 120.00),  -- Week 49 (Saturday)
('1999-12-05', 130.00),  -- Week 49 (Sunday)
('1999-12-06', 110.00),  -- Week 50
('1999-12-07', 140.00),  -- Week 50
('1999-12-08', 160.00),  -- Week 50
('1999-12-09', 170.00),  -- Week 50
('1999-12-10', 180.00), -- Week 50
('1999-12-11', 190.00), -- Week 50 (Saturday)
('1999-12-12', 210.00), -- Week 50 (Sunday)
('1999-12-13', 220.00), -- Week 51
('1999-12-14', 230.00), -- Week 51
('1999-12-15', 240.00), -- Week 51
('1999-12-16', 250.00), -- Week 51
('1999-12-17', 260.00), -- Week 51
('1999-12-18', 270.00), -- Week 51 (Saturday)
('1999-12-19', 280.00); -- Week 51 (Sunday)

-- query
WITH SalesData AS (
    SELECT 
        sales_date,
        sales_amount,
        EXTRACT(WEEK FROM sales_date) AS sales_week,
        EXTRACT(DOW FROM sales_date) AS sales_day
    FROM 
        sales
    WHERE 
        EXTRACT(WEEK FROM sales_date) BETWEEN 49 AND 51
        AND EXTRACT(YEAR FROM sales_date) = 1999
),
CumulativeSales AS (
    SELECT 
        sales_date,
        sales_amount,
        sales_week,
        sales_day,
        SUM(sales_amount) OVER (ORDER BY sales_date) AS CUM_SUM
    FROM 
        SalesData
),
CenteredMovingAvg AS (
    SELECT 
        sales_date,
        sales_amount,
        sales_week,
        sales_day,
        CUM_SUM,
        CASE
            WHEN sales_day = 1 THEN -- Monday
                AVG(sales_amount) OVER (ORDER BY sales_date ROWS BETWEEN 2 PRECEDING AND 1 FOLLOWING)
            WHEN sales_day = 5 THEN -- Friday
                AVG(sales_amount) OVER (ORDER BY sales_date ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING)
            ELSE -- Other days
                AVG(sales_amount) OVER (ORDER BY sales_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
        END AS CENTERED_3_DAY_AVG
    FROM 
        CumulativeSales
)
SELECT 
    sales_date,
    sales_amount,
    sales_week,
    sales_day,
    CUM_SUM,
    CENTERED_3_DAY_AVG
FROM 
    CenteredMovingAvg
ORDER BY 
    sales_date;
