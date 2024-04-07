ALTER TABLE Orders
ADD CHECK (total_amount >= 0);

ALTER TABLE ProductCategory
ADD CHECK (LEN(product_category_name) <= 50); 

ALTER TABLE Product
ADD CHECK (product_price > 0);

CREATE FUNCTION dbo.ComputeTotalPrice(@quantity_ordered INT, @unit_price DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @total_price DECIMAL(10, 2);
    SET @total_price = @quantity_ordered * @unit_price;
    RETURN @total_price;
END;


ALTER TABLE Order_Item
ADD total_price AS dbo.ComputeTotalPrice(quantity_ordered, unit_price);

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

CREATE FUNCTION dbo.ComputeTaxAmount(@subtotal DECIMAL(10, 2), @tax_rate DECIMAL(5, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @tax_amount DECIMAL(10, 2);
    SET @tax_amount = @subtotal * (@tax_rate / 100.0);
    RETURN @tax_amount;
END;

ALTER TABLE Orders
ADD total_weight DECIMAL(10, 2),
    subtotal DECIMAL(10, 2),
    tax_rate DECIMAL(5, 2);

ALTER TABLE Orders
ADD shipping_cost AS dbo.CalculateShippingCost(total_weight);

ALTER TABLE Orders
ADD tax_amount AS dbo.ComputeTaxAmount(subtotal, tax_rate);