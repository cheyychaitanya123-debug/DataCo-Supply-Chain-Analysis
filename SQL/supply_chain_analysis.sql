SELECT
    "Delivery Status",
    COUNT(DISTINCT "Order Id") AS Orders
FROM supply_chain
GROUP BY "Delivery Status"
ORDER BY Orders DESC;

SELECT * FROM supply_chain;

SELECT *
FROM supply_chain
LIMIT 10;

-- Q1. How many unique orders are there, and how are they distributed across each Delivery Status?
SELECT
    "Delivery Status",
    COUNT(DISTINCT "Order Id") AS Total_orders
FROM supply_chain
GROUP BY "Delivery Status"
ORDER BY Total_orders DESC;

-- Q2. Which Shipping Mode has the highest late-delivery rate?
SELECT
    "Shipping Mode",

    COUNT(DISTINCT "Order Id") AS Total_orders,

    COUNT(DISTINCT CASE
        WHEN "Delivery Status" = 'Late delivery'
        THEN "Order Id"
    END) AS Late_orders,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN "Delivery Status" = 'Late delivery'
            THEN "Order Id"
        END) * 100.0
        / COUNT(DISTINCT "Order Id"),
        2
    ) AS Late_rate_percentage

FROM supply_chain

GROUP BY "Shipping Mode"

ORDER BY Late_rate_percentage DESC;

-- Q3. For each Shipping Mode, how many days are scheduled for delivery, and how many days are actually taken?
SELECT
    "Shipping Mode",

    ROUND(
        AVG("Days for shipment (scheduled)"), 2
    ) AS Avg_Scheduled_Days,

    ROUND(
        AVG("Days for shipping (real)"), 2
    ) AS Avg_Actual_Days

FROM supply_chain

GROUP BY "Shipping Mode"

ORDER BY Avg_Actual_Days DESC;

-- Q4.Which Market has the highest late-delivery rate, and is the difference between markets significant?
SELECT
     "Market",
    COUNT(DISTINCT "Order Id") AS Total_Orders,

    COUNT(DISTINCT CASE 
      WHEN "Delivery Status" = 'Late delivery'
      THEN "Order Id"
      END) AS Late_Deliveries,

    ROUND(
        COUNT(DISTINCT CASE
        WHEN "Delivery Status" = 'Late delivery'
        THEN "Order Id"
        END) * 100 /
        COUNT(DISTINCT "Order Id"), 2) AS
        Late_Delivery_Percentage
    FROM supply_chain
    GROUP BY "Market"
    ORDER By "Late_Delivery_Percentage" DESC;

    -- Q5. Which product categories generate the highest total profit?
    SELECT
        "Category Name",
        SUM("Order Profit per Order") AS Total_Profit
    FROM supply_chain
    GROUP BY "Category Name"
    ORDER BY Total_Profit DESC;

    -- Q6. Which product categories generate substantial sales but have relatively lower profit margins?
    SELECT
        "Category Name",
        SUM("Sales") AS Total_Sales,
        SUM("Order Profit per Order") AS Total_Profit,
         ROUND(
        SUM("Order Profit Per Order") * 100.0
        / SUM("Sales"),
        2
    ) AS Profit_Margin
    FROM supply_chain
    GROUP BY "Category Name"
    ORDER BY Profit_Margin DESC;

    -- Q7. Which individual products contribute the most total profit?
 SELECT
    "Product Name",
     SUM("Order Profit per Order") AS Total_Profit
FROM supply_chain
GROUP BY "Product Name"
ORDER BY Total_Profit DESC;

-- Q8. What percentage of total sales comes from the top 10% of customers?
   WITH customer_sales AS (
    SELECT
        "Customer Id",
        SUM("Sales") AS Total_Sales
    FROM supply_chain
    GROUP BY "Customer Id"
),

ranked_customers AS (
    SELECT
        "Customer Id",
        Total_Sales,
        ROW_NUMBER() OVER (
            ORDER BY Total_Sales DESC
        ) AS Customer_Rank,
        COUNT(*) OVER () AS Total_Customers
    FROM customer_sales
),

top_10_customers AS (
    SELECT
        Total_Sales
    FROM ranked_customers
    WHERE Customer_Rank <= CEIL(Total_Customers * 0.10)
)

SELECT
    ROUND(
        SUM(Total_Sales) * 100.0 /
        (SELECT SUM(Total_Sales) FROM customer_sales),
        2
    ) AS Top_10_Percent_Customer_Sales_Share
FROM top_10_customers;

--Q9. Does order size affect the average sales and profit of an order?
WITH order_level AS (
    SELECT
        "Order Id",
        COUNT(DISTINCT "Order Item Id") AS Order_Size,
        SUM("Sales") AS Total_Sales,
        SUM("Order Profit Per Order") AS Total_Profit
    FROM supply_chain
    GROUP BY "Order Id"
)

