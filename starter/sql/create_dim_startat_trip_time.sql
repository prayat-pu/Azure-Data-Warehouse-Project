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

CREATE EXTERNAL TABLE dbo.dim_startat_trip_time
	WITH (
	LOCATION = 'dim_startat_trip_time',
	DATA_SOURCE = [bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
AS
SELECT start_at AS [datetime],
	DATEPART(MINUTE, start_at) AS [min],
    DATEPART(HOUR, start_at) AS [hour],
    DATEPART(DAY, start_at) AS [day],
    DATEPART(MONTH, start_at) AS [month],
    DATEPART(YEAR, start_at) AS [year],
    DATEPART(WEEKDAY, start_at) AS [dayofweek]
	from [dbo].[staging_trip]
GO


SELECT TOP 100 * FROM dbo.dim_startat_trip_time
GO