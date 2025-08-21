-- 1. Liste o nome dos 10 clientes que mais compraram no ano de 2023.

WITH totais_2023 AS (
  SELECT
    client_id,
    company_id,
    SUM(items_count) AS total_itens
  FROM `pdm-savio.davidoneilPDM.orders`
  WHERE EXTRACT(YEAR FROM order_date) = 2023
  GROUP BY client_id, company_id
),
clients_dedup AS (
  SELECT
    client_id,
    company_id,
    ANY_VALUE(NOME_FANTASIA) AS NOME_FANTASIA
  FROM `pdm-savio.davidoneilPDM.clients`
  GROUP BY client_id, company_id
)
SELECT
  t.client_id,
  t.company_id,
  c.NOME_FANTASIA,
  t.total_itens
FROM totais_2021 t
LEFT JOIN clients_dedup c
USING (client_id, company_id)
ORDER BY t.total_itens DESC
LIMIT 10;
