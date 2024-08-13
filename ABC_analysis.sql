--In this SQL project, I am going to perform an ABC analysis based on this data set.
--ABC analysis is a common method of categorizing products, goods or services by how much they contribute to a company's bottom line.
--Group A - the most valuable products, they provide 80% of sales.
--Group B - intermediate positions, they provide 15% of sales.
--Group C - the least valuable positions, they provide 5% of sales.

--LET'S START

--Connecting the data files List of Orders.csv and Order Details.csv to Postgres SQL
CREATE TABLE list_of_orders (
    order_id VARCHAR,
    order_date DATE,
    customer_name VARCHAR,
    state VARCHAR
);

COPY list_of_orders FROM '/Users/mariaivanova/Downloads/List of Orders.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE order_details (
    order_id VARCHAR,
    amount FLOAT,
    profit FLOAT,
    quantity INT,
    category VARCHAR,
    sub_category VARCHAR
);

COPY order_details FROM '/Users/mariaivanova/Downloads/Order Details.csv' DELIMITER ',' CSV HEADER;

--Joining the two tables and creating a dataset with total-profit information for each sub-category.
WITH profit_by_sub_category AS
(SELECT sub_category, SUM(profit) AS sub_category_profit
FROM 
list_of_orders
INNER JOIN order_details 
USING (order_id)
GROUP BY sub_category),

--Creating new columns. Profit share is shows what contribution does the sub-category make to the formation of profits.
profit_share_by_category AS
(SELECT sub_category, sub_category_profit,
ROUND((sub_category_profit / SUM(sub_category_profit) OVER () * 100)::DECIMAL, 2) AS profit_share
FROM profit_by_sub_category
WHERE sub_category_profit > 0)

--Let's calculate the comulative total and give each sub-category a score using the CASE function
SELECT sub_category, profit_share, 
CASE
WHEN cumulative_share < 80 THEN 'A'
WHEN cumulative_share < 95 THEN 'B'
ELSE 'C'
END AS ABC
FROM 
(SELECT sub_category, profit_share,
SUM(profit_share) OVER (ORDER BY profit_share DESC) AS cumulative_share
FROM profit_share_by_category) AS cum_by_sub_category

--RESULTS 
--The ABС analysis assigned a score to each sub-category, and based on this information, managers can 
--better manage inventories and make strategic decisions. 
