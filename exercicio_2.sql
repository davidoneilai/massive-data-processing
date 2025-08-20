-- 2. Quais os 5 estados do Brasil que tiveram mais vendas no mês de janeiro de 2024?

WITH orders_jan_2024 AS (
  SELECT
    client_id,
    company_id,
    SUM(items_count) AS total_itens
  FROM `pdm-savio.davidoneilPDM.orders`
  WHERE DATE(order_date) BETWEEN '2024-01-01' AND '2024-01-31'
  GROUP BY client_id, company_id
),
clients_dedup AS (
  SELECT
    client_id,
    company_id,
    ANY_VALUE(UF) AS estado    
  FROM `pdm-savio.davidoneilPDM.clients`
  GROUP BY client_id, company_id
)
SELECT
  c.estado,
  SUM(o.total_itens) AS total_itens
FROM orders_jan_2024 o
JOIN clients_dedup c USING (client_id, company_id)
GROUP BY c.estado
ORDER BY total_itens DESC
LIMIT 5;
