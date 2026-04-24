# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "07e26036-dd74-4411-9950-917a6fb0c8cf",
# META       "default_lakehouse_name": "travs_LH",
# META       "default_lakehouse_workspace_id": "4882d616-5885-4827-bc97-aae3e41b1a1b",
# META       "known_lakehouses": [
# META         {
# META           "id": "07e26036-dd74-4411-9950-917a6fb0c8cf"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# MAGIC %%sql
# MAGIC --remove from bronze
# MAGIC DELETE FROM BronzeSales WHERE sale_id IN ('S3333', 'S3334');
# MAGIC 
# MAGIC -- Remove from silver
# MAGIC DELETE FROM silverSales 
# MAGIC WHERE sale_id = 'S3333' OR sale_id = 'S3334';
# MAGIC 
# MAGIC -- Truncate silver_rejected_rows, which has only 1 row
# MAGIC TRUNCATE TABLE silver_rejected_rows;


# METADATA ********************

# META {
# META   "language": "sparksql",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
