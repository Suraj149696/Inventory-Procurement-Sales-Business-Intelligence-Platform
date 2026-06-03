USE retail_inventory_analysis;

/*Product Revenue Summary*/

CREATE TABLE product_sales_summary AS
SELECT
    Description,

    ROUND(SUM(SalesDollars), 2) AS Revenue,

    SUM(SalesQuantity) AS UnitsSold

FROM sales

GROUP BY Description;


SELECT *
FROM product_sales_summary
ORDER BY Revenue DESC;



/*Product Purchase Cost Summary*/

CREATE TABLE product_purchase_summary AS
SELECT
    Description,

    ROUND(SUM(Dollars), 2) AS PurchaseCost,

    SUM(Quantity) AS PurchaseQuantity

FROM purchases

GROUP BY Description;

SELECT *
FROM product_purchase_summary
ORDER BY PurchaseCost DESC;


/* Gross Profit Analysis
Goal

Compare:

sales revenue
procurement cost */
-- Create Sales Summary Table
CREATE TABLE sales_product_summary AS

SELECT
    Description,

    ROUND(SUM(SalesDollars), 2) AS Revenue,

    SUM(SalesQuantity) AS UnitsSold

FROM sales

GROUP BY Description;

-- Create Purchase Summary Table

CREATE TABLE purchase_product_summary AS

SELECT
    Description,

    ROUND(SUM(Dollars), 2) AS PurchaseCost,

    SUM(Quantity) AS PurchaseQuantity

FROM purchases

GROUP BY Description;


-- Product Profitability Analysis

SELECT
    s.Description,

    s.Revenue,

    p.PurchaseCost,

    ROUND(
        s.Revenue - p.PurchaseCost,
        2
    ) AS GrossProfit

FROM sales_product_summary s

JOIN purchase_product_summary p
ON s.Description = p.Description

ORDER BY GrossProfit DESC
LIMIT 20;


/* Profit Margin Analysis */

SELECT
    s.Description,

    s.Revenue,

    p.PurchaseCost,

    ROUND(
        s.Revenue - p.PurchaseCost,
        2
    ) AS GrossProfit,

    ROUND(
        (
            s.Revenue - p.PurchaseCost
        )
        /
        s.Revenue * 100,
        2
    ) AS ProfitMarginPercent

FROM sales_product_summary s

JOIN purchase_product_summary p
ON s.Description = p.Description

WHERE s.Revenue > 0

ORDER BY ProfitMarginPercent DESC;


/* Top Profitable Products */

SELECT
    s.Description,

    ROUND(
        s.Revenue - p.PurchaseCost,
        2
    ) AS GrossProfit

FROM sales_product_summary s

JOIN purchase_product_summary p
ON s.Description = p.Description

ORDER BY GrossProfit DESC
LIMIT 10;


/* Least Profitable Products*/
SELECT
    s.Description,

    ROUND(
        s.Revenue - p.PurchaseCost,
        2
    ) AS GrossProfit

FROM sales_product_summary s

JOIN purchase_product_summary p
ON s.Description = p.Description

ORDER BY GrossProfit ASC
LIMIT 10;


/* Loss-Making Products
Goal

Find negative-profit products. */

SELECT
    s.Description,

    s.Revenue,

    p.PurchaseCost,

    ROUND(
        s.Revenue - p.PurchaseCost,
        2
    ) AS GrossProfit

FROM sales_product_summary s

JOIN purchase_product_summary p
ON s.Description = p.Description

WHERE (
    s.Revenue - p.PurchaseCost
) < 0

ORDER BY GrossProfit ASC;


/* Brand Profitability Analysis */


-- Create Brand Revenue Summary
CREATE TABLE brand_sales_summary AS

SELECT
    Brand,

    ROUND(
        SUM(SalesDollars),
        2
    ) AS Revenue

FROM sales

GROUP BY Brand;


-- Create Brand Purchase Summary
CREATE TABLE brand_purchase_summary AS

SELECT
    Brand,

    ROUND(
        SUM(Dollars),
        2
    ) AS PurchaseCost

FROM purchases

GROUP BY Brand;

-- Brand Profitability Analysis

SELECT
    s.Brand,

    s.Revenue,

    p.PurchaseCost,

    ROUND(
        s.Revenue - p.PurchaseCost,
        2
    ) AS GrossProfit

FROM brand_sales_summary s

JOIN brand_purchase_summary p
ON s.Brand = p.Brand

ORDER BY GrossProfit DESC
LIMIT 10;


/* Store Profitability Analysis */
-- Create Store Purchase Summary
CREATE TABLE store_purchase_summary AS

