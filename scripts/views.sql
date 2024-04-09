-- View 1: Product Information with Category
CREATE VIEW ProductInfoWithCategory
AS
SELECT p.product_id,
       p.product_name,
       p.product_price,
       pc.product_category_name
FROM Product p
JOIN ProductCategory pc ON p.product_category_id = pc.product_category_id;
GO

-- View 2: Customer Orders Summary
CREATE VIEW CustomerOrdersSummary
AS
SELECT c.customer_id,
       c.customer_name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
GO

-- View 3: High Rated Products
CREATE VIEW HighRatedProducts
AS
SELECT p.product_id,
       p.product_name,
       AVG(r.review_rating) AS average_rating
FROM Product p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.review_rating) >= 4.5; -- Consider products with average rating of 4.5 or higher
GO

-- View: Order_Summary
CREATE VIEW Order_Summary AS
SELECT o.order_id,
       o.order_date,
       o.total_amount,
       o.status,
       c.customer_name,
       COUNT(oi.order_item_id) AS total_items
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
LEFT JOIN Order_Item oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, o.total_amount, o.status, c.customer_name, c.customer_email, c.customer_phone_number;
