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

CREATE EXTERNAL TABLE dbo.dim_endat_trip_time
	WITH (
	LOCATION = 'dim_endat_trip_time',
	DATA_SOURCE = [bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
AS
SELECT ended_at AS [datetime],
	DATEPART(MINUTE, ended_at) AS [min],
    DATEPART(HOUR, ended_at) AS [hour],
    DATEPART(DAY, ended_at) AS [day],
    DATEPART(MONTH, ended_at) AS [month],
    DATEPART(YEAR, ended_at) AS [year],
    DATEPART(WEEKDAY, ended_at) AS [dayofweek]
	from [dbo].[staging_trip]
GO


SELECT TOP 100 * FROM dbo.dim_endat_trip_time
GO