SELECT
    Store,

    ROUND(
        SUM(Dollars),
        2
    ) AS PurchaseCost

FROM purchases

GROUP BY Store;




SELECT
    s.Store,

    s.Revenue,

    p.PurchaseCost,

    ROUND(
        s.Revenue - p.PurchaseCost,
        2
    ) AS GrossProfit

FROM store_sales_summary s

JOIN store_purchase_summary p
ON s.Store = p.Store

ORDER BY GrossProfit DESC;


/* Vendor Profitability Analysis */

CREATE TABLE vendor_sales_summary AS
-- Create Vendor Sales Summary
SELECT
    VendorName,

    ROUND(
        SUM(SalesDollars),
        2
    ) AS Revenue

FROM sales

GROUP BY VendorName;


-- Create Vendor Purchase Summary

CREATE TABLE vendor_purchase_summary AS

SELECT
    VendorName,

    ROUND(
        SUM(Dollars),
        2
    ) AS PurchaseCost

FROM purchases

GROUP BY VendorName;


-- Vendor Profitability Analysis

SELECT
    s.VendorName,

    s.Revenue,

    p.PurchaseCost,

    ROUND(
        s.Revenue - p.PurchaseCost,
        2
    ) AS GrossProfit

FROM vendor_sales_summary s

JOIN vendor_purchase_summary p
ON s.VendorName = p.VendorName

ORDER BY GrossProfit DESC
LIMIT 10;


/* High Margin Products
Goal

Premium profitable products.*/

SELECT
    s.Description,

    s.Revenue,

    ROUND(
        (
            s.Revenue - p.PurchaseCost
        )
        /
        s.Revenue * 100,
        2
    ) AS ProfitMarginPercent

FROM sales_product_summary s

JOIN purchase_product_summary p
ON s.Description = p.Description

WHERE s.Revenue > 1000

ORDER BY ProfitMarginPercent DESC
LIMIT 10;


/* Low Margin High Revenue Products
Goal

Revenue-heavy but low-profit products.*/

SELECT
    s.Description,

    s.Revenue,

    ROUND(
        (
            s.Revenue - p.PurchaseCost
        )
        /
        s.Revenue * 100,
        2
    ) AS ProfitMarginPercent

FROM sales_product_summary s

JOIN purchase_product_summary p
ON s.Description = p.Description

WHERE s.Revenue > 10000

ORDER BY ProfitMarginPercent ASC
LIMIT 10;



/* Overall Business Profitability KPIs*/

SELECT
    ROUND(
        SUM(s.Revenue),
        2
    ) AS TotalRevenue,

    ROUND(
        SUM(p.PurchaseCost),
        2
    ) AS TotalPurchaseCost,

    ROUND(
        SUM(s.Revenue) -
        SUM(p.PurchaseCost),
        2
    ) AS TotalGrossProfit,

    ROUND(
        (
            SUM(s.Revenue) -
            SUM(p.PurchaseCost)
        )
        /
        SUM(s.Revenue) * 100,
        2
    ) AS OverallProfitMargin

FROM sales_product_summary s

JOIN purchase_product_summary p
ON s.Description = p.Description;




