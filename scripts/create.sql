CREATE TABLE Customer (
    customer_id INT PRIMARY KEY IDENTITY,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE ProductCategory (
    product_category_id INT PRIMARY KEY IDENTITY,
    product_category_name VARCHAR(255) NOT NULL,
    product_category_description VARCHAR(255)
);
CREATE TABLE Product(
    product_id INT PRIMARY KEY IDENTITY,
    product_name VARCHAR(255) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL,
    product_category_id INT NOT NULL,
    FOREIGN KEY (product_category_id) REFERENCES ProductCategory(product_category_id)
);
CREATE TABLE Address (
    supplier_address_id INT PRIMARY KEY,
    suplier_address VARCHAR(255),
    supplier_city VARCHAR(255),
    supplier_state VARCHAR(255),
    supplier_zip_code VARCHAR(10),
    is_primary_address BIT
);

CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    supplier_contact VARCHAR(75) NOT NULL,
    supplier_address_id INT,
    FOREIGN KEY (supplier_address_id) REFERENCES Address( supplier_address_id)
);
CREATE TABLE Supplier_Product (
    supplier_product_id  IDENTITY(1,1) PRIMARY KEY
    supplier_id INT NOT NULL,
    product_id INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    available_quantity INT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
CREATE TABLE Customer_Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
);
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY ,
    customer_id INT NOT NULL,
    cart_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'ordered','shipped', 'delivered')),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (cart_id) REFERENCES Customer_Cart(cart_id)
);
CREATE TABLE Order_Item (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    supplier_product_id INT NOT NULL,
    quantity_ordered INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (supplier_product_id) REFERENCES Supplier_Product(supplier_product_id)
);
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    review_rating INT NOT NULL CHECK (review_rating >= 1 AND review_rating <= 5),
    review_desc VARCHAR(200) NOT NULL,
    review_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
CREATE TABLE Payment_Transaction (
    transaction_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(255) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
CREATE TABLE Shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    shipping_date DATE NOT NULL,
    shipping_status VARCHAR(255) NOT NULL,
    tracking_number VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);