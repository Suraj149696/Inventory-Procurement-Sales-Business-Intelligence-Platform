
USE retail_inventory_analysis;



/* Total Sales Revenue */


SELECT
    ROUND(SUM(SalesDollars), 2) AS TotalSalesRevenue
FROM sales;

/*Total Units Sold*/

SELECT
    SUM(SalesQuantity) AS TotalUnitsSold
FROM sales;



/* Average Selling Price */

SELECT
    ROUND(AVG(SalesPrice), 2) AS AverageSellingPrice
FROM sales;

SHOW INDEX FROM end_inventory;


/*Top Products by Revenue

Find highest revenue-generating products.*/



SET SESSION net_write_timeout = 600;
SET SESSION net_read_timeout = 600;
SET SESSION interactive_timeout = 600;
SET SESSION net_write_timeout = 600;

ALTER TABLE sales
ADD INDEX idx_desc_sales (Description);
SHOW INDEX FROM sales;

CREATE TABLE product_revenue_summary AS
SELECT
    Description,
    ROUND(SUM(SalesDollars), 2) AS Revenue
FROM sales
GROUP BY Description;



SELECT *
FROM product_revenue_summary
ORDER BY Revenue DESC
LIMIT 10;

/*Top Products by Quantity Sold*/

CREATE TABLE product_quantity_summary_1 AS
SELECT
    Description,
    SUM(SalesQuantity) AS UnitsSold
FROM sales
GROUP BY Description;



SELECT *
FROM product_quantity_summary_1
ORDER BY UnitsSold DESC
LIMIT 10;


/*Store-wise Sales Analysis*/

CREATE TABLE store_sales_summary AS
SELECT
    Store,
    ROUND(SUM(SalesDollars), 2) AS Revenue,
    SUM(SalesQuantity) AS UnitsSold
FROM sales
GROUP BY Store;

SELECT *
FROM store_sales_summary
ORDER BY Revenue DESC;


/* Brand-wise Sales Analysis*/

CREATE TABLE brand_revenue_summary AS
SELECT
    Brand,
    ROUND(SUM(SalesDollars), 2) AS Revenue
FROM sales
GROUP BY Brand;


SELECT *
FROM brand_revenue_summary
ORDER BY Revenue DESC
LIMIT 10;


/* Vendor-wise Sales Contribution */

CREATE TABLE vendor_revenue_summary AS
SELECT
    VendorName,
    ROUND(SUM(SalesDollars), 2) AS Revenue
FROM sales
GROUP BY VendorName;

SELECT *
FROM vendor_revenue_summary
ORDER BY Revenue DESC
LIMIT 10;


/*Daily Sales Trend

Analyze daily sales fluctuations.*/

CREATE TABLE daily_sales_summary AS
SELECT
    SalesDate,
    ROUND(SUM(SalesDollars), 2) AS DailyRevenue
FROM sales
GROUP BY SalesDate;


SELECT *
FROM daily_sales_summary
ORDER BY SalesDate;


/*Monthly Sales Trend
Goal

Find seasonal trends.*/

CREATE TABLE monthly_sales_summary AS
SELECT
    DATE_FORMAT(SalesDate, '%Y-%m') AS YearMonth,
    ROUND(SUM(SalesDollars), 2) AS MonthlyRevenue
FROM sales
GROUP BY DATE_FORMAT(SalesDate, '%Y-%m');

SELECT *
FROM monthly_sales_summary
ORDER BY YearMonth;

/*Store & Product Combined Analysis
Goal

Find top-selling products store-wise.*/
CREATE TABLE store_product_revenue AS
SELECT
    Store,
    Description,
    ROUND(SUM(SalesDollars), 2) AS Revenue
FROM sales
GROUP BY Store, Description;

SELECT *
FROM store_product_revenue
ORDER BY Revenue DESC;



/*Revenue Ranking Using Window Function
Goal

Demonstrate advanced SQL.*/

CREATE TABLE product_revenue_summary AS
SELECT
    Description,
    ROUND(SUM(SalesDollars), 2) AS Revenue