SELECT
    Order_Size,
    COUNT(*) AS Total_Orders,
    ROUND(AVG(Total_Sales), 2) AS Avg_Sales,
    ROUND(AVG(Total_Profit), 2) AS Avg_Profit
FROM order_level
GROUP BY Order_Size
ORDER BY Order_Size;

-- Q10. Which customer segments generate the most sales and profit?
SELECT
     "Customer Segment",
      COUNT(DISTINCT "Order Id") AS Total_Orders,
     SUM("Sales") AS Total_sales,
     SUM("Order Profit per Order") AS Total_profit
FROM supply_chain
GROUP BY "Customer Segment"
ORDER BY Total_profit DESC;

-- Q11. Which regions generate the most sales and profit?
SELECT
     "Order Region",
     COUNT(DISTINCT "Order Id") AS Total_Orders,
     SUM("Sales") AS Total_Sales,
     SUM("Order Profit Per Order") AS Total_Profit
FROM supply_chain
GROUP BY "Order Region"
ORDER BY Total_Profit DESC;

-- Q12. Which products have high sales but unusually low profit margins?
SELECT
    "Product Name",
    SUM("Sales") AS Total_Sales,
    SUM("Order Profit Per Order") AS Total_Profit,
    ROUND(
        SUM("Order Profit Per Order") * 100.0
        / SUM("Sales"),
        2
    ) AS Profit_Percentage
FROM supply_chain
GROUP BY "Product Name"
ORDER BY Profit_Percentage ASC;

-- Q13. Which departments generate the most sales and profit?
SELECT
    "Department Name",
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    SUM("Sales") AS Total_Sales,
    SUM("Order Profit Per Order") AS Total_Profit
FROM supply_chain
GROUP BY "Department Name"
ORDER BY Total_Profit ASC ;   
    
-- Q14. How do sales, orders, and profit change over time?
SELECT "order date (DateOrders)"
FROM supply_chain
LIMIT 5;

SELECT
    "order date (DateOrders)",
    substr("order date (DateOrders)", 1, instr("order date (DateOrders)", '/') - 1) AS Month,
    substr(
        "order date (DateOrders)",
        instr("order date (DateOrders)", '/') + 1,
        instr(
            substr("order date (DateOrders)", instr("order date (DateOrders)", '/') + 1),
            '/'
        ) - 1
    ) AS Day
FROM supply_chain
LIMIT 5;

SELECT
    "order date (DateOrders)",
    substr(
        "order date (DateOrders)",
        instr(
            "order date (DateOrders)",
            '/'
        ) + 4,
        4
    ) AS Order_Year
FROM supply_chain
LIMIT 5;

-- Q14. How did sales, orders, and profit change month by month?
SELECT
    "order date (DateOrders)" AS Original_Date,

    substr("order date (DateOrders)", 
           instr("order date (DateOrders)", '/') + 4, 4)
    || '-' ||
    printf('%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    )
    || '-' ||
    printf('%02d',
        substr(
            "order date (DateOrders)",
            instr("order date (DateOrders)", '/') + 1,
            instr(
                substr(
                    "order date (DateOrders)",
                    instr("order date (DateOrders)", '/') + 1
                ),
                '/'
            ) - 1
        )
    )
    || substr("order date (DateOrders)", 
              instr("order date (DateOrders)", ' ') + 1)
    AS Clean_Date

FROM supply_chain
LIMIT 5;

SELECT
    "order date (DateOrders)",
    Clean_Date
FROM supply_chain
LIMIT 5;

UPDATE supply_chain
SET Clean_Date =
    substr(
        "order date (DateOrders)",
        instr("order date (DateOrders)", '/') + 4,
        4
    )
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    )
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            instr("order date (DateOrders)", '/') + 1,
            instr(
                substr(
                    "order date (DateOrders)",
                    instr("order date (DateOrders)", '/') + 1
                ),
                '/'
            ) - 1
        )
    )
    || substr(
        "order date (DateOrders)",
        instr("order date (DateOrders)", ' ') + 1
    );

    SELECT
    Clean_Date,
    strftime('%Y-%m', Clean_Date) AS Order_Month
FROM supply_chain
LIMIT 10;

-- Q14. How did sales, orders, and profit change month by month?
SELECT
    strftime('%Y-%m', Clean_Date) AS Order_Month,
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    ROUND(SUM("Sales"), 2) AS Total_Sales,
    ROUND(SUM("Order Profit Per Order"), 2) AS Total_Profit
FROM supply_chain
GROUP BY Order_Month
ORDER BY Order_Month;

SELECT
    Clean_Date
FROM supply_chain
LIMIT 20;

