-- Calculate total beginning inventory investment.
USE retail_inventory_analysis;

SELECT 
    ROUND(SUM(onHand * Price), 2) AS TotalOpeningInventoryValue
FROM begin_inventory;

/* Total Closing Inventory Value */

SELECT 
    ROUND(SUM(onHand * Price), 2) AS TotalClosingInventoryValue
FROM end_inventory;


/* Total Inventory Units*/
SELECT 
    SUM(onHand) AS TotalOpeningInventoryUnits
FROM begin_inventory;

/* Top Products by Inventory Value
Find products consuming most inventory capital.*/

SELECT
    Description,
    ROUND(SUM(onHand * Price), 2) AS InventoryValue
FROM begin_inventory
GROUP BY Description
ORDER BY InventoryValue DESC
LIMIT 10;

/*Store-wise Inventory Value
Find stores holding highest stock value.*/

SELECT
    Store,
    ROUND(SUM(onHand * Price), 2) AS InventoryValue
FROM begin_inventory
GROUP BY Store
ORDER BY InventoryValue DESC;

/* Brand-wise Inventory Analysis*/

SELECT
    Brand,
    ROUND(SUM(onHand * Price), 2) AS InventoryValue
FROM begin_inventory
GROUP BY Brand
ORDER BY InventoryValue DESC
LIMIT 10;



SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;
SET GLOBAL wait_timeout = 28800;
SET GLOBAL interactive_timeout = 28800;
SET GLOBAL innodb_lock_wait_timeout = 600;

ALTER TABLE sales
ADD INDEX idx_inventoryid (InventoryId);




/* Dead Stock Analysis
Find products:

with inventory
but no sales*/

SELECT
    InventoryId,
    SUM(SalesQuantity) AS TotalSalesQty
FROM sales
GROUP BY InventoryId;


/*Dead Stock*/

CREATE TABLE sales_summary AS
SELECT
    InventoryId,
    SUM(SalesQuantity) AS TotalSalesQty
FROM sales
GROUP BY InventoryId;

SELECT
    b.InventoryId,
    b.Description,
    b.onHand,
    ROUND(b.onHand * b.Price, 2) AS InventoryValue
FROM begin_inventory b
LEFT JOIN sales_summary s
ON b.InventoryId = s.InventoryId
WHERE s.TotalSalesQty IS NULL
AND b.onHand > 0
ORDER BY InventoryValue DESC;



/*Overstock Analysis
Find products with:

very high inventory
low sales*/

SELECT InventoryId, SUM(SalesQuantity)
FROM sales
GROUP BY InventoryId;


SELECT
    b.InventoryId,
    b.Description,
    b.onHand,
    IFNULL(s.TotalSalesQty, 0) AS SalesQty,
    ROUND(b.onHand * b.Price, 2) AS InventoryValue
FROM begin_inventory b
LEFT JOIN sales_summary s
ON b.InventoryId = s.InventoryId
WHERE b.onHand > 50
AND IFNULL(s.TotalSalesQty, 0) < 10
ORDER BY InventoryValue DESC;


/*Inventory Movement Analysis

Compare opening vs closing stock.*/

SELECT
    b.InventoryId,
    b.Description,
    b.onHand AS OpeningStock,
    e.onHand AS ClosingStock,
    (e.onHand - b.onHand) AS StockChange
FROM begin_inventory b
JOIN end_inventory e
ON b.InventoryId = e.InventoryId
ORDER BY StockChange DESC;



/*Inventory Turnover Analysis

Measure inventory efficiency.*/

SELECT
    InventoryId,
    SUM(SalesQuantity)
FROM sales
GROUP BY InventoryId;


SELECT
    b.InventoryId,
    b.Description,

    ROUND(
        (b.onHand + e.onHand) / 2,
        2
    ) AS AverageInventory,

    IFNULL(s.TotalSalesQty, 0) AS SalesQuantity,

    ROUND(
        IFNULL(s.TotalSalesQty, 0) /
        NULLIF((b.onHand + e.onHand) / 2, 0),
        2
    ) AS InventoryTurnoverRatio

FROM begin_inventory b

JOIN end_inventory e
ON b.InventoryId = e.InventoryId

