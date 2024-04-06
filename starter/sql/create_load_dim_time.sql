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

CREATE EXTERNAL TABLE dbo.dim_time
	WITH (
	LOCATION = 'dim_time',
	DATA_SOURCE = [bikesharingfilesystem_bikesharinglakegen2_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
AS
SELECT DISTINCT start_at AS [datetime],
	DATEPART(MINUTE, start_at) AS [min],
    DATEPART(HOUR, start_at) AS [hour],
    DATEPART(DAY, start_at) AS [day],
    DATEPART(MONTH, start_at) AS [month],
    DATEPART(YEAR, start_at) AS [year],
    DATEPART(WEEKDAY, start_at) AS [dayofweek]
	from [dbo].[staging_trip]
UNION ALL
SELECT DISTINCT ended_at AS [datetime],
	DATEPART(MINUTE, ended_at) AS [min],
    DATEPART(HOUR, ended_at) AS [hour],
    DATEPART(DAY, ended_at) AS [day],
    DATEPART(MONTH, ended_at) AS [month],
    DATEPART(YEAR, ended_at) AS [year],
    DATEPART(WEEKDAY, ended_at) AS [dayofweek]
	from [dbo].[staging_trip]
UNION ALL
SELECT DISTINCT date AS [datetime],
	DATEPART(MINUTE, date) AS [min],
    DATEPART(HOUR, date) AS [hour],
    DATEPART(DAY, date) AS [day],
    DATEPART(MONTH, date) AS [month],
    DATEPART(YEAR, date) AS [year],
    DATEPART(WEEKDAY, date) AS [dayofweek]
	from [dbo].[staging_payment]
GO

SELECT TOP 100 * FROM dbo.dim_time
GO
