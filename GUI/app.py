import streamlit as st
import pandas as pd
import pyodbc
from datetime import date

# Function to fetch products from the database
def fetch_products(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT sp.supplier_product_id, p.product_name, sp.unit_price, s.supplier_name FROM Supplier_Product sp JOIN Product p ON sp.product_id = p.product_id JOIN Supplier s ON sp.supplier_id = s.supplier_id")
        products = cursor.fetchall()
        cursor.close()
        return products
    except Exception as e:
        st.error(f"Error fetching products: {e}")
        return []
def fetch_all_products(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT p.product_id, p.product_name FROM product p")
        products = cursor.fetchall()
        cursor.close()
        return products
    except Exception as e:
        st.error(f"Error fetching products: {e}")
        return []
# Function to create order
def create_order(conn, customer_id, cart_id, selected_products):
    order_date = date.today()
    total_amount = sum(product[5] for product in selected_products)
    try:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Orders ( customer_id, cart_id, order_date, total_amount, status) VALUES (?, ?, ?, ?, ?)",
                       (customer_id, cart_id, order_date, total_amount, "pending"))
        order_id = cursor.execute("SELECT @@IDENTITY").fetchone()[0]
        st.write(f"order #{order_id}")
        for product in selected_products:
            cursor.execute("INSERT INTO Order_Item (order_id, supplier_product_id, quantity_ordered, unit_price) VALUES (?, ?, ?, ?)",
                           (order_id, product[0], product[3], product[4]))
        conn.commit()
        cursor.close()
        st.success("Order placed successfully!")
    except Exception as e:
        st.error(f"Error creating order: {e}")
def order_cart(conn):
    st.title("Order Placement System")
    products = fetch_products(conn)

    # Display selected products sidebar
    st.sidebar.title("Cart")
    selected_products = []

    # Display products and quantity inputs
    for product in products:
        product_name, supplier_name, unit_price = product[1], product[3], product[2]
        quantity = st.sidebar.number_input(f"Quantity for {product_name} ({supplier_name}):", min_value=0)
        if quantity > 0:
            selected_products.append((product[0], product_name, supplier_name, quantity, unit_price, quantity * unit_price))

    # Display selected products in the sidebar
    if selected_products:
        st.write("### Cart Contents:")
        df = pd.DataFrame(selected_products,columns = ['id', 'product','supplier','qty','unit price', 'total price'])
        st.write(df)
        # for product in selected_products:
        #     st.write(product)
        if st.button("Place Order"):
            # Create order and order items
            create_order(conn, customer_id=1, cart_id=1, selected_products=selected_products)
            # Clear selected products after placing order
            selected_products.clear()
    else:
        st.write("No products selected.")
# Main function for Streamlit app
def fetch_supplier_products(conn, supplier_id):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT sp.supplier_product_id, p.product_name, sp.unit_price, sp.available_quantity FROM Supplier_Product sp JOIN Product p ON sp.product_id = p.product_id WHERE sp.supplier_id = ?", (supplier_id,))
        products = cursor.fetchall()
        cursor.close()
        return products
    except Exception as e:
        st.error(f"Error fetching supplier products: {e}")
        return []
def supplier_page(conn):
    st.title("Supplier Product Management")
    current_supplier_id = st.text_input("Supplier ID:", value="1")
    
    # Fetch products supplied by the current supplier
    supplier_products = fetch_supplier_products(conn, current_supplier_id)

    # Display products supplied by the current supplier
    if supplier_products:
        st.write("### Products Supplied by Current Supplier:")
        supplier_products = [tuple(line) for line in supplier_products]
        df_supplier_products = pd.DataFrame(supplier_products, columns=['Supplier Product ID', 'Product Name', 'Unit Price', 'Available Quantity'])
        st.write(df_supplier_products)
    else:
        st.write("No products supplied by the current supplier.")
    products = fetch_all_products(conn=conn)

    st.header("Add or Update Supplier Product")
    product_options = {product[1]: product[0] for product in products}  # Dictionary comprehension to map product names to IDs
    selected_product_name = st.selectbox("Select Product:", options=list(product_options.keys()))

    # Get the selected product ID
    selected_product_id = product_options[selected_product_name]
    unit_price = st.number_input("Unit Price:", step=0.01)
    quantity = st.number_input("Quantity:", min_value=0, step=1)
    if st.button("Update Product"):
        add_or_update_supplier_product(conn, current_supplier_id, selected_product_id, unit_price, quantity)


# Function to add or update supplier product
def add_or_update_supplier_product(conn, supplier_id, product_id, unit_price, quantity):
    try:
        cursor = conn.cursor()
        # Check if the product is already supplied by the supplier
        cursor.execute("SELECT * FROM Supplier_Product WHERE supplier_id = ? AND product_id = ?", (supplier_id, product_id))
        existing_product = cursor.fetchone()
        if existing_product:
            # If product exists, update the quantity
            cursor.execute("UPDATE Supplier_Product SET unit_price = ?, available_quantity = ? WHERE supplier_id = ? AND product_id = ?",
                           (unit_price, quantity, supplier_id, product_id))
            st.success("Product quantity updated successfully!")
        else:
            # If product doesn't exist, add it as a new supplier product
            cursor.execute("INSERT INTO Supplier_Product (supplier_id, product_id, unit_price, available_quantity) VALUES (?, ?, ?, ?)",
                           (supplier_id, product_id, unit_price, quantity))
            st.success("Product added to supplier successfully!")
        conn.commit()
        cursor.close()
    except Exception as e:
        st.error(f"Error adding or updating supplier product: {e}")

def main():

    # Connect to SQL Server
    connection_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=inv;UID=SA;PWD=Bandaru@123'
    conn = pyodbc.connect(connection_string)

    # Get customer ID (you may implement customer authentication here)
    customer_id = 1  # Assuming customer ID is always 1
    page = st.sidebar.radio("Navigation", ["Supplier Page", "Customer Page"])
    # Fetch products from the database
    if page=="Supplier Page":
        supplier_page(conn)
    else:
        order_cart(conn)

if __name__ == '__main__':
    main()
