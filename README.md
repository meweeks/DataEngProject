# Data Engineering Project

**Goal**

Transform and load data from s3 into an PSQL database and create user and order tables that can be queried by data analysts. 

**Process**
1. Get data
	- Get data JSON files from S3 input location 
	- Format data to CSV
	- Append CSVs 
	- Save to S3 output location
2. Copy data to database
	- Create orders_raw table in database
	- Copy CSV from s3 output location to orders_raw table
3. Transform data 
	- From orders_raw table create orders_table and users_table 

**Process Implementation**
1. Backfill Orders Data (_for daily run, substitute python file with `JSONtoCSVDaily.py`_)
	- Run JSONtoCSVBackfillPipeline in AWS Data Pipeline
		- `JSONtoCSVBackfillPipeline.json` - pipeline definition 
		- `ConfigShellCommands.sh` - shell commands needed to run pipeline (installs packages to EC2 instance)
		- `JSONtoCSVBackfill.py` - python script for copying and formatting data

2. Copy Data to database (_for daily run, change s3 location to `/Output/<today's date>.csv` and use `APPEND` instead of `TRUNCATE` activity_) 
	- Run S3toRDSDatabasePipeline in AWS Data Pipeline 
		- `S3toRDSDatabasePipeline.json` - pipeline definition
		- `OrdersRawInit.sql` - SQL script to create initial raw orders table

3. Transform Data into Accessible Tables
	- Run RunTransformationPipeline in AWS Data Pipeline 
		- `RunTransformationPipeline.json` - pipeline definition
		- `TransformationScripts.sql` - scripts to create orders_table and users_table

**Next Steps** 
- Change get data process to append JSON directly instead of transforming to CSV and load JSON data into the database; originally chose to transform the data for a different approach to the assignment
- Create Schedules.yaml file run pipelines with dependencies
- Add Schedules parameter to individual pipelines to reference
- Configure AWS + S3 using glossier's stack; having access to roles, etc. for productionizing the pipelines 
- Create additional transformations
	- parse json line_items field
	- create order_details table
- Add more data to the process 😁

**Limitations** 
- 4 hour time limit 
- Access to AWS s3, RDS Database -- this means that pipeline.json scripts are hypothetical; however, they have been tested with a local version of the json data and a local redshift cluster
