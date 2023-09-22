import streamlit as st
import snowflake.connector
import os
import pandas as pd

snowflake_account = os.getenv("SNOWFLAKE_ACCOUNT")
snowflake_username = os.getenv("SNOWFLAKE_USERNAME")
snowflake_password = os.getenv("SNOWFLAKE_PASSWORD")
snowflake_role = os.getenv("SNOWFLAKE_ROLE")

conn = snowflake.connector.connect(
    user=snowflake_username,
    password=snowflake_password,
    account=snowflake_account,
    role=snowflake_role,
)

kpi_options = ["Total Transactions", "Total Clients", "Total Products", "Total Suppliers", "Total Revenue"]
selected_kpi = st.selectbox("Select KPI", kpi_options)

try:
    cs = conn.cursor()
    
    if selected_kpi == "Total Transactions":
        cs.execute("SELECT COUNT(*) FROM TRANSACTIONS_DATABASE.TRANSACTIONS_SCHEMA.TRANSACTIONS_TABLE")
        kpi_value = cs.fetchone()[0]
    elif selected_kpi == "Total Clients":
        cs.execute("SELECT COUNT(*) FROM CLIENTS_DATABASE.CLIENTS_SCHEMA.CLIENTS_TABLE")
        kpi_value = cs.fetchone()[0]
    elif selected_kpi == "Total Products":
        cs.execute("SELECT COUNT(*) FROM PRODUCTS_DATABASE.PRODUCTS_SCHEMA.PRODUCTS_TABLE")
        kpi_value = cs.fetchone()[0]
    elif selected_kpi == "Total Suppliers":
        cs.execute("SELECT COUNT(*) FROM SUPPLIERS_DATABASE.SUPPLIERS_SCHEMA.SUPPLIERS_TABLE")
        kpi_value = cs.fetchone()[0]
    elif selected_kpi == "Total Revenue":
        query = """
        SELECT SUM(t.AMOUNT * p.PRICE) as total_revenue
        FROM TRANSACTIONS_DATABASE.TRANSACTIONS_SCHEMA.TRANSACTIONS_TABLE t
        JOIN PRODUCTS_DATABASE.PRODUCTS_SCHEMA.PRODUCTS_TABLE p ON t.PRODUCT_ID = p.PRODUCT_ID
        JOIN CLIENTS_DATABASE.CLIENTS_SCHEMA.CLIENTS_TABLE c ON t.CLIENT_ID = c.CLIENT_ID
        """
        cs.execute(query)
        kpi_value = cs.fetchone()[0]
    
    st.metric(selected_kpi, kpi_value)
    
    cs.execute("""
    SELECT p.NAME, COUNT(*) as transaction_count
    FROM TRANSACTIONS_DATABASE.TRANSACTIONS_SCHEMA.TRANSACTIONS_TABLE t
    JOIN PRODUCTS_DATABASE.PRODUCTS_SCHEMA.PRODUCTS_TABLE p ON t.PRODUCT_ID = p.PRODUCT_ID
    GROUP BY p.NAME
    ORDER BY transaction_count DESC
    """)
    transactions_per_product = pd.DataFrame(cs.fetchall(), columns=['Product', 'Transaction Count'])
    st.bar_chart(transactions_per_product.set_index('Product'))
    
    cs.execute("""
    SELECT c.CLIENT_NAME, SUM(t.AMOUNT * p.PRICE) as total_revenue
    FROM TRANSACTIONS_DATABASE.TRANSACTIONS_SCHEMA.TRANSACTIONS_TABLE t
    JOIN PRODUCTS_DATABASE.PRODUCTS_SCHEMA.PRODUCTS_TABLE p ON t.PRODUCT_ID = p.PRODUCT_ID
    JOIN CLIENTS_DATABASE.CLIENTS_SCHEMA.CLIENTS_TABLE c ON t.CLIENT_ID = c.CLIENT_ID
    GROUP BY c.CLIENT_NAME
    ORDER BY total_revenue DESC
    """)
    revenue_per_client = pd.DataFrame(cs.fetchall(), columns=['Client', 'Total Revenue'])
    st.bar_chart(revenue_per_client.set_index('Client'))
    
finally:
    cs.close()
    conn.close()
