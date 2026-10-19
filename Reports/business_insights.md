# DataCo Supply Chain Analytics — Business Insights

## 1. Business Problem

Late deliveries can reduce customer satisfaction, increase operational costs, and affect supply chain reliability. This project analyzes order and shipping data to understand delivery performance and identify opportunities to improve logistics operations.

## 2. Project Objective

- Measure late, early, and on-time delivery performance.
- Compare delivery outcomes across shipping modes, markets, and customer segments.
- Identify operational areas that require further investigation.
- Recommend actions to improve delivery reliability.

## 3. Key Findings

- **Dataset size:** 180,519 order-item records.
- **Unique orders:** 65,752.
- **Late delivery rate:** Approximately 57.82% of unique orders.
- **Cancelled order rate:** Approximately 4.34% of unique orders.
- **Market comparison:** Pacific Asia had the highest observed late-delivery rate among the markets analyzed, at approximately 55.30%.
- **Customer segment comparison:** Home Office had a late-delivery rate of approximately 55.23%, slightly higher than the other customer segments.

*Note: These rates use unique orders where specified. The underlying dataset also contains order-item records, so row-level percentages may differ.*

## 4. Business Recommendations

1. **Investigate late deliveries:** Review dispatch timing, warehouse processing, carrier handovers, and actual transit times to determine the main causes of delays.
2. **Monitor shipping modes:** Compare promised delivery times with actual performance for each shipping mode before changing service policies.
3. **Review market-level performance:** Investigate why Pacific Asia has the highest observed late-delivery rate and compare its logistics processes with other markets.
4. **Reduce cancellations:** Analyze cancellation reasons and identify whether inventory availability, fulfillment delays, or other factors contribute.
5. **Build an ongoing monitoring process:** Track late-delivery rate, on-time delivery rate, actual shipping days, and cancellation rate in a regular dashboard.

## 5. KPIs to Monitor

- Late delivery rate
- On-time delivery rate
- Average actual shipping days
- Order cancellation rate
- Delivery performance by shipping mode and market

## 6. Conclusion

The analysis identifies late delivery as a major supply chain performance issue. The findings provide a starting point for investigating delivery processes, monitoring operational KPIs, and prioritizing improvements.

The recommendations should be validated against more detailed operational data before implementation.
