-- Add a check constraint to ensure total amount in Orders table is non-negative
ALTER TABLE Orders
ADD CHECK (total_amount >= 0);

-- Add a check constraint to limit the length of product category name in ProductCategory table
ALTER TABLE ProductCategory
ADD CHECK (LEN(product_category_name) <= 50); 

-- Add a check constraint to ensure product price in Product table is positive
ALTER TABLE Product
ADD CHECK (product_price > 0);

-- Create a scalar-valued user-defined function to compute the total price for an order item
CREATE FUNCTION dbo.ComputeTotalPrice(@quantity_ordered INT, @unit_price DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @total_price DECIMAL(10, 2);
    SET @total_price = @quantity_ordered * @unit_price;
    RETURN @total_price;
END;

-- Add a computed column to calculate the total price for each order item
ALTER TABLE Order_Item
ADD total_price AS dbo.ComputeTotalPrice(quantity_ordered, unit_price);

-- Create a scalar-valued user-defined function to calculate shipping cost based on total weight
CREATE FUNCTION dbo.CalculateShippingCost(@total_weight DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @shipping_cost DECIMAL(10, 2);
    IF @total_weight <= 5
        SET @shipping_cost = 5.00;
    ELSE
        SET @shipping_cost = 5.00 + ((@total_weight - 5) * 1.50); -- Additional $1.50 per pound over 5 pounds
    RETURN @shipping_cost;
END;
-- Add computed columns for shipping cost and tax amount to the Orders table
ALTER TABLE Orders
ADD total_weight DECIMAL(10, 2),
    subtotal DECIMAL(10, 2),
    tax_rate DECIMAL(5, 2);
-- Add a computed column to calculate the shipping cost for each order
ALTER TABLE Orders
ADD shipping_cost AS dbo.CalculateShippingCost(total_weight);

-- Create a scalar-valued user-defined function to compute the tax amount based on subtotal and tax rate
CREATE FUNCTION dbo.ComputeTaxAmount(@subtotal DECIMAL(10, 2), @tax_rate DECIMAL(5, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @tax_amount DECIMAL(10, 2);
    SET @tax_amount = @subtotal * (@tax_rate / 100.0);
    RETURN @tax_amount;
END;

-- Add a computed column to calculate the tax amount for each order
ALTER TABLE Orders
ADD tax_amount AS dbo.ComputeTaxAmount(subtotal, tax_rate);
