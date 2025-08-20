-- 4. Qual o vendedor com maior volume de vendas analisando todo o histórico de compras?

SELECT
    salesman_id,
    SUM(items_count) AS total_sales_volume
FROM `pdm-savio.davidoneilPDM.orders`
GROUP BY salesman_id
ORDER BY total_sales_volume DESC
LIMIT 1;