LEFT JOIN sales_summary s
ON b.InventoryId = s.InventoryId

ORDER BY InventoryTurnoverRatio DESC;



/*Low Turnover Products

Find slow-moving inventory.*/

SELECT
    *
FROM (
    SELECT
        b.InventoryId,
        b.Description,

        ROUND(
            IFNULL(s.TotalSalesQty, 0) /
            NULLIF((b.onHand + e.onHand) / 2, 0),
            2
        ) AS TurnoverRatio

    FROM begin_inventory b

    JOIN end_inventory e
    ON b.InventoryId = e.InventoryId

    LEFT JOIN sales_summary s
    ON b.InventoryId = s.InventoryId
) t

WHERE TurnoverRatio < 0.5
ORDER BY TurnoverRatio;




/* ================================
   Inventory Analysis — Summary
================================ */

/*
1. Overall Inventory Position
- Total beginning inventory investment was $68.05M.
- Closing inventory increased to $79.70M, indicating higher stock accumulation by year-end.
- Total inventory units across all stores reached 4.22M units.
- Rising closing inventory may indicate increased purchasing, slower sales movement, or stock buildup.
*/

/*
2. High-Value Inventory Products
- Premium liquor brands such as Jack Daniels, Grey Goose, Ketel One, Baileys, and Jameson hold the highest inventory value.
- These products consume a significant portion of inventory capital.
- Fast-selling premium brands require tight inventory monitoring and accurate demand forecasting.
*/

/*
3. Store-wise Inventory Insights
- Stores 34, 73, 67, 66, and 76 hold the highest inventory value.
- These stores likely represent major distribution or high-demand retail locations.
- High inventory concentration increases carrying cost and inventory risk.
*/

/*
4. Brand-wise Inventory Analysis
- Brands 3545, 1233, 8068, 4261, and 3858 contribute the highest inventory investment.
- Core premium brands dominate inventory allocation.
- Inventory planning should prioritize these high-investment brands.
*/

/*
5. Dead Stock Analysis
- Several luxury wines and premium products show inventory availability but zero sales.
- High-value dead stock includes:
    Glen Grant 50 Yr Scotch
    Ch Cheval Blanc
    Ch Lafite Rothschild
    Ch Haut Brion
- These products block working capital and increase holding costs.
- Dead stock products may require:
    discounts,
    promotional campaigns,
    inventory liquidation,
    or reduced future procurement.
*/

/*
6. Overstock Analysis
- Some products maintain very high inventory levels despite very low sales volume.
- Overstocked products include:
    Silver Oak Cab Svgn Napa,
    Piper Heidsieck Brut,
    Old Tahoe Honey Rye,
    Crown Royal Maple Whisky.
- Overstocking increases warehousing and capital costs.
- Purchasing policies should be adjusted for low-demand products.
*/

/*
7. Inventory Movement Analysis
- Products such as:
    Dr McGillicuddy's Mentholmnt,
    Tito's Handmade Vodka,
    Grey Goose Vodka,
    Absolut 80 Proof
  showed major stock increases during the year.
- Large stock increases may indicate:
    strong demand expectations,
    aggressive procurement,
    or replenishment strategy changes.
*/

/*
8. Inventory Turnover Analysis
- High turnover products include:
    Wild Turkey American Honey,
    Dr McGillicuddy's Root Beer,
    Bacardi Dragon Berry Rum,
    Andre Extra Dry.
- High turnover indicates efficient inventory movement and strong sales performance.
- These products should maintain higher safety stock levels to avoid stockouts.
*/

/*
9. Low Turnover Products
- Multiple products recorded turnover ratios near zero, indicating extremely slow sales.
- Slow-moving inventory includes:
    Ciroc Peach Vodka,
    Malibu Mango Rum,
    Johnnie Walker King George V,
    Hennessy Paradis.
- Low turnover products increase storage cost and reduce inventory efficiency.
*/

/*
10. Strategic Business Recommendations
- Maintain higher stock availability for fast-moving products.
- Reduce procurement of slow-moving and dead-stock items.
- Improve demand forecasting for premium inventory categories.
- Monitor inventory turnover regularly at store and product levels.
- Introduce promotional campaigns for overstocked products.
- Optimize inventory allocation across stores based on sales demand.
*/