/*
   =========================================================
   OVERALL BUSINESS PERFORMANCE
   =========================================================

   Total Revenue            : 451,736,859.55
   Total Purchase Cost      : 321,633,176.63
   Total Gross Profit       : 130,103,682.92
   Overall Profit Margin    : 28.80%

   INSIGHT:
   The business maintains a strong overall profitability level
   with nearly 29% gross margin, indicating efficient pricing
   and inventory management across most product categories.

   =========================================================
   PRODUCT REVENUE ANALYSIS
   =========================================================

   Highest revenue-generating products:

   • Jack Daniels No 7 Black      → 7.96M Revenue
   • Tito's Handmade Vodka        → 7.40M Revenue
   • Grey Goose Vodka             → 7.21M Revenue
   • Captain Morgan Spiced Rum    → 6.36M Revenue
   • Absolut 80 Proof             → 6.24M Revenue

   INSIGHT:
   Whiskey, vodka, and rum products dominate revenue generation,
   showing strong customer demand for premium spirit brands.

   =========================================================
   PRODUCT PURCHASE COST ANALYSIS
   =========================================================

   Products with highest procurement investment:

   • Jack Daniels No 7 Black
   • Tito's Handmade Vodka
   • Grey Goose Vodka
   • Absolut 80 Proof
   • Captain Morgan Spiced Rum

   INSIGHT:
   High procurement spending aligns closely with high sales demand,
   indicating efficient inventory purchasing for top-selling products.

   =========================================================
   GROSS PROFIT ANALYSIS
   =========================================================

   Most profitable products:

   • Jack Daniels No 7 Black      → 2.14M Profit
   • Grey Goose Vodka             → 1.95M Profit
   • Tito's Handmade Vodka        → 1.78M Profit
   • Captain Morgan Spiced Rum    → 1.73M Profit
   • Absolut 80 Proof             → 1.60M Profit

   INSIGHT:
   Premium liquor brands contribute significantly to gross profit
   and should remain strategic focus products.

   =========================================================
   PROFIT MARGIN ANALYSIS
   =========================================================

   Highest margin products include:

   • The Macallan Double Cask 12
   • DiSaronno Amaretto
   • Skinnygirl Tangerine Vodka
   • Beniotome Sesame Shochu

   Several products achieved profit margins above 99%.

   INSIGHT:
   Luxury and specialty beverages generate extremely high margins
   despite lower sales volumes.

   =========================================================
   TOP PROFITABLE PRODUCTS
   =========================================================

   Products contributing highest gross profit:

   • Jack Daniels No 7 Black
   • Grey Goose Vodka
   • Tito's Handmade Vodka
   • Captain Morgan Spiced Rum
   • Absolut 80 Proof

   INSIGHT:
   These products combine both strong sales volume and healthy
   profit margins, making them critical revenue drivers.

   =========================================================
   LEAST PROFITABLE PRODUCTS
   =========================================================

   Products generating highest losses:

   • Kilbeggan Irish Whiskey
   • Remy Martin XO Excellence
   • Whistle Pig Boss Hog Rye
   • Integre Vodka
   • Westland Trinity 3 Pack

   INSIGHT:
   These products show poor financial performance due to
   low sales relative to procurement cost.

   =========================================================
   LOSS-MAKING PRODUCT ANALYSIS
   =========================================================

   Several premium and specialty products generated negative profit.

   Key reasons may include:
   • Overstocking
   • Low customer demand
   • Excessive procurement pricing
   • Slow inventory turnover

   INSIGHT:
   Pricing strategy and procurement planning should be reviewed
   for consistently loss-making products.

   =========================================================
   BRAND PROFITABILITY ANALYSIS
   =========================================================

   Most profitable brands:

   • Brand 1233
   • Brand 4261
   • Brand 3545
   • Brand 8068
   • Brand 3405

   INSIGHT:
   Certain brands consistently outperform others and contribute
   heavily toward business profitability.

   =========================================================
   STORE PROFITABILITY ANALYSIS
   =========================================================

   Highest profit-generating stores:

   • Store 76 → 7.93M Profit
   • Store 73 → 6.67M Profit
   • Store 34 → 6.47M Profit
   • Store 38 → 5.94M Profit
   • Store 66 → 5.58M Profit

   INSIGHT:
   A few stores contribute disproportionately to total profits,
   indicating strong regional demand and operational efficiency.

   =========================================================
   VENDOR PROFITABILITY ANALYSIS
   =========================================================

   Most profitable vendors:

   • DIAGEO NORTH AMERICA INC
   • MARTIGNETTI COMPANIES
   • CONSTELLATION BRANDS INC
   • PERNOD RICARD USA
   • JIM BEAM BRANDS COMPANY

   INSIGHT:
   Strategic partnerships with major vendors drive substantial
   revenue and profitability for the business.

   =========================================================
   HIGH MARGIN PRODUCT ANALYSIS
   =========================================================

   Premium products with exceptional margins:

   • The Macallan Double Cask 12
   • Pezzi King Svgn Bl Dry Creek
   • DiSaronno Amaretto
   • Skinnygirl Tangerine Vodka

   INSIGHT:
   High-margin specialty products can significantly improve
   profitability despite relatively low sales quantities.

   =========================================================
   LOW MARGIN HIGH REVENUE ANALYSIS
   =========================================================

   Revenue-heavy but financially weak products:

   • Whistle Pig Boss Hog Rye
   • Kilbeggan Irish Whiskey
   • Remy Martin XO Excellence
   • Russian Standard Vodka

   INSIGHT:
   These products generate revenue but produce very poor margins,
   negatively impacting overall profitability.

   =========================================================
   FINAL BUSINESS INSIGHTS
   =========================================================

   • Premium spirit brands dominate both revenue and profitability.
   • High-performing vendors contribute major business value.
   • Several luxury products carry extremely high margins.
   • Some products create persistent financial losses and require
     pricing or inventory optimization.
   • Store-level profitability varies significantly across locations.
   • Strong overall gross margin indicates effective business operations.
   • Product mix optimization can further improve profitability.

========================================================= */