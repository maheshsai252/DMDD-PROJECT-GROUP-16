-- Stored Procedure to search products by category
CREATE PROCEDURE SearchProductsByCategory
    @category_name VARCHAR(255)
AS
BEGIN
    -- Select products based on the provided category name
    SELECT p.product_id,
           p.product_name,
           p.product_price,
           pc.product_category_name
    FROM Product p
    JOIN ProductCategory pc ON p.product_category_id = pc.product_category_id
    WHERE pc.product_category_name = @category_name;
END;
GO

-- Stored Procedure to get customer's cart
CREATE PROCEDURE GetCustomerCart
    @customer_id INT
AS
BEGIN
    -- Select products in the customer's cart based on customer ID
    SELECT cc.cart_id,
           cc.product_id,
           p.product_name,
           p.product_price
    FROM Customer_Cart cc
    JOIN Product p ON cc.product_id = p.product_id
    WHERE cc.customer_id = @customer_id;
END;
GO

-- Stored Procedure to get customer details by ID
CREATE PROCEDURE GetCustomerByID
    @customer_id INT,
    @customer_name VARCHAR(255) OUTPUT,
    @customer_email VARCHAR(255) OUTPUT,
    @customer_phone_number VARCHAR(20) OUTPUT
AS
BEGIN
    -- Retrieve customer details based on customer ID and output parameters
    SELECT @customer_name = customer_name,
           @customer_email = customer_email,
           @customer_phone_number = customer_phone_number
    FROM Customer
    WHERE customer_id = @customer_id;
END;
GO

-- Stored Procedure to insert a new product
CREATE PROCEDURE InsertProduct
    @product_name VARCHAR(255),
    @product_price DECIMAL(10, 2),
    @product_category_id INT
AS
BEGIN
    -- Insert new product with provided details
    INSERT INTO Product (product_name, product_price, product_category_id)
    VALUES (@product_name, @product_price, @product_category_id);
END;
GO

-- Stored Procedure to get order details
CREATE PROCEDURE GetOrderDetails
    @order_id INT,
    @customer_name VARCHAR(255) OUTPUT,
    @order_date DATE OUTPUT,
    @total_amount DECIMAL(10, 2) OUTPUT,
    @status VARCHAR(50) OUTPUT
AS
BEGIN
    -- Retrieve order details based on order ID and output parameters
    SELECT @customer_name = c.customer_name,
           @order_date = o.order_date,
           @total_amount = o.total_amount,
           @status = o.status
    FROM Orders o
    JOIN Customer c ON o.customer_id = c.customer_id
    WHERE o.order_id = @order_id;
END;
GO