UPDATE supply_chain
SET Clean_Date =
    substr(
        "order date (DateOrders)",
        instr("order date (DateOrders)", '/') + 4,
        4
    )
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    )
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            instr("order date (DateOrders)", '/') + 1,
            instr(
                substr(
                    "order date (DateOrders)",
                    instr("order date (DateOrders)", '/') + 1
                ),
                '/'
            ) - 1
        )
    )
    || ' ' ||
    substr(
        "order date (DateOrders)",
        instr("order date (DateOrders)", ' ') + 1
    );

    SELECT
    "order date (DateOrders)",
    Clean_Date,
    strftime('%Y-%m', Clean_Date) AS Order_Month
FROM supply_chain
LIMIT 20;

SELECT
    "order date (DateOrders)",
    substr(Clean_Date, 1, 7) AS Order_Month
FROM supply_chain
LIMIT 20;

-- Q15. How do the company's total sales change from month to month?
SELECT
    strftime('%Y-%m', Clean_Date ) AS Order_month,
    SUM("Sales") AS Monthly_Sales
FROM supply_chain
GROUP BY Order_month
ORDER BY Monthly_Sales DESC;

-- Q16. Which month had the highest number of orders?
SELECT
    strftime('%Y-%m', Clean_Date) AS Month_of_Year,
    COUNT(DISTINCT "Order Id") AS Total_orders_Monthly
FROM supply_chain
GROUP BY Month_of_Year
ORDER BY Total_orders_Monthly DESC;

SELECT
    substr(Clean_Date, 1, 7) AS Order_Month,
    COUNT(DISTINCT "Order Id") AS Total_Orders
FROM supply_chain
GROUP BY Order_Month
ORDER BY Total_Orders DESC;

SELECT
    "order date (DateOrders)",
    Clean_Date
FROM supply_chain
WHERE Clean_Date LIKE '018%'
LIMIT 10;

SELECT
    "order date (DateOrders)"
FROM supply_chain
LIMIT 5;

SELECT
    substr("order date (DateOrders)", -16, 4) AS Year,
    substr("order date (DateOrders)", 1, 1) AS Month
FROM supply_chain
LIMIT 5;

SELECT
    "order date (DateOrders)",
    substr(
        "order date (DateOrders)",
        instr("order date (DateOrders)", ' ') - 4,
        4
    ) AS Year
FROM supply_chain
LIMIT 5;

SELECT
    "order date (DateOrders)",
    substr(
        "order date (DateOrders)",
        1,
        instr("order date (DateOrders)", '/') - 1
    ) AS Month
FROM supply_chain
LIMIT 5;

SELECT
    substr("order date (DateOrders)", instr("order date (DateOrders)", ' ') - 4, 4)
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    ) AS Order_Month,
    COUNT(DISTINCT "Order Id") AS Total_Orders
FROM supply_chain
GROUP BY Order_Month
ORDER BY Order_Month;

-- Q.Which month had the highest number of orders?
SELECT
    substr("order date (DateOrders)", instr("order date (DateOrders)", ' ') - 4, 4)
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    ) AS Order_Month,
    COUNT(DISTINCT "Order Id") AS Total_Orders
FROM supply_chain
GROUP BY Order_Month
ORDER BY Total_Orders DESC;

--Q17.“Did sales also increase during the months with the highest order volume?”
SELECT
    substr("order date (DateOrders)", instr("order date (DateOrders)", ' ') - 4, 4)
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    ) AS Order_Month,
    COUNT(DISTINCT "Order Id") AS Total_Orders,
    SUM("Sales") AS Total_Sales
FROM supply_chain
GROUP BY Order_Month
ORDER BY Total_Orders DESC;

-- Q18. Why do some months have similar numbers of orders but very different total sales?
SELECT
    substr("order date (DateOrders)", instr("order date (DateOrders)", ' ') - 4, 4)
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    ) AS Order_Month,

    COUNT(DISTINCT "Order Id") AS Total_Orders,

    SUM("Sales") AS Total_Sales,

    ROUND(
        SUM("Sales") / COUNT(DISTINCT "Order Id"),
        2
    ) AS Avg_Sales_Per_Order

FROM supply_chain

GROUP BY Order_Month

ORDER BY Avg_Sales_Per_Order DESC;

-- Q19. Why did these four months have much lower sales per order than the other months?
SELECT
    substr("order date (DateOrders)", instr("order date (DateOrders)", ' ') - 4, 4)
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    ) AS Order_Month,

    COUNT(DISTINCT "Order Id") AS Total_Orders,

    ROUND(SUM("Sales"), 2) AS Total_Sales,

    ROUND(
        SUM("Sales") / COUNT(DISTINCT "Order Id"),
        2
    ) AS Avg_Sales_Per_Order

FROM supply_chain

GROUP BY Order_Month

HAVING Avg_Sales_Per_Order < 550

