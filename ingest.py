import snowflake.connector
from faker import Faker

fake = Faker()

conn = snowflake.connector.connect(
    user='OPENDAY',
    password='Congo27*',
    account='onjvluv-pz57452',
    warehouse='MAIN_WAREHOUSE',
)
cur = conn.cursor()

client_ids = []
for _ in range(100):
    client_id = fake.uuid4()
    client_ids.append(client_id)
    client_name = fake.name()
    client_address = fake.address().replace('\n', ', ')
    try:
        cur.execute(f"USE DATABASE CLIENTS_DATABASE;")
        cur.execute(f"USE SCHEMA CLIENTS_SCHEMA;")
        cur.execute(f"INSERT INTO CLIENTS_TABLE (CLIENT_ID, CLIENT_NAME, CLIENT_ADDRESS) VALUES ('{client_id}', '{client_name}', '{client_address}')")
    except Exception as e:
        print(f"Erreur lors de l'insertion des données dans CLIENTS_DATABASE.CLIENTS_SCHEMA.CLIENTS_TABLE : {e}")

product_ids = []
for client_id in client_ids:
    transaction_id = fake.uuid4()
    product_id = fake.uuid4()
    product_ids.append(product_id)
    date = fake.date()
    amount = fake.random_number(digits=5, fix_len=True)
    try:
        cur.execute(f"USE DATABASE TRANSACTIONS_DATABASE;")
        cur.execute(f"USE SCHEMA TRANSACTIONS_SCHEMA;")
        cur.execute(f"INSERT INTO TRANSACTIONS_TABLE (TRANSACTION_ID, CLIENT_ID, PRODUCT_ID, DATE, AMOUNT) VALUES ('{transaction_id}', '{client_id}', '{product_id}', '{date}', {amount})")
    except Exception as e:
        print(f"Erreur lors de l'insertion des données dans TRANSACTIONS_DATABASE.TRANSACTIONS_SCHEMA.TRANSACTIONS_TABLE : {e}")

for product_id in product_ids:
    name = fake.name()
    description = fake.text()
    price = fake.random_number(digits=5, fix_len=True) / 100
    try:
        cur.execute(f"USE DATABASE PRODUCTS_DATABASE;")
        cur.execute(f"USE SCHEMA PRODUCTS_SCHEMA;")
        cur.execute(f"INSERT INTO PRODUCTS_TABLE (PRODUCT_ID, NAME, DESCRIPTION, PRICE) VALUES ('{product_id}', '{name}', '{description}', {price})")
    except Exception as e:
        print(f"Erreur lors de l'insertion des données dans PRODUCTS_DATABASE.PRODUCTS_SCHEMA.PRODUCTS_TABLE : {e}")

supplier_ids = []
for _ in range(50):
    supplier_id = fake.uuid4()
    supplier_ids.append(supplier_id)
    name = fake.company()
    address = fake.address().replace('\n', ', ')
    try:
        cur.execute(f"USE DATABASE SUPPLIERS_DATABASE;")
        cur.execute(f"USE SCHEMA SUPPLIERS_SCHEMA;")
        cur.execute(f"INSERT INTO SUPPLIERS_TABLE (SUPPLIER_ID, NAME, ADDRESS) VALUES ('{supplier_id}', '{name}', '{address}')")
    except Exception as e:
        print(f"Erreur lors de l'insertion des données dans SUPPLIERS_DATABASE.SUPPLIERS_SCHEMA.SUPPLIERS_TABLE : {e}")

cur.close()
conn.close()
