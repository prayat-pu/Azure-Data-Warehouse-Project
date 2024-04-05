IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 FIRST_ROW = 1,
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://bikesharingfilesystem2@bikesharingaccount2.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.staging_payment (
	[payment_id] bigint,
	[date] datetime2(0),
	[amount] float,
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'payment.csv',
	DATA_SOURCE = [bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_payment
GO