ORDER BY Order_Month;


-- Q. Did the type of products/orders change during these months?
SELECT
    substr("order date (DateOrders)", instr("order date (DateOrders)", ' ') - 4, 4)
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    ) AS Order_Month,

    COUNT(DISTINCT "Order Id") AS Total_Orders,

    ROUND(
        COUNT(DISTINCT "Order Item Id") * 1.0
        / COUNT(DISTINCT "Order Id"),
        2
    ) AS Avg_Items_Per_Order,

    ROUND(
        SUM("Sales") / COUNT(DISTINCT "Order Id"),
        2
    ) AS Avg_Sales_Per_Order

FROM supply_chain

GROUP BY Order_Month

ORDER BY Order_Month;

-- Q20. What changed in the data around October 2017?
SELECT
    substr("order date (DateOrders)", instr("order date (DateOrders)", ' ') - 4, 4)
    || '-' ||
    printf(
        '%02d',
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
    ) AS Order_Month,

    ROUND(
        SUM("Sales") / COUNT(DISTINCT "Order Item Id"),
        2
    ) AS Avg_Sales_Per_Item

FROM supply_chain

GROUP BY Order_Month

ORDER BY Order_Month;

-- Q20. Did the product mix change dramatically from October 2017 onward?
SELECT
    "Category Name",
    COUNT(DISTINCT "Order Item Id") AS Total_Items
FROM supply_chain
WHERE
    CAST(
        substr("order date (DateOrders)", instr("order date (DateOrders)", ' ') - 4, 4)
        AS INTEGER
    ) * 100
    +
    CAST(
        substr(
            "order date (DateOrders)",
            1,
            instr("order date (DateOrders)", '/') - 1
        )
        AS INTEGER
    ) >= 201710
GROUP BY "Category Name"
ORDER BY Total_Items DESC;

-- Q21. Did the category mix change after October 2017 compared with before October 2017?
WITH period_data AS (
    SELECT
        "Category Name",
        CASE
            WHEN CAST(
                substr(
                    "order date (DateOrders)",
                    instr("order date (DateOrders)", ' ') - 4,
                    4
                ) AS INTEGER
            ) * 100
            +
            CAST(
                substr(
                    "order date (DateOrders)",
                    1,
                    instr("order date (DateOrders)", '/') - 1
                ) AS INTEGER
            ) < 201710
            THEN 'Before'
            ELSE 'After'
        END AS Period
    FROM supply_chain
),

category_share AS (
    SELECT
        Period,
        "Category Name",
        COUNT(*) AS Items,
        COUNT(*) * 100.0
            / SUM(COUNT(*)) OVER (PARTITION BY Period) AS Share
    FROM period_data
    GROUP BY Period, "Category Name"
)

SELECT
    "Category Name",
    ROUND(MAX(CASE WHEN Period = 'Before' THEN Share END), 2) AS Before_Share,
    ROUND(MAX(CASE WHEN Period = 'After' THEN Share END), 2) AS After_Share
FROM category_share
GROUP BY "Category Name"
ORDER BY ABS(After_Share - Before_Share) DESC;

-- Q22. Did the actual product prices/sales values change because of this new product mix?
WITH period_data AS (
    SELECT
        CASE
            WHEN CAST(
                substr(
                    "order date (DateOrders)",
                    instr("order date (DateOrders)", ' ') - 4,
                    4
                ) AS INTEGER
            ) * 100
            +
            CAST(
                substr(
                    "order date (DateOrders)",
                    1,
                    instr("order date (DateOrders)", '/') - 1
                ) AS INTEGER
            ) < 201710
            THEN 'Before'
            ELSE 'After'
        END AS Period,

        "Sales"
    FROM supply_chain
)

SELECT
    Period,
    COUNT(*) AS Total_Items,
    ROUND(AVG("Sales"), 2) AS Avg_Sales_Per_Item,
    ROUND(SUM("Sales"), 2) AS Total_Sales
FROM period_data
GROUP BY Period
ORDER BY Period;

-- Q22. Did the dataset's product and order structure actually change in October 2017, or is there a data-quality/data-collection change causing the sudden shift?”
SELECT
    CASE
        WHEN CAST(
            substr(
                "order date (DateOrders)",
                instr("order date (DateOrders)", ' ') - 4,
                4
            ) AS INTEGER
        ) * 100
        +
        CAST(
            substr(
                "order date (DateOrders)",
                1,
                instr("order date (DateOrders)", '/') - 1
            ) AS INTEGER
        ) < 201710
        THEN 'Before'
        ELSE 'After'
    END AS Period,

    COUNT(DISTINCT "Order Id") AS Total_Orders,

    COUNT(DISTINCT "Order Item Id") AS Total_Items

FROM supply_chain

GROUP BY Period;