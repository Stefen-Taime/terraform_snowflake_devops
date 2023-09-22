terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.0"  
    }
  }
}

provider "snowflake" {
  account  = var.snowflake_account
  username = var.snowflake_username
  password = var.snowflake_password
  role     = var.snowflake_role
}

# Création de la base de données pour les clients
resource "snowflake_database" "clients_database" {
  name = "CLIENTS_DATABASE"
}

# Création du schéma pour les clients
resource "snowflake_schema" "clients_schema" {
  database = snowflake_database.clients_database.name
  name     = "CLIENTS_SCHEMA"
}

# Création de la table pour les clients
resource "snowflake_table" "clients_table" {
  database = snowflake_database.clients_database.name
  schema   = snowflake_schema.clients_schema.name
  name     = "CLIENTS_TABLE"
  column {
    name = "CLIENT_ID"
    type = "STRING"
  }
  column {
    name = "CLIENT_NAME"
    type = "STRING"
  }
  column {
    name = "CLIENT_ADDRESS"
    type = "STRING"
  }
}

# Base de Données des Transactions
resource "snowflake_database" "transactions_database" {
  name = "TRANSACTIONS_DATABASE"
}

resource "snowflake_schema" "transactions_schema" {
  database = snowflake_database.transactions_database.name
  name     = "TRANSACTIONS_SCHEMA"
}

resource "snowflake_table" "transactions_table" {
  database = snowflake_database.transactions_database.name
  schema   = snowflake_schema.transactions_schema.name
  name     = "TRANSACTIONS_TABLE"
  column {
    name = "TRANSACTION_ID"
    type = "STRING"
  }
  column {
    name = "CLIENT_ID"
    type = "STRING"
  }
  column {
    name = "PRODUCT_ID"
    type = "STRING"
  }
  column {
    name = "DATE"
    type = "DATE"
  }
  column {
    name = "AMOUNT"
    type = "FLOAT"
  }
}

# Base de Données des Produits
resource "snowflake_database" "products_database" {
  name = "PRODUCTS_DATABASE"
}

resource "snowflake_schema" "products_schema" {
  database = snowflake_database.products_database.name
  name     = "PRODUCTS_SCHEMA"
}

resource "snowflake_table" "products_table" {
  database = snowflake_database.products_database.name
  schema   = snowflake_schema.products_schema.name
  name     = "PRODUCTS_TABLE"
  column {
    name = "PRODUCT_ID"
    type = "STRING"
  }
  column {
    name = "NAME"
    type = "STRING"
  }
  column {
    name = "DESCRIPTION"
    type = "STRING"
  }
  column {
    name = "PRICE"
    type = "FLOAT"
  }
}

# Base de Données des Fournisseurs
resource "snowflake_database" "suppliers_database" {
  name = "SUPPLIERS_DATABASE"
}

resource "snowflake_schema" "suppliers_schema" {
  database = snowflake_database.suppliers_database.name
  name     = "SUPPLIERS_SCHEMA"
}

resource "snowflake_table" "suppliers_table" {
  database = snowflake_database.suppliers_database.name
  schema   = snowflake_schema.suppliers_schema.name
  name     = "SUPPLIERS_TABLE"
  column {
    name = "SUPPLIER_ID"
    type = "STRING"
  }
  column {
    name = "NAME"
    type = "STRING"
  }
  column {
    name = "ADDRESS"
    type = "STRING"
  }
}

# Création de l'entrepôt de calcul
resource "snowflake_warehouse" "main_warehouse" {
  name           = "MAIN_WAREHOUSE"
  warehouse_size = "X-SMALL"
  auto_suspend   = 60
  auto_resume    = true
  initially_suspended = true
}

# Entrepôts de Calcul pour chaque environnement
resource "snowflake_warehouse" "dev_warehouse" {
  name           = "DEV_WAREHOUSE"
  warehouse_size = "X-SMALL"
  auto_suspend   = 60
  auto_resume    = true
  initially_suspended = true
}

resource "snowflake_warehouse" "test_warehouse" {
  name           = "TEST_WAREHOUSE"
  warehouse_size = "X-SMALL"
  auto_suspend   = 60
  auto_resume    = true
  initially_suspended = true
}

resource "snowflake_warehouse" "prod_warehouse" {
  name           = "PROD_WAREHOUSE"
  warehouse_size = "MEDIUM"  # Taille adaptée pour la production
  auto_suspend   = 60
  auto_resume    = true
  initially_suspended = true
}

resource "snowflake_role" "data_analyst" {
  name = "DATA_ANALYST"
}


