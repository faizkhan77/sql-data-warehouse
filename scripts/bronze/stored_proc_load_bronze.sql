CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;

	-- Declaring start and end time variables with datatype as DATETIME
	DECLARE @start_time DATETIME, @end_time DATETIME;

	SET @batch_start_time = GETDATE();

	BEGIN TRY
		PRINT '============================================================'
		PRINT 'LOADING BRONZE LAYER'
		PRINT '============================================================'

		PRINT '------------------------------------------------------'
		PRINT 'Loading CRM Tables'
		PRINT '------------------------------------------------------'
		
		-- Setting start_time variable using GETDATE()
		SET @start_time = GETDATE()

		-- Truncate means Empty the table fist before bulk insert
		-- Bcuz if we already had data in it, it would insert same data twice
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Faiz Khan\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			-- Since in the CSV file, first row is the header, and data start from 2nd row
			FIRSTROW = 2, -- Skip 1st row in the file
			FIELDTERMINATOR = ',', -- Define the Delimiter which seperates the columns
			TABLOCK
		);

		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Faiz Khan\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			-- Since in the CSV file, first row is the header, and data start from 2nd row
			FIRSTROW = 2, -- Skip 1st row in the file
			FIELDTERMINATOR = ',', -- Define the Delimiter which seperates the columns
			TABLOCK
		);

		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Faiz Khan\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			-- Since in the CSV file, first row is the header, and data start from 2nd row
			FIRSTROW = 2, -- Skip 1st row in the file
			FIELDTERMINATOR = ',', -- Define the Delimiter which seperates the columns
			TABLOCK
		);

		-- Setting end_time variable using GETDATE()
		SET @end_time = GETDATE()

		-- Now we can simply calculate the total time it took to run Loading of CRM Tables using DATEDIFF and casting it as Varchar
		PRINT '>> Load Duration of CRM Tables: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';




		PRINT '------------------------------------------------------'
		PRINT 'Loading ERP Tables'
		PRINT '------------------------------------------------------'

		SET @start_time = GETDATE()

		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Faiz Khan\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			-- Since in the CSV file, first row is the header, and data start from 2nd row
			FIRSTROW = 2, -- Skip 1st row in the file
			FIELDTERMINATOR = ',', -- Define the Delimiter which seperates the columns
			TABLOCK
		);

		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Faiz Khan\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			-- Since in the CSV file, first row is the header, and data start from 2nd row
			FIRSTROW = 2, -- Skip 1st row in the file
			FIELDTERMINATOR = ',', -- Define the Delimiter which seperates the columns
			TABLOCK
		);

		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Faiz Khan\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			-- Since in the CSV file, first row is the header, and data start from 2nd row
			FIRSTROW = 2, -- Skip 1st row in the file
			FIELDTERMINATOR = ',', -- Define the Delimiter which seperates the columns
			TABLOCK
		);

		SET @end_time = GETDATE()

		-- Setting end_time variable using GETDATE()
		SET @end_time = GETDATE()

		-- Now we can simply calculate the total time it took to run Loading of ERP Tables using DATEDIFF and casting it as Varchar
		PRINT '>> Load Duration of ERP Tables: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';


		SET @batch_end_time = GETDATE();
		
		PRINT '>> Load Duration whole batch: ' + CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';

	END TRY

	-- If error is found
	BEGIN CATCH
	PRINT '============================================================'
	PRINT 'ERROR OCCURED DURING THE LOADING OF THE BRONZE LAYER'
	PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
	PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER() AS NVARCHAR); --With cast we are simply converting the num value to varhcar
	PRINT 'ERROR MESSAGE' + CAST (ERROR_STATE() AS NVARCHAR);
	PRINT '============================================================'
	END CATCH
END;
