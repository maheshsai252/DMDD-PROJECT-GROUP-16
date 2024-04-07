CREATE PROCEDURE SearchProductsByCategory
    @category_name VARCHAR(255)
AS
BEGIN
    SELECT p.product_id,
           p.product_name,
           p.product_price,
           pc.product_category_name
    FROM Product p
    JOIN ProductCategory pc ON p.product_category_id = pc.product_category_id
    WHERE pc.product_category_name = @category_name;
END;
GO

-- Stored Procedure 7: Get Customer Cart
CREATE PROCEDURE GetCustomerCart
    @customer_id INT
AS
BEGIN
    SELECT cc.cart_id,
           cc.product_id,
           p.product_name,
           p.product_price
    FROM Customer_Cart cc
    JOIN Product p ON cc.product_id = p.product_id
    WHERE cc.customer_id = @customer_id;
END;
GO

-- Stored Procedure 1: Get Customer by ID
CREATE PROCEDURE GetCustomerByID
    @customer_id INT,
    @customer_name VARCHAR(255) OUTPUT,
    @customer_email VARCHAR(255) OUTPUT,
    @customer_phone_number VARCHAR(20) OUTPUT
AS
BEGIN
    SELECT @customer_name = customer_name,
           @customer_email = customer_email,
           @customer_phone_number = customer_phone_number
    FROM Customer
    WHERE customer_id = @customer_id;
END;
GO

-- Stored Procedure 2: Insert New Product
CREATE PROCEDURE InsertProduct
    @product_name VARCHAR(255),
    @product_price DECIMAL(10, 2),
    @product_category_id INT
AS
BEGIN
    INSERT INTO Product (product_name, product_price, product_category_id)
    VALUES (@product_name, @product_price, @product_category_id);
END;
GO

-- Stored Procedure 3: Get Order Details
CREATE PROCEDURE GetOrderDetails
    @order_id INT,
    @customer_name VARCHAR(255) OUTPUT,
    @order_date DATE OUTPUT,
    @total_amount DECIMAL(10, 2) OUTPUT,
    @status VARCHAR(50) OUTPUT
AS
BEGIN
    SELECT @customer_name = c.customer_name,
           @order_date = o.order_date,
           @total_amount = o.total_amount,
           @status = o.status
    FROM Orders o
    JOIN Customer c ON o.customer_id = c.customer_id
    WHERE o.order_id = @order_id;
END;
GO
