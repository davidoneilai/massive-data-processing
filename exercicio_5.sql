-- 5. Qual o produto mais vendido (em quantidade) por estado brasileiro e qual o valor total de vendas deste produto em cada estado?

WITH vendas_por_estado_produto AS (
    SELECT 
        c.uf,
        i.product_id,
        SUM(i.items_count) AS quantidade_total,
        SUM(i.items_count * i.list_price) AS valor_total_vendas
    FROM `pdm-savio.davidoneilPDM.orders` o
    INNER JOIN pdm-savio.davidoneilPDM.clients c ON o.client_id = c.client_id
    INNER JOIN pdm-savio.davidoneilPDM.items i ON o.order_id = i.order_id
    GROUP BY c.uf, i.product_id
),
produto_mais_vendido_por_estado AS (
    SELECT 
        uf,
        product_id,
        quantidade_total,
        valor_total_vendas,
        ROW_NUMBER() OVER (PARTITION BY uf ORDER BY quantidade_total DESC) as ranking
    FROM vendas_por_estado_produto
)
SELECT 
    uf AS estado,
    product_id AS produto_mais_vendido,
    quantidade_total,
    valor_total_vendas
FROM produto_mais_vendido_por_estado
WHERE ranking = 1
ORDER BY uf;