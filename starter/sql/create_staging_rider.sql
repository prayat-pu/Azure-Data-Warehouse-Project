IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://bikesharingfilesystem2@bikesharingaccount2.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.staging_rider (
	[rider_id] bigint,
	[first] nvarchar(50),
	[last] nvarchar(50),
	[address] nvarchar(100),
	[birthday] datetime2(0),
	[account_start_date] datetime2(0),
	[account_end_date] datetime2(0),
	[is_member] bit
	)
	WITH (
	LOCATION = 'rider.csv',
	DATA_SOURCE = [bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_rider
GO