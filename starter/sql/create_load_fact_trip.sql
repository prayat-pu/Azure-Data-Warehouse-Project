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

CREATE EXTERNAL TABLE dbo.fact_trip
	WITH (
	LOCATION = 'fact_trip',
	DATA_SOURCE = [bikesharingfilesystem2_bikesharingaccount2_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
AS
SELECT
	ROW_NUMBER() over(order by trip.trip_id) as [fact_trip_id],
	rider.rider_id,
    FORMAT(trip.start_at, 'yyyy-MM-dd HH:mm:ss') AS start_at,
    FORMAT(trip.ended_at, 'yyyy-MM-dd HH:mm:ss') AS ended_at,
    trip.start_station_id,
    trip.end_station_id,
    DATEDIFF(minute, start_at, ended_at) AS 'Total_Mins'  
FROM [dbo].[staging_trip] as trip
JOIN [dbo].[staging_rider] as rider on trip.rider_id = rider.rider_id
GO


SELECT TOP 100 * FROM dbo.fact_trip
GO