-- Task 1
SELECT SUM(o.quantity * o.selling_price) AS total_revenue, SUM(o.quantity * p.cost_price) AS total_cost,
    SUM(o.quantity * o.selling_price) - SUM(o.quantity * p.cost_price) AS total_profit
FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
WHERE o.order_status = 'DELIVERED';

-- Task 2
SELECT p.category, SUM(o.quantity * o.selling_price) AS total_sales, SUM(o.quantity * p.cost_price) AS total_cost,
    SUM(o.quantity * o.selling_price) - SUM(o.quantity * p.cost_price) AS total_profit
FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
WHERE o.order_status = 'DELIVERED'
GROUP BY p.category
ORDER BY total_profit DESC;

-- Task 3
SELECT p.product_id, SUM(o.quantity * o.selling_price) AS total_revenue, SUM(o.quantity * p.cost_price) AS total_cost,
    SUM(o.quantity * o.selling_price) - SUM(o.quantity * p.cost_price) AS total_profit
FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
WHERE o.order_status = 'DELIVERED'
GROUP BY p.product_id
HAVING SUM(o.quantity * o.selling_price) - SUM(o.quantity * p.cost_price) < 0
ORDER BY total_profit ASC;

-- Task 4
SELECT COUNT(DISTINCT d.order_id) AS orders_with_discount, SUM(d.discount_amount) AS total_discount_amount
FROM discounts_v2 d
JOIN orders_v2 o ON d.order_id = o.order_id
WHERE o.order_status = 'DELIVERED';

-- Task 5
SELECT o.payment_method, COUNT(DISTINCT o.order_id) AS total_orders, SUM(o.quantity * o.selling_price) AS total_sales
FROM orders_v2 o
WHERE o.order_status = 'DELIVERED'
GROUP BY o.payment_method
ORDER BY total_sales DESC;

-- Task 6
SELECT 
    CASE 
        WHEN d.order_id IS NULL THEN 'Non-Discounted'
        ELSE 'Discounted'
    END AS order_type,
    
    AVG(
        o.quantity * (o.selling_price - p.cost_price) - IFNULL(d.discount_amount, 0)
    ) AS avg_profit_per_order

FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
LEFT JOIN discounts_v2 d ON o.order_id = d.order_id
WHERE o.order_status = 'DELIVERED'
GROUP BY order_type;

-- Task 7
SELECT SUM(o.quantity * o.selling_price) AS revenue_lost, SUM(o.quantity * (o.selling_price - p.cost_price)) AS profit_lost
FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
JOIN returns_v2 r ON o.order_id = r.order_id
WHERE o.order_status = 'DELIVERED' AND r.return_flag = 'Y';

-- Task 8
SELECT r.return_reason, COUNT(*) AS total_returns, SUM(o.quantity * o.selling_price) AS revenue_lost
FROM returns_v2 r
JOIN orders_v2 o ON r.order_id = o.order_id
WHERE o.order_status = 'DELIVERED' AND r.return_flag = 'Y'
GROUP BY r.return_reason
ORDER BY revenue_lost DESC;

-- Task 9
SELECT o.order_id, (o.quantity * o.selling_price) AS order_value, (l.shipping_cost + l.reverse_shipping_cost) AS total_logistics_cost,
    (l.shipping_cost + l.reverse_shipping_cost) * 100.0 / (o.quantity * o.selling_price) AS logistics_cost_pct
FROM orders_v2 o
JOIN logistics_cost_v2 l ON o.order_id = l.order_id
WHERE o.order_status = 'DELIVERED' AND (o.quantity * o.selling_price) > 0
	AND (l.shipping_cost + l.reverse_shipping_cost) > 0.2 * (o.quantity * o.selling_price);

-- Task 10
SELECT o.payment_method, SUM(o.quantity * o.selling_price) AS total_revenue, SUM(o.quantity * o.selling_price * pf.fee_percentage / 100) AS total_payment_fee,
    SUM(o.quantity * (o.selling_price - p.cost_price) - (o.quantity * o.selling_price * pf.fee_percentage / 100)) AS net_profit_after_fee
FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
JOIN payment_fees_v2 pf ON o.payment_method = pf.payment_method
WHERE o.order_status = 'DELIVERED'
GROUP BY o.payment_method
ORDER BY net_profit_after_fee DESC;

-- Task 11
SELECT o.order_id,
    -- Order Value
    (o.quantity * o.selling_price) AS order_value,
    -- Discount Loss
    IFNULL(d.discount_amount, 0) AS discount_loss,
    -- Return Loss
    CASE 
        WHEN r.return_flag = 'Y' THEN (o.quantity * o.selling_price)
        ELSE 0
    END AS return_loss,
    -- Logistics Loss
    IFNULL(l.shipping_cost, 0) + IFNULL(l.reverse_shipping_cost, 0) AS logistics_loss,
    -- Payment Fee Loss
    (o.quantity * o.selling_price * pf.fee_percentage / 100) AS payment_fee_loss
