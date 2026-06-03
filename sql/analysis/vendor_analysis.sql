USE retail_inventory_analysis;


/*Total Procurement Spend */
SELECT
    ROUND(SUM(Dollars), 2) AS TotalProcurementSpend
FROM purchases;

/*Total Purchase Quantity*/

SELECT
    SUM(Quantity) AS TotalPurchaseQuantity
FROM purchases;

/* Total Vendors*/

SELECT
    COUNT(DISTINCT VendorNumber) AS TotalVendors
FROM purchases;



/* Top Vendors by Procurement Spend


Find vendors receiving highest spending.*/

CREATE TABLE vendor_procurement_summary AS
SELECT
    VendorName,
    ROUND(SUM(Dollars), 2) AS ProcurementSpend,
    SUM(Quantity) AS TotalQuantity
FROM purchases
GROUP BY VendorName;



SELECT *
FROM vendor_procurement_summary
ORDER BY ProcurementSpend DESC
LIMIT 10;

/*Vendor Contribution Percentage*/

CREATE TABLE vendor_contribution_summary AS
SELECT
    VendorName,

    ROUND(SUM(Dollars), 2) AS ProcurementSpend,

    ROUND(
        SUM(Dollars) /
        (
            SELECT SUM(Dollars)
            FROM purchases
        ) * 100,
        2
    ) AS ContributionPercent

FROM purchases

GROUP BY VendorName;


SELECT *
FROM vendor_contribution_summary
ORDER BY ProcurementSpend DESC
LIMIT 10;


/*Freight Cost Analysis
Goal

Analyze logistics expenses.*/

SELECT
    VendorName,

    ROUND(SUM(Freight), 2) AS TotalFreightCost,

    ROUND(AVG(Freight), 2) AS AvgFreightCost

FROM vendor_invoice

GROUP BY VendorName

ORDER BY TotalFreightCost DESC
LIMIT 10;


/*Freight Efficiency Analysis
Goal

Freight cost relative to purchase value.*/

SELECT
    VendorName,

    ROUND(SUM(Dollars), 2) AS PurchaseCost,

    ROUND(SUM(Freight), 2) AS FreightCost,

    ROUND(
        SUM(Freight) /
        SUM(Dollars) * 100,
        2
    ) AS FreightPercent

FROM vendor_invoice

GROUP BY VendorName

ORDER BY FreightPercent DESC;



/*Payment Delay Analysis
Goal

Analyze vendor payment cycle.*/


SELECT
    VendorName,

    ROUND(
        AVG(
            DATEDIFF(
                PayDate,
                InvoiceDate
            )
        ),
        2
    ) AS AvgPaymentDays

FROM vendor_invoice

GROUP BY VendorName

ORDER BY AvgPaymentDays DESC;


/*Vendors with Longest Payment Cycle*/

SELECT
    VendorName,

    MAX(
        DATEDIFF(
            PayDate,
            InvoiceDate
        )
    ) AS MaxPaymentDays

FROM vendor_invoice

GROUP BY VendorName

ORDER BY MaxPaymentDays DESC
LIMIT 10;



/*Bulk Purchase Analysis
Goal

Check if larger purchases reduce unit price.*/

SELECT
    Quantity,

    ROUND(
        AVG(PurchasePrice),
        2
    ) AS AvgPurchasePrice

FROM purchases

GROUP BY Quantity

ORDER BY Quantity;


/*Vendor Profitability Analysis
Goal

Compare:

procurement cost
sales revenue*/

CREATE TABLE sales_vendor_summary AS
SELECT
    VendorName,
    ROUND(SUM(SalesDollars), 2) AS SalesRevenue
FROM sales
GROUP BY VendorName;

CREATE TABLE purchase_vendor_summary AS
SELECT
    VendorName,
    ROUND(SUM(Dollars), 2) AS PurchaseCost
FROM purchases
GROUP BY VendorName;



SELECT
    s.VendorName,
    s.SalesRevenue,
    p.PurchaseCost,

    ROUND(
        s.SalesRevenue - p.PurchaseCost,
        2
    ) AS GrossProfit

FROM sales_vendor_summary s

JOIN purchase_vendor_summary p
ON s.VendorName = p.VendorName

ORDER BY GrossProfit DESC;


/*Vendor Dependency Risk
Goal

Find over-dependent vendors.*/

