
## “Crafting a Robust DevOps Journey: Terraform & Snowflake for Scalable Data Solutions”

![](https://cdn-images-1.medium.com/max/3840/1*UezeBJ9-LxeZiFJUht8_8A.jpeg)

## Introduction

In this article, we will explore the journey of a fictitious company, TechShop, as it seeks to establish a robust and scalable data infrastructure. TechShop, an online retailer specializing in various tech products, aims to manage and analyze data related to sales, customers, products, and suppliers. This article will provide insights into the planning, development, and results of this Proof of Concept (POC), offering a detailed guide for those looking to achieve similar goals.

## Contexte / Problématique

TechShop handles approximately 100,000 transactions per month, dealing with structured data from diverse sources such as Order Management Systems, CRM, and Inventory Management Systems. The challenge is to integrate these varied data sources into a unified platform, ensuring performance, security, and compliance with local data protection regulations.

## Objectifs

* Develop a scalable and secure data infrastructure.

* Integrate diverse data sources into Snowflake.

* Ensure timely generation of daily reports.

* Comply with data protection regulations.

## Prérequis

* Basic knowledge of Terraform and Snowflake.

* Understanding of data warehousing concepts.

* Familiarity with Python for scripting.

## Configuration

We will utilize Terraform for infrastructure management and Snowflake as the data warehouse. The architecture includes databases for Clients, Transactions, Products, and Suppliers, each containing relevant information. Computation warehouses will be set up for different environments, with role-based access controls and encryption policies ensuring data security.

## Diagram Flow:

![](https://cdn-images-1.medium.com/max/2000/1*BFCGq07P2cEimvhgiqhQpw.png)

### 1. Terraform Scripts Configuration Block

    terraform {
      required_providers {
        snowflake = {
          source  = "chanzuckerberg/snowflake"
          version = "0.25.0"  
        }
      }
    }

* Purpose: Specifies the required providers and their versions.

* Details: This block is telling Terraform that the Snowflake provider is required and it should use version “0.25.0” from the source “chanzuckerberg/snowflake”.

## 2. Provider Block

    provider "snowflake" {
      account  = var.snowflake_account
      username = var.snowflake_username
      password = var.snowflake_password
      role     = var.snowflake_role
    }

* Purpose: Configures the Snowflake provider with necessary credentials.

* Details: The provider block is where you specify the credentials to access your Snowflake account. It uses variables (e.g., var.snowflake_account) which should be defined elsewhere in your Terraform code or in a separate variables file.

## 3. Resource Blocks for Databases, Schemas, and Tables

    resource "snowflake_database" "clients_database" {
      name = "CLIENTS_DATABASE"
    }
    ...

* Purpose: Defines various Snowflake resources such as databases, schemas, tables, and their configurations.

* Details: Multiple resource blocks are used to create different databases (e.g., "CLIENTS_DATABASE", "TRANSACTIONS_DATABASE"), schemas within those databases, and tables within those schemas. Each table has columns defined with a name and type.

## 4. Resource Blocks for Warehouses

    resource "snowflake_warehouse" "main_warehouse" {
      name           = "MAIN_WAREHOUSE"
      warehouse_size = "X-SMALL"
      auto_suspend   = 60
      auto_resume    = true
      initially_suspended = true
    }
    ...

* Purpose: Creates Snowflake virtual warehouses for computing resources.

* Details: Several warehouses are defined with different names and configurations. Warehouses are used to execute SQL queries in Snowflake, and their size and other settings can be configured.

## 5. Role and User Creation

    resource "snowflake_role" "data_analyst" {
      name = "DATA_ANALYST"
    }
    ...
    resource "snowflake_user" "data_analyst" {
      name     = var.data_analyst_username
      password = var.data_analyst_password
      default_role = snowflake_role.data_analyst.name
    }

* Purpose: Defines a role and a user in Snowflake and associates the user with the role.

* Details: A role named “DATA_ANALYST” is created, and a user is created with the username and password specified by the variables var.data_analyst_username and var.data_analyst_password. The user is assigned the "DATA_ANALYST" role as the default role.

## 6. Granting Privileges

    resource "snowflake_database_grant" "data_analyst_clients_db_grant" {
      database_name = snowflake_database.clients_database.name
      privilege     = "USAGE"
      roles         = [snowflake_role.data_analyst.name]
    }
    ...

* Purpose: Grants specific privileges to the “DATA_ANALYST” role on various resources.

* Details: The “DATA_ANALYST” role is granted “USAGE” and “SELECT” privileges on various databases, schemas, tables, and warehouses, allowing the user with this role to access and query the data.

## 7. Running Python Script

    resource "null_resource" "ingest_data" {
      provisioner "local-exec" {
        command = "python ingest.py"
      }

* Purpose: Executes a Python script named ingest.py.

* Details: This block uses a null_resource with a local-exec provisioner to run a Python script, presumably to ingest data into the Snowflake tables.

## 8. Variables

    variable "data_analyst_username" {
      description = "User Name for DATA_ANALYST"
      type        = string
    }
    ...

* Purpose: Defines input variables for the Terraform script.

* Details: Variables such as data_analyst_username and data_analyst_password are defined to be used as input for creating the Snowflake user.

### 2. Data Ingestion (ingest.py)

Python script using the Faker library to generate and insert fake data into the corresponding tables in Snowflake.

### 3. Data Visualization (app.py)

Streamlit application that connects to Snowflake, allows users to select KPIs, executes queries, and displays the results.

![](https://cdn-images-1.medium.com/max/3142/1*yiZWDjf98pcHpQNwmNdF1A.png)

## Getting Started

Before deploying the Terraform solution, you need to have a Snowflake account. If you don’t have one yet, you can create one for free by following the steps below:

### Create a Snowflake Account:

* Visit [Snowflake Signup](https://signup.snowflake.com/?utm_source=google&utm_medium=paidsearch&utm_campaign=na-ca-en-brand-core-exact&utm_content=go-eta-evg-ss-free-trial&utm_term=c-g-snowflake-e&_bt=579189975080&_bk=snowflake&_bm=e&_bn=g&_bg=136172937548&gclsrc=aw.ds&gad=1&gclid=Cj0KCQjw9rSoBhCiARIsAFOipll6opQEHCJpYGSPxgKikBsb-DxvqdkywRLG-Y0PZO_ecJoUXYM2JKwaAuedEALw_wcB).

* Fill out the registration form with your information.

* Follow the instructions in the confirmation email to activate your account.

### Install Terraform:

* If you haven’t installed Terraform yet, download and install it from [Terraform Downloads](https://www.terraform.io/downloads.html).

### Configure Variables:

* In your Terraform code, make sure to define the necessary variables such as snowflake_account, snowflake_username, snowflake_password, snowflake_role, data_analyst_username, and data_analyst_password.

* You can set them in a terraform.tfvars file or enter them manually when Terraform prompts you.

### Initialize Terraform:

* Open a terminal and navigate to the directory containing the Terraform script.

* Run the command terraform init to initialize Terraform and download the Snowflake provider.

### Apply the Terraform Plan:

* Run the command terraform apply to view Terraform's execution plan.

* If you are satisfied with the plan, type yes to apply the changes and deploy the resources in Snowflake.

## Post-Deployment Verification and Testing

Once the infrastructure is deployed, it is crucial to verify that the databases, tables, and data are correctly set up, and to test the permissions associated with the DATA_ANALYST role. Follow the steps below to ensure everything is functioning as expected:

 1. Verify Databases and Tables:

* Log in to your Snowflake account.

* Check that the databases CLIENTS_DATABASE, TRANSACTIONS_DATABASE, PRODUCTS_DATABASE, and SUPPLIERS_DATABASE have been created.

![](https://cdn-images-1.medium.com/max/3798/1*6fUxN6f1WRrUDrqQXQLXiA.png)

* Within each database, verify that the corresponding schemas and tables are present and correctly structured.

* Ensure that the tables contain the expected data, especially if you have used a script like ingest.py to populate them.

![](https://cdn-images-1.medium.com/max/3022/1*ukJrwWfMD8BiuBAY216GYQ.png)

 1. Test DATA_ANALYST Role:

* Log out of your current Snowflake session.

* Log back in using the following credentials:

![](https://cdn-images-1.medium.com/max/2000/1*mrzFvhFKvYu-5d8NWltgZw.png)

* Username: DATA_ANALYST

* Password: D4t4_An4ly$t!c$2023

* Once logged in, switch to the DATA_ANALYST role.

* Try executing SELECT queries on the tables in the various databases to ensure that you can view the data.

![](https://cdn-images-1.medium.com/max/3790/1*0ez6vRka8qiN0YPtrPiNkA.png)

* Attempt to perform an UPDATE operation on one of the tables to verify whether the DATA_ANALYST role has the necessary permissions. If the role is read-only, the UPDATE should fail, indicating that the permissions are set correctly.

![](https://cdn-images-1.medium.com/max/3818/1*W5p6WbIe8UExkZOGapqKEQ.png)

 1. Review Results:

* Review the results of your queries and any attempted updates to ensure that the role permissions and data access align with your expectations.

* If any discrepancies are found, review the Terraform script and your Snowflake settings to identify and correct any configuration issues.

By following these additional steps, you can confirm that the databases and tables are correctly set up with data and that the DATA_ANALYST role has the appropriate permissions for querying and updating the data.

## Conclusion

Throughout this guide, you have learned how to build a robust and scalable data infrastructure using Terraform and Snowflake within a DevOps environment. The detailed steps have enabled you to deploy databases, schemas, tables, and compute warehouses, while managing roles and privileges to ensure data security.

This approach not only provides you with a structured and automated method for managing your data resources but also facilitates the scalability and adaptability of your infrastructure to the changing needs of your business. By incorporating these practices into your DevOps journey, you are positioning your organization to fully leverage the power of data and cloud technology.

## Cleaning Up Resources

After verifying and testing your infrastructure, it is important to clean up the resources created to avoid unnecessary costs. To do this, you can use the terraform destroy command. This command will remove all the resources created by Terraform in your Snowflake account.

    terraform destroy

Terraform will ask for confirmation that you wish to delete the resources. Type yes to proceed with the deletion. Ensure to verify that all resources have been properly deleted in your Snowflake account.

In conclusion, utilizing Terraform and Snowflake within a DevOps framework allows you to build robust and scalable data solutions while optimizing costs and enhancing operational efficiency. We hope this guide has been helpful and encourage you to explore further the possibilities offered by these tools to meet the specific needs of your organization.

[Github](https://medium.com/@stefentaime_10958/crafting-a-robust-devops-journey-terraform-snowflake-for-scalable-data-solutions-34fc24b2f877)
