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
