*
===============================================================================E
  EXEcution of the given data in a new query with clean result
  Stored Procedure: bronze.load_bronze
Description:
    Performs a full data refresh for the Bronze schema tables.
    - Empties existing target tables using TRUNCATE TABLE.
    - Ingests raw data from CRM and ERP CSV files via BULK INSERT.
    - Tracks and prints individual table load times and total batch runtime.
    - Catches and reports runtime errors.
===============================================================================
*/


EXEC bronze.load_bronze;

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
		DECLARE @start_time DATETIME, @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY

		SET @batch_start_time = GETDATE()

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT ' Load duration is ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT ' Load duration is ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT ' Load duration is ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT ' Load duration is ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT ' Load duration is ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' Load duration is ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';

		SET @batch_end_time = GETDATE()

		PRINT 'TOTAL TIME TAKEN ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + 'seconds'
	END TRY

	BEGIN CATCH
		PRINT 'ERROR OCCURED DURING THE EXECUTION OF BRONZE LAYER '
	END CATCH
END