FROM orders_v2 o
LEFT JOIN discounts_v2 d ON o.order_id = d.order_id
LEFT JOIN returns_v2 r ON o.order_id = r.order_id
LEFT JOIN logistics_cost_v2 l ON o.order_id = l.order_id
LEFT JOIN payment_fees_v2 pf ON o.payment_method = pf.payment_method
WHERE o.order_status = 'DELIVERED';

-- --------------------------------------------------------------------------------------------------------

SELECT leakage_type, SUM(total_loss) AS total_loss
FROM (
    
    SELECT 'Discount' AS leakage_type, IFNULL(d.discount_amount, 0) AS total_loss
    FROM orders_v2 o
    LEFT JOIN discounts_v2 d ON o.order_id = d.order_id
    WHERE o.order_status = 'DELIVERED'
    
    UNION ALL
    
    SELECT 'Returns',
           CASE 
               WHEN r.return_flag = 'Y' THEN (o.quantity * o.selling_price)
               ELSE 0
           END
    FROM orders_v2 o
    LEFT JOIN returns_v2 r ON o.order_id = r.order_id
    WHERE o.order_status = 'DELIVERED'
    
    UNION ALL
    
    SELECT 'Logistics',
           IFNULL(l.shipping_cost, 0) + IFNULL(l.reverse_shipping_cost, 0)
    FROM orders_v2 o
    LEFT JOIN logistics_cost_v2 l ON o.order_id = l.order_id
    WHERE o.order_status = 'DELIVERED'
    
    UNION ALL
    
    SELECT 'Payment Fees',
           (o.quantity * o.selling_price * pf.fee_percentage / 100)
    FROM orders_v2 o
    LEFT JOIN payment_fees_v2 pf ON o.payment_method = pf.payment_method
    WHERE o.order_status = 'DELIVERED'

) t
GROUP BY leakage_type
ORDER BY total_loss DESC;

-- Task 12
SELECT p.product_id, SUM(o.quantity * (o.selling_price - p.cost_price) - IFNULL(d.discount_amount, 0)) AS net_profit,
    RANK() OVER (ORDER BY SUM(o.quantity * (o.selling_price - p.cost_price) - IFNULL(d.discount_amount, 0)) DESC) AS profit_rank
FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
LEFT JOIN discounts_v2 d ON o.order_id = d.order_id
WHERE o.order_status = 'DELIVERED'
GROUP BY p.product_id
ORDER BY profit_rank;

-- Task 13
SELECT p.category, AVG((o.selling_price - p.cost_price) / o.selling_price) AS avg_margin,
	STDDEV((o.selling_price - p.cost_price) / o.selling_price) AS margin_variation
FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
WHERE o.order_status = 'DELIVERED' AND o.selling_price > 0
GROUP BY p.category
ORDER BY margin_variation DESC;

-- Task 14
WITH customer_returns AS (
    SELECT o.customer_id, COUNT(o.order_id) AS total_orders, SUM(CASE WHEN r.return_flag = 'Y' THEN 1 ELSE 0 END) AS total_returns
    FROM orders_v2 o
    LEFT JOIN returns_v2 r ON o.order_id = r.order_id
    WHERE o.order_status = 'DELIVERED'
    GROUP BY o.customer_id
),
customer_return_rate AS (
    SELECT customer_id, total_orders, total_returns, total_returns * 1.0 / total_orders AS return_rate
    FROM customer_returns
),
avg_rate AS (
    SELECT AVG(total_returns * 1.0 / total_orders) AS avg_return_rate
    FROM customer_returns
)

SELECT c.customer_id, c.total_orders, c.total_returns, c.return_rate
FROM customer_return_rate c
CROSS JOIN avg_rate a
WHERE c.return_rate > a.avg_return_rate
ORDER BY c.return_rate DESC;

-- Task 15
SELECT 
    -- Total Sales
    SUM(o.quantity * o.selling_price) AS total_sales,
    -- Total Profit (basic)
    SUM(o.quantity * (o.selling_price - p.cost_price)) AS total_profit,
    -- Total Discounts
    SUM(IFNULL(d.discount_amount, 0)) AS total_discounts,
    -- Total Returns Loss
    SUM(
        CASE 
            WHEN r.return_flag = 'Y' THEN (o.quantity * o.selling_price)
            ELSE 0
        END
    ) AS total_returns_loss,
    -- Total Logistics Cost
    SUM(IFNULL(l.shipping_cost, 0) + IFNULL(l.reverse_shipping_cost, 0)) AS total_logistics_cost,
    -- Total Payment Fees
    SUM(o.quantity * o.selling_price * pf.fee_percentage / 100) AS total_payment_fees

FROM orders_v2 o
JOIN products_v2 p ON o.product_id = p.product_id
LEFT JOIN discounts_v2 d ON o.order_id = d.order_id
LEFT JOIN returns_v2 r ON o.order_id = r.order_id
LEFT JOIN logistics_cost_v2 l ON o.order_id = l.order_id
LEFT JOIN payment_fees_v2 pf ON o.payment_method = pf.payment_method
WHERE o.order_status = 'DELIVERED';