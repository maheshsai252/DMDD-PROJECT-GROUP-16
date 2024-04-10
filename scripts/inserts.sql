-- Sample data for Customer table
INSERT INTO Customer (customer_name, customer_email, customer_phone_number)
VALUES
    ('John Doe', 'john@example.com', '123-456-7890'),
    ('Jane Smith', 'jane@example.com', '987-654-3210'),
    ('Alice Johnson', 'alice@example.com', '456-789-0123'),
    ('Bob Brown', 'bob@example.com', '789-012-3456'),
    ('Emily Davis', 'emily@example.com', '012-345-6789'),
    ('Michael Wilson', 'michael@example.com', '345-678-9012'),
    ('Jessica Lee', 'jessica@example.com', '678-901-2345'),
    ('David Martinez', 'david@example.com', '901-234-5678'),
    ('Sarah Taylor', 'sarah@example.com', '234-567-8901'),
    ('Daniel Anderson', 'daniel@example.com', '567-890-1234');

-- Sample data for ProductCategory table
INSERT INTO ProductCategory (product_category_name, product_category_description)
VALUES
    ('Electronics', 'Electronic gadgets and devices'),
    ('Clothing', 'Apparel and fashion accessories'),
    ('Books', 'Books and literature'),
    ('Home & Kitchen', 'Household appliances and kitchenware');

-- Sample data for Product table
INSERT INTO Product (product_name, product_price, product_category_id)
VALUES
    ('Smartphone', 499.99, 1),
    ('Laptop', 999.99, 1),
    ('T-shirt', 19.99, 2),
    ('Jeans', 39.99, 2),
    ('Novel', 14.99, 3),
    ('Cookware Set', 79.99, 4),
    ('Coffee Maker', 49.99, 4),
    ('Headphones', 99.99, 1),
    ('Dress', 29.99, 2),
    ('Tablet', 299.99, 1);

-- Sample data for Address table
INSERT INTO Address ( suplier_address, supplier_city, supplier_state, supplier_zip_code, is_primary_address)
VALUES
    ('123 Main St', 'Anytown', 'AnyState', '12345', 1),
    ( '456 Elm St', 'Another Town', 'AnotherState', '54321', 1),
    ( '789 Oak St', 'Yet Another Town', 'YetAnotherState', '98765', 1),
    ('321 Pine St', 'One More Town', 'OneMoreState', '56789', 1),
    ( '678 Maple St', 'Some Town', 'SomeState', '34567', 1),
    ( '890 Cedar St', 'Different Town', 'DifferentState', '87654', 1),
    ( '234 Birch St', 'New Town', 'NewState', '23456', 1),
    ( '901 Walnut St', 'Old Town', 'OldState', '67890', 1),
    ( '543 Spruce St', 'Ancient Town', 'AncientState', '45678', 1),
    ( '765 Ash St', 'Modern Town', 'ModernState', '89012', 1);

-- Sample data for Supplier table
INSERT INTO Supplier (supplier_name, supplier_contact, supplier_address_id)
VALUES
    ( 'TechGadgets Inc.', 'John Smith', 1),
    ( 'FashionHub', 'Jane Doe', 2),
    ('BookWorms Ltd.', 'Alice Johnson', 3),
    ('Home Essentials Co.', 'Bob Brown', 4),
    ('ElectroShop', 'Emily Davis', 5),
    ( 'KitchenMasters', 'Michael Wilson', 6),
    ( 'AudioEmporium', 'Jessica Lee', 7),
    ( 'ApplianceWorld', 'David Martinez', 8),
    ( 'ClothingCorner', 'Sarah Taylor', 9),
    ( 'TechEmpire', 'Daniel Anderson', 10);

-- Sample data for Supplier_Product table
INSERT INTO Supplier_Product (supplier_id, product_id, unit_price, available_quantity)
VALUES
    (1, 1, 479.99, 100),
    (1, 2, 899.99, 50),
    (2, 3, 17.99, 200),
    (2, 4, 34.99, 150),
    (3, 5, 12.99, 300),
    (4, 6, 69.99, 80),
    (4, 7, 44.99, 100),
    (5, 8, 89.99, 120),
    (6, 9, 27.99, 250),
    (7, 10, 279.99, 70);

