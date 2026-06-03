-- ==========================================
-- TABLE RELATIONSHIPS
-- ==========================================

-- begin_inventory ↔ end_inventory
-- Key: InventoryId

-- sales ↔ purchases
-- Key: InventoryId

-- purchases ↔ vendor_invoice
-- Key: PONumber

-- purchases ↔ purchase_prices
-- Key: Brand

-- sales ↔ purchase_prices
-- Key: Brand