FROM sales
GROUP BY Description;

SELECT
    Description,
    Revenue,
    RANK() OVER (ORDER BY Revenue DESC) AS RevenueRank
FROM product_revenue_summary;







/* =========================================================
   1. OVERALL BUSINESS PERFORMANCE
   ========================================================= */

-- Total Sales Revenue
-- 452062952.02

-- Total Units Sold
-- 32917876

-- Average Selling Price
-- 15.69


/* =========================================================
   2. TOP PRODUCTS BY REVENUE
   ========================================================= */

-- Insight:
-- High revenue is concentrated in premium liquor brands.

-- Top performers:
-- Jack Daniels No 7 Black → 7964746.76
-- Tito's Handmade Vodka   → 7399657.58
-- Grey Goose Vodka        → 7209608.06
-- Capt Morgan Spiced Rum  → 6356320.62
-- Absolut 80 Proof        → 6244752.03


/* =========================================================
   3. TOP PRODUCTS BY QUANTITY SOLD
   ========================================================= */

-- Insight:
-- Mass-market brands dominate volume sales.

-- Highest volume products:
-- Smirnoff 80 Proof
-- Capt Morgan Spiced Rum
-- Tito's Handmade Vodka
-- Absolut 80 Proof
-- Jack Daniels No 7 Black


/* =========================================================
   4. STORE-WISE PERFORMANCE
   ========================================================= */

-- Insight:
-- Store 76 is the highest revenue-generating store.

-- Key observation:
-- Top 10 stores contribute disproportionately to total revenue,
-- indicating strong regional concentration.


/* =========================================================
   5. BRAND-WISE PERFORMANCE
   ========================================================= */

-- Insight:
-- Brand 1233 leads revenue generation.

-- Top brands:
-- 1233 → 5101919.51
-- 3405 → 4819073.49
-- 8068 → 4538120.60


/* =========================================================
   6. VENDOR-WISE CONTRIBUTION
   ========================================================= */

-- Insight:
-- DIAGEO NORTH AMERICA INC is the largest vendor contributor.

-- Top vendors:
-- DIAGEO NORTH AMERICA INC → 68742416.99
-- MARTIGNETTI COMPANIES    → 40992395.93
-- PERNOD RICARD USA        → 32281247.95


/* =========================================================
   7. DAILY SALES TREND
   ========================================================= */

-- Insight:
-- Sales fluctuate significantly day-to-day,
-- showing demand volatility and seasonal effects.


/* =========================================================
   8. MONTHLY SALES TREND
   ========================================================= */

-- Insight:
-- Strong seasonal growth observed in mid-to-late year.

-- Peak month:
-- December → 52312248.02

-- Lowest month:
-- January → 29854027.92


/* =========================================================
   9. STORE & PRODUCT ANALYSIS
   ========================================================= */

-- Insight:
-- Different stores show preference for specific high-revenue products.

-- Example:
-- Store 76 → Tito's Handmade Vodka
-- Store 50 → Jack Daniels No 7 Black
-- Store 34 → Grey Goose Vodka


/* =========================================================
   10. REVENUE RANKING (WINDOW FUNCTION)
   ========================================================= */

-- Insight:
-- Clear revenue hierarchy among products.

-- Top ranked products:
-- Jack Daniels No 7 Black → Rank 1
-- Tito's Handmade Vodka   → Rank 2
-- Grey Goose Vodka        → Rank 3


/* =========================================================
   FINAL BUSINESS INSIGHTS
   ========================================================= */

-- 1. Revenue is highly concentrated in top liquor brands.
-- 2. A small number of stores contribute majority of sales.
-- 3. Demand shows strong seasonal variation (peak in Q4).
-- 4. Premium products generate higher revenue but lower volume.
-- 5. Vendor dependency is high (DIAGEO dominates supply chain).
-- 6. Inventory optimization can improve based on store-level demand patterns.
-- 7. Business follows Pareto principle (80/20 rule).

