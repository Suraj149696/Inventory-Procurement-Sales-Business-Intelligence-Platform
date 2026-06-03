CREATE DATABASE retail_inventory_analysis;
USE retail_inventory_analysis;

-- 1. begin_inventory table

CREATE TABLE begin_inventory (
    InventoryId VARCHAR(100),
    Store INT,
    City VARCHAR(100),
    Brand INT,
    Description VARCHAR(255),
    Size VARCHAR(50),
    onHand INT,
    Price DECIMAL(10,2),
    startDate DATE,
    product_code INT,
    InventoryValue DECIMAL(12,2)
);

SHOW VARIABLES LIKE 'secure_file_priv';
SET GLOBAL local_infile = 1;
-- 2. end_inventory table

CREATE TABLE end_inventory (
    InventoryId VARCHAR(100),
    Store INT,
    City VARCHAR(100),
    Brand INT,
    Description VARCHAR(255),
    Size VARCHAR(50),
    onHand INT,
    Price DECIMAL(10,2),
    endDate DATE,
    InventoryValue DECIMAL(12,2)
);

-- 3. purchase_prices

CREATE TABLE purchase_prices (
    Brand INT,
    Description VARCHAR(255),
    Price DECIMAL(10,2),
    Size VARCHAR(50),
    Volume INT,
    Classification INT,
    PurchasePrice DECIMAL(10,2),
    VendorNumber INT,
    VendorName VARCHAR(255)
);

-- 4. purchases

CREATE TABLE purchases (
    InventoryId VARCHAR(100),
    Store INT,
    Brand INT,
    Description VARCHAR(255),
    Size VARCHAR(50),
    VendorNumber INT,
    VendorName VARCHAR(255),
    PONumber INT,
    PODate DATE,
    ReceivingDate DATE,
    InvoiceDate DATE,
    PayDate DATE,
    PurchasePrice DECIMAL(10,2),
    Quantity INT,
    Dollars DECIMAL(12,2),
    Classification INT
);


-- 5. sales 

CREATE TABLE sales (
    InventoryId VARCHAR(100),
    Store INT,
    Brand INT,
    Description VARCHAR(255),
    Size VARCHAR(50),
    SalesQuantity INT,
    SalesDollars DECIMAL(12,2),
    SalesPrice DECIMAL(10,2),
    SalesDate DATE,
    Volume DECIMAL(10,2),
    Classification INT,
    ExciseTax DECIMAL(10,2),
    VendorNo INT,
    VendorName VARCHAR(255)
);

--  6. vendor_invoice

CREATE TABLE vendor_invoice (
    VendorNumber INT,
    VendorName VARCHAR(255),
    InvoiceDate DATE,
    PONumber INT,
    PODate DATE,
    PayDate DATE,
    Quantity INT,
    Dollars DECIMAL(12,2),
    Freight DECIMAL(10,2),
    Approval VARCHAR(255)
);

SET GLOBAL max_allowed_packet = 1073741824;

SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;
SET GLOBAL wait_timeout = 28800;
SET GLOBAL interactive_timeout = 28800;

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/Suraj Jagtap/Desktop/Retail Inventory and Sales Optimization Analytics/data/cleaned/cleaned_sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;