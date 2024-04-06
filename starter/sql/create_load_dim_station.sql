IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bikesharingfilesystem_bikesharinglakegen2_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [bikesharingfilesystem_bikesharinglakegen2_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://bikesharingfilesystem@bikesharinglakegen2.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.dim_station
	WITH (
	LOCATION = 'dim_station',
	DATA_SOURCE = [bikesharingfilesystem_bikesharinglakegen2_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
AS
SELECT station_id,
	   name,
	   latitude,
	   longitude
FROM [dbo].[staging_station]
GO


SELECT TOP 100 * FROM dbo.dim_station
GO