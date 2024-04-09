-- Trigger to initiate shipping when payment status changes to 'success'
CREATE TRIGGER InitiateShippingOnPaymentSuccess
ON Payment_Transaction
AFTER UPDATE
AS
BEGIN
    IF UPDATE(payment_status)
    BEGIN
        DECLARE @order_id INT;

        -- Check if payment status changed to success
        IF (SELECT payment_status FROM inserted) = 'success'
        BEGIN
            -- Retrieve the order_id associated with the payment
            SELECT @order_id = order_id
            FROM inserted;

            -- Insert shipping record
            INSERT INTO Shipping (order_id, customer_id, shipping_date, shipping_status)
            SELECT order_id, customer_id, GETDATE(), 'pending'
            FROM Orders
            WHERE order_id = @order_id;
        END;
    END;
END;

-- Trigger to update order status to 'ordered' when payment transaction is successful
CREATE TRIGGER Update_Order_Status_On_Payment
ON Payment_Transaction
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @OrderID INT;

    -- Retrieve the order ID for the inserted or updated transaction
    SELECT @OrderID = order_id FROM inserted;

    -- Check if the transaction is successful
    IF (SELECT COUNT(*) FROM inserted WHERE payment_status = 'successful') > 0
    BEGIN
        -- Update the status of the associated order to 'ordered'
        UPDATE Orders
        SET status = 'ordered'
        WHERE order_id = @OrderID;
    END;
END;

-- Trigger to update available quantity of a product when an order item is inserted or updated
CREATE TRIGGER Update_Available_Quantity_On_Order
ON Order_Item
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @ProductID INT;
    DECLARE @QuantityOrdered INT;

    -- Retrieve the product ID and quantity ordered for the affected order item
    SELECT @ProductID = supplier_product_id, @QuantityOrdered = quantity_ordered FROM inserted;

    -- Update the available quantity of the product in the Supplier_Product table
    UPDATE Supplier_Product
    SET available_quantity = available_quantity - @QuantityOrdered
    WHERE supplier_product_id = @ProductID;
END;

-- Trigger to update order status based on shipping status
CREATE TRIGGER Update_Shipping_Status
ON Shipping
AFTER UPDATE
AS
BEGIN
    DECLARE @OrderID INT;

    SELECT @OrderID = order_id FROM inserted;

    -- Update the status of the associated order to match the shipping status
    UPDATE Orders
    SET status = (
        SELECT shipping_status
        FROM Shipping
        WHERE order_id = @OrderID
    )
    WHERE order_id = @OrderID;
END;