CREATE TABLE vendor_spend_contribution_summary AS
SELECT
    VendorName,

    ROUND(SUM(Dollars), 2) AS Spend,

    ROUND(
        SUM(Dollars) /
        (
            SELECT SUM(Dollars)
            FROM purchases
        ) * 100,
        2
    ) AS SpendContributionPercent

FROM purchases

GROUP BY VendorName;


SELECT *
FROM vendor_spend_contribution_summary
WHERE SpendContributionPercent > 5
ORDER BY SpendContributionPercent DESC;


/*Vendor Purchase Frequency
Goal

Find most active vendors.*/

SELECT
    VendorName,

    COUNT(DISTINCT PONumber) AS TotalOrders

FROM purchases

GROUP BY VendorName

ORDER BY TotalOrders DESC
LIMIT 10;




# Vendor Analysis — Summary Report

/*
Overall Procurement Overview
--------------------------------
- Total Procurement Spend: $321.90M
- Total Purchase Quantity: 33.58M units
- Total Vendors: 126

The business relies heavily on a few major vendors for inventory procurement and supply continuity.
*/


/*
Top Vendors by Procurement Spend
--------------------------------
DIAGEO NORTH AMERICA INC is the largest supplier with procurement spend exceeding $50M,
followed by MARTIGNETTI COMPANIES and JIM BEAM BRANDS COMPANY.

These vendors contribute a significant share of total procurement quantity and inventory availability.
*/


/*
Vendor Contribution Analysis
--------------------------------
Top vendors contribute a major portion of procurement spend:

- DIAGEO NORTH AMERICA INC → 15.83%
- MARTIGNETTI COMPANIES → 8.64%
- JIM BEAM BRANDS COMPANY → 7.52%
- PERNOD RICARD USA → 7.49%
- BACARDI USA INC → 5.48%

This indicates moderate-to-high supplier dependency risk.
*/


/*
Freight Cost Analysis
--------------------------------
Freight expenses are highest for vendors with large procurement volume.

DIAGEO NORTH AMERICA INC recorded the highest freight cost,
followed by MARTIGNETTI COMPANIES and JIM BEAM BRANDS COMPANY.

Freight percentage remains relatively stable (~0.5%)
across most vendors, indicating consistent logistics efficiency.
*/


/*
Payment Cycle Analysis
--------------------------------
Average vendor payment cycle is approximately 35–48 days.

Some vendors such as:
- CAMPARI AMERICA
- LAIRD & CO
- PERFECTA WINES
- PROXIMO SPIRITS INC.

show the longest payment cycles (48 days).

Longer payment cycles may improve short-term cash flow
but require strong vendor relationship management.
*/


/*
Bulk Purchase Analysis
--------------------------------
Bulk purchasing appears to reduce average unit cost
for several products and vendors.

Higher purchase quantities generally correlate with
lower procurement price per unit,
indicating economies of scale benefits.
*/


/*
Vendor Profitability Analysis
--------------------------------
Most profitable vendors include:

- DIAGEO NORTH AMERICA INC
- MARTIGNETTI COMPANIES
- CONSTELLATION BRANDS INC
- PERNOD RICARD USA
- JIM BEAM BRANDS COMPANY

These vendors generate the highest gross profit contribution
through strong sales revenue and efficient procurement cost.
*/


/*
Vendor Dependency Risk
--------------------------------
The business shows strong dependency on a few major suppliers.

Top 5 vendors contribute a substantial share of total procurement spend,
which may create operational and supply-chain risk
if vendor disruptions occur.
*/


/*
Vendor Purchase Frequency
--------------------------------
Several vendors receive highly frequent purchase orders,
including:

- CONSTELLATION BRANDS INC
- BACARDI USA INC
- BROWN-FORMAN CORP
- BANFI PRODUCTS CORP

This indicates strong operational engagement
and continuous inventory replenishment activity.
*/


/*
Strategic Recommendations
--------------------------------
- Strengthen partnerships with top-performing vendors.
- Negotiate bulk procurement discounts and freight agreements.
- Diversify supplier base to reduce dependency risk.
- Monitor vendor profitability and procurement efficiency regularly.
- Optimize payment cycles for improved cash flow management.
- Focus procurement planning on high-demand/high-profit vendors.
*/