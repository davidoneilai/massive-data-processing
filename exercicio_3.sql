-- 3. Quantos clientes tiveram compra com mais de um vendedor no ano de 2024?

WITH clients_with_one_or_one_more_salesman AS (
    SELECT
        client_id,
        salesman_id,
        COUNT(*) AS total_orders
    FROM `pdm-savio.davidoneilPDM.orders`
    WHERE EXTRACT(YEAR FROM order_date) = 2024 
    GROUP BY client_id, salesman_id
),
clients_with_multiple_salesmen AS (
    SELECT 
        client_id,
        COUNT(DISTINCT salesman_id) AS salesmen_count
    FROM clients_with_one_or_one_more_salesman
    GROUP BY client_id
    HAVING COUNT(DISTINCT salesman_id) > 1
)
SELECT COUNT(*) AS total_clients_with_multiple_salesmen
FROM clients_with_multiple_salesmen;