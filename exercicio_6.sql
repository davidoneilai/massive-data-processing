--- 6. Qual a média do valor total das vendas por dia da semana em cada estado no ano de 2024?

WITH sales_by_state_day AS (
    SELECT 
        c.uf,
        EXTRACT(DAYOFWEEK FROM o.order_date) AS day_of_week_num,
        CASE 
            WHEN EXTRACT(DAYOFWEEK FROM o.order_date) = 1 THEN 'Sunday'
            WHEN EXTRACT(DAYOFWEEK FROM o.order_date) = 2 THEN 'Monday'
            WHEN EXTRACT(DAYOFWEEK FROM o.order_date) = 3 THEN 'Tuesday'
            WHEN EXTRACT(DAYOFWEEK FROM o.order_date) = 4 THEN 'Wednesday'
            WHEN EXTRACT(DAYOFWEEK FROM o.order_date) = 5 THEN 'Thursday'
            WHEN EXTRACT(DAYOFWEEK FROM o.order_date) = 6 THEN 'Friday'
            WHEN EXTRACT(DAYOFWEEK FROM o.order_date) = 7 THEN 'Saturday'
        END AS day_of_week_name,
        o.order_date,
        SUM(i.items_count * i.list_price) AS daily_total_value
    FROM `pdm-savio.davidoneilPDM.orders` o
    INNER JOIN `pdm-savio.davidoneilPDM.clients` c ON o.client_id = c.client_id
    INNER JOIN `pdm-savio.davidoneilPDM.items` i ON o.order_id = i.order_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2024
    GROUP BY c.uf, EXTRACT(DAYOFWEEK FROM o.order_date), o.order_date
)
SELECT 
    uf AS state,
    day_of_week_name AS day_of_week,
    ROUND(AVG(daily_total_value), 2) AS average_daily_sales
FROM sales_by_state_day
GROUP BY uf, day_of_week_num, day_of_week_name
ORDER BY uf, day_of_week_num;