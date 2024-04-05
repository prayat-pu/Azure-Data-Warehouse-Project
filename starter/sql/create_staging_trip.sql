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

CREATE EXTERNAL TABLE dbo.staging_trip (
	[trip_id] nvarchar(50),
	[rideable_type] nvarchar(75),
	[start_at] datetime2(0),
	[ended_at] datetime2(0),
	[start_station_id] nvarchar(50),
	[end_station_id] nvarchar(50),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'trip.csv',
	DATA_SOURCE = [bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_trip
GO