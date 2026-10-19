# DataCo Supply Chain Analytics — Data Quality Report

## 1. Dataset Overview

- **Dataset:** DataCo Supply Chain Dataset
- **Records analyzed:** 180,519 order-item records
- **Unique orders:** 65,752
- **Purpose:** Assess data completeness, validate shipping dates, and identify inconsistencies that could affect delivery-performance analysis.

## 2. Missing Value Checks

The following fields were checked for missing values:

| Column | Missing values found |
|---|---:|
| Customer Lname | 8 |
| Customer Zipcode | 3 |

Other fields included in the initial checks had no missing values reported.

These missing values are limited in number. They should still be handled appropriately if the affected columns are used in an analysis.

## 3. Shipping Date Validation

The order date and shipping date fields were reviewed to validate shipping-duration calculations.

A calculated shipping-days field was created using the difference between the shipping date and the order date.

During validation, a negative shipping duration of -3 days was corrected to 3 days in the affected calculation.

## 4. Comparison of Shipping Duration

The calculated shipping duration was compared with the dataset's recorded `Days for shipping (real)` field.

- **Records that differed:** 4,657
- **Total records:** 180,519

These differences should be investigated before assuming that the calculated duration and recorded shipping duration are interchangeable. Differences may arise from calculation definitions, date handling, or inconsistencies in the source data.

## 5. Data Quality Considerations

- Order-item records and unique orders represent different levels of analysis.
- Delivery percentages can differ depending on whether they are calculated using rows or distinct order IDs.
- Delivery-status categories should be checked for consistent spelling and capitalization.
- Date calculations should be validated before using shipping duration in KPIs.
- Missing values should be documented and handled according to the needs of each analysis.

## 6. Recommended Next Steps

1. Investigate the 4,657 records with differing shipping-duration values.
2. Confirm the intended business definition of actual shipping days.
3. Validate delivery-status and order-level measures against the source data.
4. Document any transformations applied during data preparation.
5. Recheck the final dashboard KPIs against the validated dataset.

## 7. Conclusion

Initial checks identified a small number of missing values and differences between calculated and recorded shipping durations. Documenting these issues helps improve transparency and makes the resulting supply chain analysis more reliable.

*This report summarizes the checks completed so far. It should be updated if further validation or cleaning is performed.*