# Privilleges sur les bases de données
resource "snowflake_database_grant" "data_analyst_clients_db_grant" {
  database_name = snowflake_database.clients_database.name
  privilege     = "USAGE"
  roles         = [snowflake_role.data_analyst.name]
}

resource "snowflake_database_grant" "data_analyst_transactions_db_grant" {
  database_name = snowflake_database.transactions_database.name
  privilege     = "USAGE"
  roles         = [snowflake_role.data_analyst.name]
}

resource "snowflake_database_grant" "data_analyst_products_db_grant" {
  database_name = snowflake_database.products_database.name
  privilege     = "USAGE"
  roles         = [snowflake_role.data_analyst.name]
}

resource "snowflake_database_grant" "data_analyst_suppliers_db_grant" {
  database_name = snowflake_database.suppliers_database.name
  privilege     = "USAGE"
  roles         = [snowflake_role.data_analyst.name]
}



# privilèges SELECT à DATA_ANALYST pour toutes les tables
resource "snowflake_table_grant" "analyst_clients_table_grant" {
  database_name = snowflake_database.clients_database.name
  schema_name   = snowflake_schema.clients_schema.name
  table_name    = snowflake_table.clients_table.name
  privilege     = "SELECT"
  roles         = [snowflake_role.data_analyst.name]
}

resource "snowflake_table_grant" "analyst_transactions_table_grant" {
  database_name = snowflake_database.transactions_database.name
  schema_name   = snowflake_schema.transactions_schema.name
  table_name    = snowflake_table.transactions_table.name
  privilege     = "SELECT"
  roles         = [snowflake_role.data_analyst.name]
}

resource "snowflake_table_grant" "analyst_products_table_grant" {
  database_name = snowflake_database.products_database.name
  schema_name   = snowflake_schema.products_schema.name
  table_name    = snowflake_table.products_table.name
  privilege     = "SELECT"
  roles         = [snowflake_role.data_analyst.name]
}

resource "snowflake_table_grant" "analyst_suppliers_table_grant" {
  database_name = snowflake_database.suppliers_database.name
  schema_name   = snowflake_schema.suppliers_schema.name
  table_name    = snowflake_table.suppliers_table.name
  privilege     = "SELECT"
  roles         = [snowflake_role.data_analyst.name]
}

# privilèges USAGE à DATA_ANALYST pour le schéma des clients
resource "snowflake_schema_grant" "analyst_clients_schema_grant" {
  database_name = snowflake_database.clients_database.name
  schema_name   = snowflake_schema.clients_schema.name
  privilege     = "USAGE"
  roles         = [snowflake_role.data_analyst.name]
}

# privilèges USAGE à DATA_ANALYST pour le schéma des transactions
resource "snowflake_schema_grant" "analyst_transactions_schema_grant" {
  database_name = snowflake_database.transactions_database.name
  schema_name   = snowflake_schema.transactions_schema.name
  privilege     = "USAGE"
  roles         = [snowflake_role.data_analyst.name]
}

# privilèges USAGE à DATA_ANALYST pour le schéma des produits
resource "snowflake_schema_grant" "analyst_products_schema_grant" {
  database_name = snowflake_database.products_database.name
  schema_name   = snowflake_schema.products_schema.name
  privilege     = "USAGE"
  roles         = [snowflake_role.data_analyst.name]
}

# privilèges USAGE à DATA_ANALYST pour le schéma des fournisseurs
resource "snowflake_schema_grant" "analyst_suppliers_schema_grant" {
  database_name = snowflake_database.suppliers_database.name
  schema_name   = snowflake_schema.suppliers_schema.name
  privilege     = "USAGE"
  roles         = [snowflake_role.data_analyst.name]
}

variable "data_analyst_username" {
  description = "Nom d'utilisateur pour DATA_ANALYST"
  type        = string
}

variable "data_analyst_password" {
  description = "Mot de passe pour DATA_ANALYST"
  type        = string
  sensitive   = true
}
# Run Python script
resource "null_resource" "ingest_data" {
  provisioner "local-exec" {
    command = "python ingest.py"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}


resource "snowflake_user" "data_analyst" {
  name     = var.data_analyst_username
  password = var.data_analyst_password
  default_role = snowflake_role.data_analyst.name
}


resource "snowflake_role_grants" "data_analyst_user_grant" {
  role_name = snowflake_role.data_analyst.name
  users     = [snowflake_user.data_analyst.name]
}

resource "snowflake_warehouse_grant" "data_analyst_dev_warehouse_grant" {
  warehouse_name = snowflake_warehouse.dev_warehouse.name
  privilege      = "USAGE"
  roles          = [snowflake_role.data_analyst.name]
}



