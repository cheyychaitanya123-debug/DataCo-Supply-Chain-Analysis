SELECT
    "Delivery Status",
    COUNT(DISTINCT "Order Id") AS Orders
FROM supply_chain
GROUP BY "Delivery Status"
ORDER BY Orders DESC;