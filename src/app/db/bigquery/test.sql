WITH stg_orders AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        total_amount,
        order_status
    FROM public.orders
    WHERE order_date >= '2026-01-01'
),

stg_customers AS (
    SELECT
        customer_id,
        customer_name,
        email,
        country
    FROM public.customers
),

aggregated_customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.country,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.total_amount), 0) AS total_spent
    FROM stg_customers AS c
    LEFT JOIN stg_orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.country
)

SELECT
    customer_id,
    customer_name,
    country,
    total_orders,
    total_spent
FROM aggregated_customer_sales
WHERE total_orders > 0;
