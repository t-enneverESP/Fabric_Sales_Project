# Fabric_Sales_Project
A Git Repo synced to my Fabric Sales Pipeline Project
Parameterised Pipeline with Fabric
Many businesses may still manage their data in Excel. While this is fine, issues with scaling, file-sprawl, and version control may arise in the future. A parameterised pipeline in Fabric can solve this without the need for full migration, platform-switch, or extensive retraining of end-users across the organisation.

From raw files to monthly sales and top spenders in one automated process, here's how I created an automated, medallion workflow in Fabric to pull raw data into the Bronze layer, transform and load it into a Delta table in Silver, and deliver key metrics in Gold.

Note: The data used in this project is synthetic; no names or personal information are real.

1. The Foundation: Lakehouse & Pipeline
First, we needed a Lakehouse (Screenshot 1, travs_LH) and a pipeline (Screenshot 2, ingest_sales_pipeline). Lakehouses grant us abfss paths, with a section for managed tables and another for folders and files.

2. The Ingestion Layer (Bronze)
Pipelines allow us to pull data in batch. The first step is to configure a Copy Data Activity (Copy data1). To make this reusable, I used dynamic parameterisation for the source filepath (Screenshot 3).

I used the expression: raw/sales/@{pipeline().parameters.file_name}. This instructs Fabric to look inside the raw/sales directory for a specific file, allowing us to reuse the exact same pipeline for different files just by changing the parameter at runtime.

For the Destination (Screenshot 4), I pointed the pipeline toward the BronzeSales table. I manually configured the Mapping (Screenshot 5) to ensure column names and data types (like total_value as a decimal) were strictly enforced from the start.

3. Transformation & Quality Control (Silver)
Next, I created a Dataflow Gen2 (cleanflow) to standardise and transform the data (Screenshot 7).

Key Transformations:

Feature Engineering: Splitting customer_name into first and last names. This helps alleviate sprawl among customers with common names and allows for more personalised marketing.

Time Intelligence: I added month numbers to ensure proper date ordering in reports.

Proactive Error Handling: To keep the Silver layer clean, I implemented a "Conditional Path" (Screenshot 7c). I duplicated the query logic so that while valid data proceeds to the SilverSales table, any rows with a total_value of 0 or less are diverted to a separate rejected_rows sink for inspection.

4. Testing & Validation
To test the automation, I uploaded a test_sales.csv (Screenshot 12) and triggered the pipeline by entering the filename as a parameter (Screenshot 13).

The test was successful: the valid rows landed in Silver, while the intentional "error" row (Value = 0) landed in the rejected_rows table for follow-up (Screenshot 15). To keep the production environment clean, I used a SparkSQL Notebook (Screenshot 17) to purge these specific test rows (S3333, S3334) once the validation was complete.

5. Business Intelligence (Gold)
I designed the pipeline so that once the Bronze and Silver layers are loaded, the Gold Layer runs views on the Silver table to deliver business metrics. I created two dynamic views: total_sales and top_spenders (Screenshots 18, 19).

By using SQL Views for Gold, I ensured the business logic remains decoupled from physical storage. While the Silver layer maintains high-precision decimals (Screenshot 8), I used the Gold views to polish the final output into clean, readable integers for executive reporting (Screenshot 21).

Scalability & Reflections
Although I built this pipeline with ~1,000 rows, it was designed for scalability. Fabric's capacity for large batch operations means this solution can easily scale to millions of rows.

Git and Version Control
Finally, I took advantage of Fabric's Git integration to sync my pipeline and its related items. To get started, I created two new workspaces, cleaned_sales and deployment_sales, and set up a formal Deployment Pipeline (22, 23, 23b). After clicking into 'Deployment Pipelines' and creating one named "Sales-Analytics-Medallion" (24), I named my stages (25) and connected the workspaces until the full lifecycle was established (26).

The Fabric UI is a bit specific here; when you first assign an existing workspace to a stage, you have to sync the content to make sure the stages match. I used selective deployment to pull the specific items I needed from my Development workspace into Test (27, 27b). Since these items were already finished and tested earlier in the project, I then deployed them straight through to Production.

With the deployment pipeline finished and items successfully live in the Production workspace (28), I headed over to the workspace settings to sync it to Git (29). To get the connection working, I went to GitHub > Settings > Developer Settings to generate the Personal Access Token (PAT) required by Fabric (30). I gave the token a note, selected the required scopes (31), and created the Git repo: Fabric_Sales_Project (32).

Finally, the workspace was ready to sync (33, 34, 34b). With the final sync settings completed, new options appeared on the interface confirming the connection was live (35). All the project metadata and code are now reflected and version-controlled on GitHub (36).

I worked on this project while studying for my DP-700 exam and learned a lot about the Fabric ecosystem. I’d appreciate any feedback or advice! The underlying CSV files and code used can be found within this Git repo. Thanks for reading.