-- Sample data for Customer_Cart table
INSERT INTO Customer_Cart ( customer_id)
VALUES
    (1),(2),(3),(4),(5),(6),(7),(8),(9),(10)

-- Sample data for Orders table
INSERT INTO Orders ( customer_id, cart_id, order_date, total_amount, status)
VALUES
    ( 1, 1, '2024-03-15', 499.99, 'pending'),
    ( 2, 2, '2024-03-17', 999.99, 'pending'),
    ( 3, 3, '2024-03-18', 39.99, 'pending'),
    ( 4, 4, '2024-03-19', 14.99, 'pending'),
    (5, 5, '2024-03-20', 69.99, 'pending'),
    (6, 6, '2024-03-21', 44.99, 'pending'),
    (7, 7, '2024-03-22', 89.99, 'pending'),
    ( 8, 8, '2024-03-23', 27.99, 'pending'),
    ( 9, 9, '2024-03-24', 279.99, 'pending'),
    ( 10, 10, '2024-03-24', 279.99, 'pending');
-- Sample data for Order_Item table
INSERT INTO Order_Item (order_id, supplier_product_id, quantity_ordered, unit_price)
VALUES
    (1, 1, 1, 499.99),
    (2, 3, 2, 19.99),
    (3, 2, 1, 999.99),
    (4, 4, 1, 39.99),
    ( 5, 5, 1, 14.99),
    ( 6, 6, 1, 69.99),
    (7, 7, 1, 44.99),
    (8, 8, 1, 89.99),
    (9, 9, 1, 27.99),
    (10, 9, 1, 27.99);

-- Sample data for Reviews table
INSERT INTO Reviews (product_id, customer_id, review_rating, review_desc, review_date)
VALUES
    ( 1, 1, 5, 'Great phone!', '2024-03-16'),
    ( 3, 1, 4, 'Nice T-shirt.', '2024-03-17'),
    ( 2, 2, 5, 'Excellent laptop.', '2024-03-18'),
    ( 4, 3, 3, 'Average jeans.', '2024-03-19'),
    ( 5, 4, 2, 'Not satisfied with the book.', '2024-03-20'),
    ( 6, 5, 5, 'Fantastic cookware set!', '2024-03-21'),
    ( 7, 6, 4, 'Good headphones.', '2024-03-22'),
    ( 8, 7, 3, 'Okay coffee maker.', '2024-03-23'),
    ( 9, 8, 5, 'Love the dress!', '2024-03-24'),
    ( 10, 9, 4, 'Great tablet.', '2024-03-25');

-- Sample data for Payment_Transaction table
INSERT INTO Payment_Transaction (customer_id, order_id, payment_date, amount, payment_status)
VALUES
    (1, 1, '2024-03-17', 499.99, 'success'),
    (1, 2, '2024-03-18', 39.99, 'pending'),
    (2, 3, '2024-03-19', 999.99, 'pending'),
    (3, 4, '2024-03-20', 39.99, 'pending'),
    (4, 5, '2024-03-21', 14.99, 'success'),
    (5, 6, '2024-03-22', 69.99, 'success'),
    (6, 7, '2024-03-23', 44.99, 'pending'),
    (7, 8, '2024-03-24', 89.99, 'success'),
    (8, 9, '2024-03-25', 27.99, 'success');
    (8, 9, '2024-03-10', 27.99, 'failed');
-- Sample data for Shipping table
INSERT INTO Shipping (order_id, customer_id, shipping_date, shipping_status, tracking_number)
VALUES
    (1, 1, '2024-03-17', 'success', '1234567890'),
    (5, 5, '2024-03-22', 'pending', '1234566890'),
    (6, 6, '2024-03-23', 'success', '0234566890'),
    (8, 8, '2024-03-25', 'pending', '1234066890'),
    (9, 9, '2024-03-26', 'success', '3456789012');
    (2, 2, '2024-03-26', 'success', '3456782012');
    (3, 3, '2024-03-26', 'success', '3452789012');
    (4, 4, '2024-03-26', 'success', '3456729012');
    (7, 7, '2024-03-26', 'success', '3256789012');
    (10, 10, '2024-03-26', 'success', '1456789012');