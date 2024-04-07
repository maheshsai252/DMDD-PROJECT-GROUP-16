CREATE NONCLUSTERED INDEX IX_Customer_Name 
ON Customer(customer_name);

CREATE NONCLUSTERED INDEX IX_Customer_Email 
ON Customer(customer_email);

-- Non-clustered index for Product table
CREATE NONCLUSTERED INDEX IX_Product_Category_Id 
ON Product(product_category_id);

-- Non-clustered index for Orders table
CREATE NONCLUSTERED INDEX IX_Orders_Customer_Id 
ON Orders(customer_id);


-- Non-clustered index for ProductCategory table
CREATE NONCLUSTERED INDEX IX_ProductCategory_Name 
ON ProductCategory(product_category_name);

-- Non-clustered index for Supplier table
CREATE NONCLUSTERED INDEX IX_Supplier_Name 
ON Supplier(supplier_name);

-- Non-clustered index for Supplier_Product table
CREATE NONCLUSTERED INDEX IX_Supplier_Product_ProductId 
ON Supplier_Product(product_id);

-- Non-clustered index for Customer_Cart table
CREATE NONCLUSTERED INDEX IX_Customer_Cart_CustomerId 
ON Customer_Cart(customer_id);

-- Non-clustered index for Reviews table
CREATE NONCLUSTERED INDEX IX_Reviews_ProductId 
ON Reviews(product_id);

-- Non-clustered index for Payment_Transaction table
CREATE NONCLUSTERED INDEX IX_Payment_Transaction_CustomerId 
ON Payment_Transaction(customer_id);

-- Non-clustered index for Shipping table
CREATE NONCLUSTERED INDEX IX_Shipping_OrderId 
ON Shipping(order_id);
