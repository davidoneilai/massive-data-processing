CREATE
OR REPLACE TABLE davidoneilPDM.compras_gold AS
SELECT
  client_id,
  company_id,
  EXTRACT(MONTH FROM order_date) as mes,
  EXTRACT(YEAR FROM order_date) as ano,
  count(*) as numero_pedidos
from
  davidoneilPDM.orders
GROUP BY
  client_id,
  company_id,
  order_date,
  ano
ORDER BY
  client_id,
  company_id,
  order_date,
  ano